//
//  SyncHelper.h
//  SyncHelper
//
//  Created by AYLON-4 on 03/02/15.
//  Copyright (c) 2015 AYLON-4. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parser.h"
#import "DBClientBase.h"

extern NSString *const kNotificationSyncCompleteSuccess;
extern NSString *const kNotificationSyncCompleteFailed;


@interface SyncHelper : NSObject <ParserDelegate>

+ (id)sharedInstance;

@property (nonatomic,retain) Parser* mParser;
@property (nonatomic,retain) DBClientBase* mDBClient;
@property (nonatomic,retain) NSMutableDictionary* mData;

- (void) requestDataUpdateforRSS:(NSString*)curRSS;
- (void) initLinks:(NSArray*) arrURLS;
@end
