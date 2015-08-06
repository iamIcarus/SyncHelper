//
//  Parser.h
//  Generic RSS-JSON Parser
//
//  Created by AYLON-4 on 27/01/15.
//  Copyright (c) 2015 AYLON-4. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "RSS_Item.h"

extern NSString *const kNotificationAsynchSuccess;
extern NSString *const kNotificationAsynchFailed;


@protocol ParserDelegate <NSObject>
@required
- (void) processAsynchronousRSSComplete:(NSArray*)data;
- (void) processAsynchronousRSSFailed:(NSArray*)data;

@end

@interface Parser : NSObject
{
    // Delegate to respond back
    id <ParserDelegate> _delegate;
    int timeoutRequest;

}
@property (nonatomic,strong) id delegate;
@property (nonatomic,strong) id mData;


+ (id)sharedInstance ;
- (id) requestSynchronousDataFromRssWith:(NSString*)classname andAlias:(NSDictionary*)alias andURL:(NSString*)mLinkURL;
- (void) requestAsynchronousDataFromRssWith:(NSString*)classname andAlias:(NSDictionary*)alias andURL:(NSString*)mLinkURL;
- (id) requestSynchronousDataFromJsonWithClass:(NSString*)classname andAlias:(NSDictionary*)alias andURL:(NSString*)mLinkURL;
@end
