//
//  DBManager.m
//  RssExample
//
//  Created by AYLON-4 on 06/11/14.
//  Copyright (c) 2014 AYLON-4. All rights reserved.
//

#import "DBManager.h"
#import "DBConstants.h"
#import <sqlite3.h>


@interface DBManager()
@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;
@property (nonatomic, strong) NSMutableArray *arrResults;
@property (nonatomic) NSInteger newVersion;


-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;
- (NSInteger) getDBVersion;
@end
@implementation DBManager

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename andNewVersion:(int)version
{
    self = [super init];
    if (self) {
        // Set the documents directory path to the documentsDirectory property.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        
        // Keep the database filename.
        self.databaseFilename = dbFilename;
        self.newVersion=(int)version;
        
        // Copy the database file into the documents directory if necessary.
        [self copyDatabaseIntoDocumentsDirectory];
        
        SQL_CHANNEL_GET_ALL = [NSString stringWithFormat:@"SELECT * FROM %@", CHANNEL_TABLE] ;
        SQL_CHANNEL_GET_ALL_BY_CATEGORY = [NSString stringWithFormat:@"SELECT * FROM %@ %@ %@ %@" , CHANNEL_TABLE , @"WHERE" , CHANNEL_COLLUMN_CATEGORY , @"="];
        SQL_ITEM_GET_ALL = [NSString stringWithFormat:@"SELECT * FROM %@" , ITEM_TABLE];
        SQL_ITEM_GET_ALL_BY_CHANNEL = [NSString stringWithFormat:@"SELECT * FROM %@ %@ %@ %@" , ITEM_TABLE , @"WHERE" , ITEM_COLLUMN_CHANNEL_LINK , @"="];
        SQL_IMAGE_GET_ALL_BY_ITEM = [NSString stringWithFormat:@"SELECT * FROM %@ %@ %@ %@" , IMAGE_TABLE , @"WHERE" , IMAGE_COLLUMN_ITEM_LINK , @"="];
        
    }
    return self;
}


/**
 *  Gets DB version from User Preferences
 *
 *  @return the stored DB version
 */
- (NSInteger) getDBVersion;
{
    NSInteger ret = [[NSUserDefaults standardUserDefaults]  integerForKey:@"currentVersion"];
    return ret;
}

/**
 *  Stores the current DB version to User Settings
 */
- (void) setDBVersion
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:self.newVersion forKey:@"currentVersion"];
    [prefs synchronize];
}

-(void)copyDatabaseIntoDocumentsDirectory
{
    // Check if the database file exists in the documents directory.
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    NSLog(@"Database Path: %@", destinationPath);
    
    
    //If database doesnt exist the created it
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath])
    {
        // The database file does not exist in the documents directory, so copy it from the main bundle now.
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];

        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        
        // Check if any error occurred during copying and display it.
        [self setDBVersion];
    }
    else
    {
        
        // If database exist then check for db version
        
        NSInteger oldversion = [self getDBVersion];
        NSError *error;
        
        if (self.newVersion > oldversion)
        {
            // if db version is outdated then delete stored db and replace with new
            [[NSFileManager defaultManager] removeItemAtPath:destinationPath error:&error];
            NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
            [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
            
            // Update the current DB version to user settings
            [self setDBVersion];

        }
    }

}


-(NSArray *)loadDataFromDB:(NSString *)query{
    // Run the query and indicate that is not executable.
    // The query string is converted to a char* object.
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    
    // Returned the loaded results.
    return (NSArray *)self.arrResults;
}

-(void)executeQuery:(NSString *)query{
    // Run the query and indicate that is executable.
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}


-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable{
    // Create a sqlite object.
    sqlite3 *sqlite3Database;
    
    // Set the database file path.
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    // Initialize the results array.
    if (self.arrResults != nil) {
        [self.arrResults removeAllObjects];
        self.arrResults = nil;
    }
    self.arrResults = [[NSMutableArray alloc] init];
    
    // Initialize the column names array.
    if (self.arrColumnNames != nil) {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [[NSMutableArray alloc] init];
    
    
    // Open the database.
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if(openDatabaseResult == SQLITE_OK) {
        // Declare a sqlite3_stmt object in which will be stored the query after having been compiled into a SQLite statement.
        sqlite3_stmt *compiledStatement;
        
        // Load all data from database to memory.
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
        if(prepareStatementResult == SQLITE_OK) {
            // Check if the query is non-executable.
            if (!queryExecutable){
                // In this case data must be loaded from the database.
                
                // Declare an array to keep the data for each fetched row.
                NSMutableArray *arrDataRow;
                
                // Loop through the results and add them to the results array row by row.
                while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    // Initialize the mutable array that will contain the data of a fetched row.
                    arrDataRow = [[NSMutableArray alloc] init];
                    
                    // Get the total number of columns.
                    int totalColumns = sqlite3_column_count(compiledStatement);
                    
                    // Go through all columns and fetch each column data.
                    for (int i=0; i<totalColumns; i++){
                        // Convert the column data to text (characters).
                        char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                        
                        // If there are contents in the currenct column (field) then add them to the current row array.
                        if (dbDataAsChars != NULL) {
                            // Convert the characters to string.
                            [arrDataRow addObject:[NSString  stringWithUTF8String:dbDataAsChars]];
                        }
                        
                        // Keep the current column name.
                        if (self.arrColumnNames.count != totalColumns) {
                            dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
                            [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                    }
                    
                    // Store each fetched data row in the results array, but first check if there is actually data.
                    if (arrDataRow.count > 0) {
                        [self.arrResults addObject:arrDataRow];
                    }
                }
            }
            else {
                // This is the case of an executable query (insert, update, ...).
                
                // Execute the query.
                BOOL executeQueryResults = sqlite3_step(compiledStatement);
                                    // Keep the affected rows.
                    self.affectedRows = sqlite3_changes(sqlite3Database);
                    
                    // Keep the last inserted row ID.
                    self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
                
                    // If could not execute the query show the error message on the debugger.
                    //NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
                
            }
        }
        else {
            // In the database cannot be opened then show the error message on the debugger.
            NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
        }
        
        // Release the compiled statement from memory.
        sqlite3_finalize(compiledStatement);
        
    }
    
    // Close the database.
    sqlite3_close(sqlite3Database);
}
@end
