//
//  DBClientBase.m
//  Database Component
//
//  Created by AYLON-4 on 02/02/15.
//  Copyright (c) 2015 AYLON-4. All rights reserved.
//

#import "DBClientBase.h"

@implementation DBClientBase
NSString* kTruncateTable = @"DELETE FROM %@; %@;";
NSString* kGetRowCount = @"SELECT COUNT('%@') FROM %@";
NSString* kDeleteRow = @"DELETE FROM '%@' WHERE ROWID = %d";

static DBClientBase *sharedDBClientBase = nil;

#pragma mark - Allocation
/**
 *  Singletton - A shared instance of the Database Module. Also Initialize constant SQL queries strings
 *
 *  @return The instance of Database Module
 */
+ (id)sharedInstance
{
    if (sharedDBClientBase == nil)
        sharedDBClientBase = [[self alloc] initWithDatabaseFilename:kDBName];
    
    return sharedDBClientBase;
}



/**
 *  Initialize the Database with the given sqlite db file name and version (constant)
 *  If the db version is older than the give the Database file will be replased
 *
 *  @param dbFilename is the give db file name
 *
 *  @return returns the instance of the allocated super class
 */
- (instancetype)initWithDatabaseFilename:(NSString *)dbFilename
{
    self = [super initWithDatabaseFilename:dbFilename andNewVersion:kDBVersion];
    

    return self;
}


#pragma mark - General Functions
/**
 *  Truncates a table (deletes all items)
 *
 *  @param tableName Target table name
 */
-(void) truncateDBTable: (NSString*)tableName
{
    NSString *query = [NSString stringWithFormat:kTruncateTable, tableName , @"VACUUM"];
    [super executeQuery:query];
}

/**
 *  Gets the row numbers of a given table name
 *
 *  @param tableName Target table name to count rows
 *  @param column    a column name of the table
 *
 *  @return the number of rows
 */
- (NSInteger)getRowCount:(NSString*)tableName andColumnName:(NSString*) column
{
    NSString *query = [NSString stringWithFormat:kGetRowCount, column,tableName];
    
    NSMutableArray* dbData= [[NSMutableArray alloc] initWithArray:[super loadDataFromDB:query]];
    
    NSString* tmp = dbData[0][0];
    int ret = [tmp intValue];
    
    return ret;
    
}

/**
 *  Deletes a row from table given the rowid
 *
 *  @param table Target table name
 *  @param rowid Target rowid
 */
-(void)  deleteFromTable:(NSString*)table RowIndex:(NSInteger)rowid
{
    NSString *query = [NSString stringWithFormat:kDeleteRow, table , (int)rowid];
    [super executeQuery:query];
}

/**
 *  Returns the table columnts names
 *
 *  @param table Target table name
 *
 *  @return An array of the table column names
 */
- (NSArray*) getTableColumNames:(NSString*) table
{
    NSString* query = [NSString stringWithFormat:@"PRAGMA table_info( %@ %@"  , table , @")"];
    return [super loadDataFromDB:query];
}

#pragma - Channel Functions

/**
 *  Inserts the RSS_Item object inner objects (Channel and Items Array) into Channel and Item Database Array.
 *  It requires a channel link for the Items
 *
 *  @param rootItem RSS_Item to insert
 *  @param uLink    Channel link associated with Items
 */
- (void) insertRSS_Item:(RSS_Item*)rootItem withChannelLink:(NSString*)uLink
{
    Channel* chnl = rootItem.channel;
    [self insertChannel:chnl];
    
    
    NSArray* arrItems = chnl.item;
    for(Item* curItem in arrItems)
        [self insertItem:curItem withChannelLink:uLink];
}

#pragma - Channel Functions
/**
 *  Inserts a Channel item into the channel table
 *
 *  @param channel the input chanel item to insert to db
 *  @param Link the input chanel item to insert to db
 */
