//
//  DBConstants.h
//  Database Component
//
//  Created by AYLON-4 on 02/02/15.
//  Copyright (c) 2015 AYLON-4. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const CHANNEL_TABLE;
extern NSString *const CHANNEL_COLLUMN_TITLE;
extern NSString *const CHANNEL_COLLUMN_LINK;
extern NSString *const CHANNEL_COLLUMN_DESCRIPTION ;
extern NSString *const CHANNEL_COLLUMN_LANGUAGE;
extern NSString *const CHANNEL_COLLUMN_LAST_BUILD_DATE ;
extern NSString *const CHANNEL_COLLUMN_IMAGE;
extern NSString *const CHANNEL_COLLUMN_COPYRIGHT;
extern NSString *const CHANNEL_COLLUMN_PUB_DATE;
extern NSString *const CHANNEL_COLLUMN_CATEGORY;
extern NSString *const CHANNEL_COLLUMN_GENERATOR ;
extern NSString *const CHANNEL_COLLUMN_ATOM ;
extern NSString *const CHANNEL_COLLUMN_ATOM10;

extern NSString *const ITEM_TABLE;
extern NSString *const ITEM_COLLUMN_TITLE;
extern NSString *const ITEM_COLLUMN_LINK;
extern NSString *const ITEM_COLLUMN_DESCRIPTION;
extern NSString *const ITEM_COLLUMN_PUB_DATE ;
extern NSString *const ITEM_COLLUMN_GUID ;
extern NSString *const ITEM_COLLUMN_ENCLOSURE ;
extern NSString *const ITEM_COLLUMN_CREATOR ;
extern NSString *const ITEM_COLLUMN_THUMBNAIL;
extern NSString *const ITEM_COLLUMN_ORIG_LINK;
extern NSString *const ITEM_COLLUMN_AUTHOR ;
extern NSString *const ITEM_COLLUMN_CATEGORY;
extern NSString *const ITEM_COLLUMN_COMMENTS;
extern NSString *const ITEM_COLLUMN_CONTENT;
extern NSString *const ITEM_COLLUMN_CHANNEL_LINK;

extern NSString *const IMAGE_TABLE ;
extern NSString *const IMAGE_COLLUMN_TITLE ;
extern NSString *const IMAGE_COLLUMN_LINK;
extern NSString *const IMAGE_COLLUMN_CAPTION;
extern NSString *const IMAGE_COLLUMN_ITEM_LINK;

/* SQL STATEMENTS */
extern NSString* SQL_CHANNEL_GET_ALL;
extern NSString* SQL_CHANNEL_GET_ALL_BY_CATEGORY;
extern NSString* SQL_ITEM_GET_ALL;
extern NSString* SQL_ITEM_GET_ALL_BY_CHANNEL;
extern NSString* SQL_IMAGE_GET_ALL_BY_ITEM;

extern NSString *const kDBName;
extern int const kDBVersion;

@interface DBConstants : NSObject

@end
