//
//  Parser.m
//  Generic RSS-JSON Parser
//
//  Created by AYLON-4 on 27/01/15.
//  Copyright (c) 2015 AYLON-4. All rights reserved.
//

#import "Parser.h"
#import "XMLReader.h"
#import "ASIHTTPRequest.h"
#import "MyChanel.h"

#define kTimeoutForHTTPRequest                      30 // 30 seconds
NSString *const kNotificationAsynchSuccess = @"AsynchronousTaskSuccess";
NSString *const kNotificationAsynchFailed = @"AsynchronousTaskFailed";

@implementation Parser

/**
 *  Singletton
 *
 *  @return Shared Instance
 */
+ (id)sharedInstance {
    static Parser *sharedMyParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyParser = [[self alloc] init];
    });
    return sharedMyParser;
}

/**
 *  Initialize variables
 *
 *  @return return self instance
 */
-(id) init {
    self = [super init];
    if (self) {
        timeoutRequest = -1;
    }
    return(self);
}


/**
 *  Sets a new timout interval
 *
 *  @param timeout New timemout interval
 */
-(void)setRequestTimeout:(int)timeout
{
    timeoutRequest = timeout;
}



/**
 *   Synchronous HTTP GET Request
 *
 *  @param URL String link for HTTP request
 *
 *  @return Sreing responce
 */
-(NSString*) SynchronousGETFromString:(NSString*)URL
{
    
    NSURL *url = [NSURL URLWithString:URL];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    if(timeoutRequest == -1)
        [request setTimeOutSeconds:kTimeoutForHTTPRequest];
    else
        [request setTimeOutSeconds:timeoutRequest];
    
    [request startSynchronous];
    NSError *error = [request error];
    
    if (!error)
        return [request responseString];
    
    return nil;
}

/**
 *  Synchronous HTTP GET Request and RSS parsing service method
 *
 *  @param classname Name of the custom Channel class
 *  @param alias     Aliases for custom mapping
 *  @param mLinkURL  RSS link to parse
 *
 *  @return returns an RSS item
 */
-(id) requestSynchronousDataFromRssWith:(NSString*)classname andAlias:(NSDictionary*)alias andURL:(NSString*)mLinkURL
{
    
    NSString *responce = [self SynchronousGETFromString:mLinkURL];
    
    if(responce != nil)
        return [self parseRSSString:responce withClass:classname andAlias:alias andURL:mLinkURL];

    return nil;

}


/**
 *  Asynchronous  HTTP GET Request and RSS parsing service method
 *
 *  @param classname Name of the custom Channel class
 *  @param alias     Aliases for custom mapping
 *  @param mLinkURL  RSS link to parse
 *
 *  @return returns an RSS item
 */
- (void) requestAsynchronousDataFromRssWith:(NSString*)classname andAlias:(NSDictionary*)alias andURL:(NSString*)mLinkURL
{
    NSURL *url = [NSURL URLWithString:mLinkURL];
    
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    if(timeoutRequest == -1)
        [request setTimeOutSeconds:kTimeoutForHTTPRequest];
    else
        [request setTimeOutSeconds:timeoutRequest];

    
    //Asynchronous Successfull completion block
    [request setCompletionBlock:^{
        // Use when fetching text data
        
        NSString* response = [request responseString];
        self.mData =[self parseRSSString:response withClass:classname andAlias:alias andURL:mLinkURL];
        
        
        //Delegate response
        RSS_Item* item= [self parseRSSString:response withClass:classname andAlias:alias andURL:mLinkURL];
        NSArray* arrArguments  = [[NSArray alloc] initWithObjects:item,mLinkURL, nil];
        
        [self.delegate performSelector:@selector(processAsynchronousRSSComplete:) withObject:arrArguments];
        
        
        //Notify Observer
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAsynchSuccess object:self];

        response = nil;
        
    }];
    
    
    //Asynchronous Failed block
    [request setFailedBlock:^{
        
        NSError *error = [request error];
        
        //Delegate response
        NSArray* arrArguments  = [[NSArray alloc] initWithObjects:error,mLinkURL, nil];
        [self.delegate performSelector:@selector(processAsynchronousRSSFailed:) withObject:arrArguments];
        
        //Notify Obeserver
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAsynchFailed object:self];

    }];
    
    [request startAsynchronous];
}



/**
 *  Parse rss from url. Returns an RSS object and can get a custom Channel Model object with customized rss returned elements.
 *  Can handle Aliases for custom element mapping
 *
 *  @param data      XML string to parse
 *  @param classname Name of the custom Channel class
 *  @param alias     Aliases for custom mapping
 *  @param mLinkURL  RSS link to parse
 *
 *  @return returns an RSS item
 */
- (id) parseRSSString:(NSString*)data withClass:(NSString*)classname andAlias:(NSDictionary*)alias andURL:(NSString*)mLinkURL
{
    NSError *parseError = nil;
    
    //Map XML string to Dictionary
    NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLString:data error:&parseError];
    NSDictionary* rss = [xmlDictionary objectForKey:@"rss"];
    
    NSMutableDictionary* channel = [rss objectForKey:@"channel"];
    
    NSMutableDictionary* tmpChanel =[channel mutableCopy];
    
    // remap keys from aliases
    if(alias != nil)
    {
        for (id aliasKey in alias)
            for (id rootKey in channel)
                if([aliasKey isEqualToString:rootKey])
                {
                    id oldObj = [channel objectForKey: rootKey];
                    [tmpChanel setObject: oldObj forKey:[alias objectForKey: aliasKey]];
                    [tmpChanel removeObjectForKey:rootKey];
                    
                    break;
                }
        
        channel = tmpChanel;
    }
    
    // init RSS_Item from dictionary
    RSS_Item* ret = [[RSS_Item alloc]initWithDictionary:rss];
    
    
    
    // Use custom chanel class
    if(classname != nil)
    {
        id tmp = [[NSClassFromString(classname) alloc] initWithDictionary:channel];
        ret.channel = tmp;
    }
    
    return ret;
}


/**
 *  Returns the mapping of a custom class from JSON  string
 *
 *  @param data      JSON string data
 *  @param classname Name of the custom class
 *  @param alias     Aliases for custom mapping
 *  @param mLinkURL  RSS link to parse
 *
 *  @return returns custom class object
 */
- (id) parseJsonString:(NSString*)data withClass:(NSString*)classname andAlias:(NSDictionary*)alias andURL:(NSString*)mLinkURL
{

    //Map JSON string to NSDictionary (JSON.h)
        NSDictionary *responseJSON = [data JSONValue];
    
    //Map NSDictionary to Class
        id ret = [[NSClassFromString(classname) alloc] initWithDictionary:responseJSON];
    
    
    return ret;
}

/**
 *  Synchronous HTTP GET Request and JSON parsing service methode
 *
 *  @param classname Name of the custom class
 *  @param alias     Aliases for custom mapping
 *  @param mLinkURL  RSS link to parse
 *
 *  @return returns an RSS item
 */
- (id) requestSynchronousDataFromJsonWithClass:(NSString*)classname andAlias:(NSDictionary*)alias andURL:(NSString*)mLinkURL
{
    
    NSString *responce = [self SynchronousGETFromString:mLinkURL];

    if(responce != nil)
        return [self parseJsonString:responce withClass:classname andAlias:alias andURL:mLinkURL];
    
    return nil;

}



@end