- (void) insertChannel:(Channel*)channel
{
    NSMutableString* query = [[NSString stringWithFormat:@"INSERT OR REPLACE INTO '%@'", CHANNEL_TABLE]mutableCopy];
    
    NSMutableString* tables = [[NSString stringWithFormat:@"('%@', ", CHANNEL_COLLUMN_TITLE]mutableCopy];
    tables = [[NSString stringWithFormat:@"%@'%@',",tables, CHANNEL_COLLUMN_LINK]mutableCopy];
    tables = [[NSString stringWithFormat:@"%@'%@',",tables, CHANNEL_COLLUMN_DESCRIPTION]mutableCopy];
    tables = [[NSString stringWithFormat:@"%@'%@',",tables, CHANNEL_COLLUMN_LANGUAGE]mutableCopy];
    tables = [[NSString stringWithFormat:@"%@'%@',",tables, CHANNEL_COLLUMN_LAST_BUILD_DATE]mutableCopy];
    tables = [[NSString stringWithFormat:@"%@'%@',",tables, CHANNEL_COLLUMN_IMAGE]mutableCopy];
    tables = [[NSString stringWithFormat:@"%@'%@',",tables, CHANNEL_COLLUMN_COPYRIGHT]mutableCopy];
    tables = [[NSString stringWithFormat:@"%@'%@',",tables, CHANNEL_COLLUMN_PUB_DATE]mutableCopy];
    tables = [[NSString stringWithFormat:@"%@'%@',",tables, CHANNEL_COLLUMN_CATEGORY]mutableCopy];
    tables = [[NSString stringWithFormat:@"%@'%@',",tables, CHANNEL_COLLUMN_GENERATOR]mutableCopy];
    tables = [[NSString stringWithFormat:@"%@'%@',",tables, CHANNEL_COLLUMN_ATOM]mutableCopy];
    tables = [[NSString stringWithFormat:@"%@'%@')",tables, CHANNEL_COLLUMN_ATOM10]mutableCopy];
    
    NSMutableString* values = [[NSString stringWithFormat:@"('%@', ", channel.title.getText]mutableCopy];
    values = [[NSString stringWithFormat:@"%@'%@',",values, channel.link.getText]mutableCopy];
    values = [[NSString stringWithFormat:@"%@'%@',",values, channel.description.getText]mutableCopy];
    values = [[NSString stringWithFormat:@"%@'%@',",values, channel.language.getText]mutableCopy];
    values = [[NSString stringWithFormat:@"%@'%@',",values, channel.lastBuildDate.getText]mutableCopy];
    values = [[NSString stringWithFormat:@"%@'%@',",values, channel.image.getText]mutableCopy];
    values = [[NSString stringWithFormat:@"%@'%@',",values, channel.copyright.getText]mutableCopy];
    values = [[NSString stringWithFormat:@"%@'%@',",values, channel.pubDate.getText]mutableCopy];
    values = [[NSString stringWithFormat:@"%@'%@',",values, channel.category.getText]mutableCopy];
    values = [[NSString stringWithFormat:@"%@'%@',",values, channel.generator.getText]mutableCopy];
    values = [[NSString stringWithFormat:@"%@'%@',",values, @""]mutableCopy];
    values = [[NSString stringWithFormat:@"%@'%@')",values, @""]mutableCopy];
    
    query = [[NSString stringWithFormat:@"%@ %@ VALUES %@", query, tables , values]mutableCopy];
    
    [super executeQuery:query];
}

/**
 *  Deletes all channels from Database
 */
- (void)deleteAllChannels
{
    [self truncateDBTable:CHANNEL_TABLE];
}

/**
 *  Returns all Channel items from Channel Table
 *
 *  @return return value description
 */
- (NSArray*) getAllChannels
{
    NSArray* tmp= [[NSMutableArray alloc] initWithArray:[super loadDataFromDB:SQL_CHANNEL_GET_ALL]];
    return tmp;
}


#pragma - Item Functions
/**
 *  Inserts an Item element into the Item table
 *
 *  @param item the input Item to insert
 */
- (void) insertItem:(Item*)item withChannelLink:(NSString*)cLink
{
    NSMutableString* query = [[NSString stringWithFormat:@"INSERT OR REPLACE INTO '%@'", ITEM_TABLE]mutableCopy];
    
    
    NSMutableString* tables = [[NSString stringWithFormat:@"('%@', ", ITEM_COLLUMN_TITLE]mutableCopy];
    tables = [[NSString stringWithFormat:@"%@'%@',",tables, ITEM_COLLUMN_LINK]mutableCopy];
    tables = [[NSString stringWithFormat:@"%@'%@',",tables, ITEM_COLLUMN_DESCRIPTION]mutableCopy];
    tables = [[NSString stringWithFormat:@"%@'%@',",tables, ITEM_COLLUMN_PUB_DATE]mutableCopy];
    tables = [[NSString stringWithFormat:@"%@'%@',",tables, ITEM_COLLUMN_GUID]mutableCopy];
    tables = [[NSString stringWithFormat:@"%@'%@',",tables, ITEM_COLLUMN_ENCLOSURE]mutableCopy];
    tables = [[NSString stringWithFormat:@"%@'%@',",tables, ITEM_COLLUMN_CREATOR]mutableCopy];
    tables = [[NSString stringWithFormat:@"%@'%@',",tables, ITEM_COLLUMN_THUMBNAIL]mutableCopy];
    tables = [[NSString stringWithFormat:@"%@'%@',",tables, ITEM_COLLUMN_ORIG_LINK]mutableCopy];
    tables = [[NSString stringWithFormat:@"%@'%@',",tables, ITEM_COLLUMN_AUTHOR]mutableCopy];
    tables = [[NSString stringWithFormat:@"%@'%@',",tables, ITEM_COLLUMN_CATEGORY]mutableCopy];
    tables = [[NSString stringWithFormat:@"%@'%@',",tables, ITEM_COLLUMN_COMMENTS]mutableCopy];
    tables = [[NSString stringWithFormat:@"%@'%@',",tables, ITEM_COLLUMN_CONTENT]mutableCopy];
    tables = [[NSString stringWithFormat:@"%@'%@')",tables, ITEM_COLLUMN_CHANNEL_LINK]mutableCopy];

    NSMutableString* values = [[NSString stringWithFormat:@"('%@', ", item.title.text]mutableCopy];
    values = [[NSString stringWithFormat:@"%@'%@',",values, item.link.getText]mutableCopy];
    values = [[NSString stringWithFormat:@"%@'%@',",values, item.description.getText]mutableCopy];
    values = [[NSString stringWithFormat:@"%@'%@',",values, @""]mutableCopy];
    values = [[NSString stringWithFormat:@"%@'%@',",values, @""]mutableCopy];
    values = [[NSString stringWithFormat:@"%@'%@',",values, @""]mutableCopy];
    values = [[NSString stringWithFormat:@"%@'%@',",values, @""]mutableCopy];
    values = [[NSString stringWithFormat:@"%@'%@',",values, item.pubDate.getText]mutableCopy];
    values = [[NSString stringWithFormat:@"%@'%@',",values, @""]mutableCopy];
    values = [[NSString stringWithFormat:@"%@'%@',",values, @""]mutableCopy];
    values = [[NSString stringWithFormat:@"%@'%@',",values, @""]mutableCopy];
    values = [[NSString stringWithFormat:@"%@'%@',",values, @""]mutableCopy];
    values = [[NSString stringWithFormat:@"%@'%@',",values, @""]mutableCopy];
    values = [[NSString stringWithFormat:@"%@'%@')",values,cLink]mutableCopy];

    query = [[NSString stringWithFormat:@"%@ %@ VALUES %@", query, tables , values]mutableCopy];
    
    [super executeQuery:query];
}

