//
//  StringObject.h
//  Generic RSS-JSON Parser
//
//  Created by AYLON-4 on 27/01/15.
//  Copyright (c) 2015 AYLON-4. All rights reserved.
//

#import "Jastor.h"



/**
 *  A mapping class for RSS string item that is in a NSDictionary Container
 */
@interface StringObject : Jastor
@property (nonatomic , copy) NSString* text;

-(NSString*)getText;
@end
