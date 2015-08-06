//
//  DBConstants.m
//  Database Component
//
//  Created by AYLON-4 on 02/02/15.
//  Copyright (c) 2015 AYLON-4. All rights reserved.
//

#import "DBConstants.h"


NSString *const CHANNEL_TABLE = @"Channel";
NSString *const CHANNEL_COLLUMN_TITLE = @"title";
NSString *const CHANNEL_COLLUMN_LINK = @"link";
NSString *const CHANNEL_COLLUMN_DESCRIPTION = @"description";
NSString *const CHANNEL_COLLUMN_LANGUAGE = @"language";
NSString *const CHANNEL_COLLUMN_LAST_BUILD_DATE = @"lastBuildDate";
NSString *const CHANNEL_COLLUMN_IMAGE = @"image";
NSString *const CHANNEL_COLLUMN_COPYRIGHT = @"copyright";
NSString *const CHANNEL_COLLUMN_PUB_DATE = @"pubDate";
NSString *const CHANNEL_COLLUMN_CATEGORY = @"category";
NSString *const CHANNEL_COLLUMN_GENERATOR = @"generator";
NSString *const CHANNEL_COLLUMN_ATOM = @"atom";
NSString *const CHANNEL_COLLUMN_ATOM10 = @"atom10";

NSString *const ITEM_TABLE = @"Item";
NSString *const ITEM_COLLUMN_TITLE = @"title";
NSString *const ITEM_COLLUMN_LINK = @"link";
NSString *const ITEM_COLLUMN_DESCRIPTION = @"description";
NSString *const ITEM_COLLUMN_PUB_DATE = @"pubDate";
NSString *const ITEM_COLLUMN_GUID = @"guid";
NSString *const ITEM_COLLUMN_ENCLOSURE = @"enclosure";
NSString *const ITEM_COLLUMN_CREATOR = @"creator";
NSString *const ITEM_COLLUMN_THUMBNAIL = @"thumbnail";
NSString *const ITEM_COLLUMN_ORIG_LINK = @"origLink";
NSString *const ITEM_COLLUMN_AUTHOR = @"author";
NSString *const ITEM_COLLUMN_CATEGORY = @"category";
NSString *const ITEM_COLLUMN_COMMENTS = @"comments";
NSString *const ITEM_COLLUMN_CONTENT = @"content";
NSString *const ITEM_COLLUMN_CHANNEL_LINK = @"channelLink";

NSString *const IMAGE_TABLE = @"Image";
NSString *const IMAGE_COLLUMN_TITLE = @"title";
NSString *const IMAGE_COLLUMN_LINK = @"link";
NSString *const IMAGE_COLLUMN_CAPTION = @"caption";
NSString *const IMAGE_COLLUMN_ITEM_LINK = @"itemLink";

/* SQL STATEMENTS */
NSString* SQL_CHANNEL_GET_ALL;
NSString* SQL_CHANNEL_GET_ALL_BY_CATEGORY;
NSString* SQL_ITEM_GET_ALL;
NSString* SQL_ITEM_GET_ALL_BY_CHANNEL;
NSString* SQL_IMAGE_GET_ALL_BY_ITEM;

NSString *const kDBName= @"newsdb.sqlite"; //DB Name
int const kDBVersion= 1; // DB Version



@implementation DBConstants

@end