/**
 *  Deletes all Items from the Items Tables
 */
- (void)deleteAllItems

{
    [self truncateDBTable:ITEM_TABLE];
}

/**
 *  Gets All Items from the Items Table
 *
 *  @return return an Array of all Items
 */
- (NSArray*) getAllItems
{
    NSMutableArray* tmp= [[NSMutableArray alloc] initWithArray:[super loadDataFromDB:SQL_ITEM_GET_ALL]];
    return tmp;
}

- (NSArray*) getAllItemsByChannelLink:(NSString*)uLink
{
    NSString* query = [NSString stringWithFormat:@"%@ '%@'", SQL_ITEM_GET_ALL_BY_CHANNEL, uLink];

    NSMutableArray* tmp= [[NSMutableArray alloc] initWithArray:[super loadDataFromDB:query]];
    return tmp;
}


/**
 *  Gets all Items form Item Table that match the given ChannelLink
 *
 *  @param channelLink string to query
 *
 *  @return an array of Items
 */
- (NSArray*) getAllItemsByChannel:(NSString*)channelLink
{
    NSString* query = [NSString stringWithFormat:@"%@ '%@'", SQL_ITEM_GET_ALL_BY_CHANNEL, channelLink];
    
    NSArray* tmp= [[NSMutableArray alloc] initWithArray:[super loadDataFromDB:query]];
    return tmp;
}

#pragma - Images Functions
/**
 *  Deletes all Images items from Images Table
 */
- (void)deleteAllImages
{
    [self truncateDBTable:IMAGE_TABLE];
}

/**
 *  Inserts an Image item into Images Table with an itemLink
 *
 *  @param image    imput image item to insert
 *  @param itemLink input itemLink to insert
 */
- (void) insertImage:(Image*)image withItemLink:(NSString*)itemLink
{
    NSMutableString* query = [[NSString stringWithFormat:@"INSERT OR REPLACE INTO '%@'", IMAGE_TABLE]mutableCopy];
    
    NSMutableString* tables = [[NSString stringWithFormat:@"('%@', ", IMAGE_COLLUMN_TITLE]mutableCopy];
    tables = [[NSString stringWithFormat:@"%@'%@',",tables, IMAGE_COLLUMN_LINK]mutableCopy];
    tables = [[NSString stringWithFormat:@"%@'%@',",tables, IMAGE_COLLUMN_CAPTION]mutableCopy];
    tables = [[NSString stringWithFormat:@"%@'%@')",tables, IMAGE_COLLUMN_ITEM_LINK]mutableCopy];
    
    NSMutableString* values = [[NSString stringWithFormat:@"('%@', ", image.title.text]mutableCopy];
    values = [[NSString stringWithFormat:@"%@'%@',",values, image.link.text]mutableCopy];
    values = [[NSString stringWithFormat:@"%@'%@',",values, image.caption.text]mutableCopy];
    values = [[NSString stringWithFormat:@"%@'%@')",values,itemLink]mutableCopy];
    
    query = [[NSString stringWithFormat:@"%@ %@ VALUES %@", query, tables , values]mutableCopy];
    
    [super executeQuery:query];
}

/**
 *  Gets all Images that match the given itemLink
 *
 *  @param itemLink input itemLink to query
 *
 *  @return an array of Images
 */
- (NSArray*) getAllImagesByItemLink:(NSString*)itemLink
{
    NSString* query = [[NSString stringWithFormat:@"%@ '%@'", SQL_IMAGE_GET_ALL_BY_ITEM, itemLink]mutableCopy];
    NSArray* ret= [[NSMutableArray alloc] initWithArray:[super loadDataFromDB:query]];
    return ret;
}



@end
