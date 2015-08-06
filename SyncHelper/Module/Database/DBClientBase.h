//
//  DBClientBase.h
//  Database Component
//
//  Created by AYLON-4 on 02/02/15.
//  Copyright (c) 2015 AYLON-4. All rights reserved.
//

#import "DBManager.h"
#import "RSS_Item.h"
#import "DBConstants.h"

@interface DBClientBase : DBManager

//Singletton Shared Instance
+ (id)sharedInstance;

//General Functions
- (void) insertRSS_Item:(RSS_Item*)rootItem withChannelLink:(NSString*)uLink;

//Channel Table Functions
- (void) deleteAllChannels;
- (NSArray*) getAllChannels;
- (void) insertChannel:(Channel*)channel;

//Item Table Functions
- (void) insertItem:(Item*)item withChannelLink:(NSString*)cLink;
- (void)deleteAllItems;
- (NSArray*) getAllItems;
- (NSArray*) getAllItemsByChannelLink:(NSString*)uLink;


//Image Table Function
- (void)deleteAllImages;
- (void) insertImage:(Image*)image withItemLink:(NSString*)itemLink;
- (NSArray*) getAllImagesByItemLink:(NSString*)itemLink;
@end
