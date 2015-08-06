//
//  SyncHelper.m
//  SyncHelper
//
//  Created by AYLON-4 on 03/02/15.
//  Copyright (c) 2015 AYLON-4. All rights reserved.
//

#import "SyncHelper.h"

//SyncHelper Observer keys
NSString *const kNotificationSyncCompleteSuccess = @"NotificationSyncCompleteSuccess";
NSString *const kNotificationSyncCompleteFailed = @"NotificationSyncFailed";

@implementation SyncHelper


#pragma mark Singleton Methods
/**
 *  Singletton - A shared instance of the Database Module. Also Initialize constant SQL queries strings
 *
 *  @return The instance of SyncHelper Module
 */
+ (id)sharedInstance
{
    static SyncHelper *sharedHelper = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHelper = [[self alloc] init];
    });
    return sharedHelper;
}

/**
 *  Custom init method instantiating Parser and Database Client. SyncHelper does not use the shared instance of DBClientBase or Parser since
 *  its only the SyncHelper that should be used with a shared instance.
 *
 *  @return allocated instance
 */
-(id) init
{
    self = [super init];
    if (self)
    {
        self.mParser = [[Parser alloc]init];
        self.mDBClient = [[DBClientBase alloc]initWithDatabaseFilename:kDBName andNewVersion:kDBVersion];
        self.mParser.delegate = self;
    }
    return(self);
}


/**
 *  Initialize thr NSDictionary (HashMap) to be used as a cached data. The RSS link acts as the key for the representing stored data
 *
 *  @param arrURLS URL links to create the keys
 */
-(void) initLinks:(NSArray*) arrURLS
{
    
    self.mData = [[NSMutableDictionary alloc] init];

    for (NSString* curItem in arrURLS)
        [self.mData setObject:@"" forKey:curItem];
    
}

/**
 *  Method to request data update for the selected RSS link
 *
 *  @param curRSS is the RSS link to perform the update
 */
-(void) requestDataUpdateforRSS:(NSString*)curRSS
{
    
    NSDictionary* aliases = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"aliasTest", @"link", nil];
    
    [[self mParser] requestAsynchronousDataFromRssWith:nil andAlias:aliases andURL:curRSS];
}


/**
 *  Delegated method (callback) from Parser method requestAsynchronousDataFromRssWith
 *  Triggers when data retrieval from parser is successfull
 *
 *  @param Data <#Data description#>
 */
- (void) processAsynchronousRSSComplete:(NSArray*)Data
{
    //Array element at position 0 is the RSS_Item
    //Array element at position 1 is the RSS Link

    RSS_Item* item =[Data objectAtIndex:0];

    //Fill the data for the current RSS Link key to the cache
    [self.mData setObject:item.channel.item forKey:[Data objectAtIndex:1]];

    //Notify Obeserver for data completion
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSyncCompleteSuccess object:item.channel.item];
    
     dispatch_queue_t queue = dispatch_queue_create("com.aylon.SyncHelper", NULL);
     dispatch_async(queue, ^{
         // Insert data to DB asyncronous
         [[self mDBClient] insertRSS_Item:[Data objectAtIndex:0] withChannelLink:[Data objectAtIndex:1]];
     });
    
}

- (void) processAsynchronousRSSFailed:(NSArray*)Data
{
    //Array element at position 0 is the Error report
    //Array element at position 1 is the RSS Link
    
    NSError* error =[Data objectAtIndex:0];
    NSLog(@"Error Fetching. Description:%@",error);
    
    //Get data from db where Channel link is the RSS Link
    NSArray* dbData = [self.mDBClient getAllItemsByChannelLink:[Data objectAtIndex:1]];

    if(dbData.count == 0)
    {
        // Notify for sb and parser failure
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSyncCompleteFailed object:nil];
        return;
    }
    
    // Notify for parser failure but pass the db data
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSyncCompleteFailed object:dbData];
}

@end
