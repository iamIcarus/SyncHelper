//
//  StringObject.m
//  Generic RSS-JSON Parser
//
//  Created by AYLON-4 on 27/01/15.
//  Copyright (c) 2015 AYLON-4. All rights reserved.
//

#import "StringObject.h"

@implementation StringObject

/**
 *  Methods normalize string for Database insertion
 *
 *  @return <#return value description#>
 */
-(NSString*)getText
{
    // remove double quotes
    NSString* ret = [self.text stringByReplacingOccurrencesOfString: @"\"\"" withString: @"\""];
    
    // add another '
    ret = [ret stringByReplacingOccurrencesOfString: @"\'" withString: @"\'\'"];
    
    
    return ret;
}
@end
