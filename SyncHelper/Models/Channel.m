//
//  Channel.m
//  Generic RSS-JSON Parser
//
//  Created by AYLON-4 on 27/01/15.
//  Copyright (c) 2015 AYLON-4. All rights reserved.
//

#import "Channel.h"

@implementation Channel
@synthesize description;


+ (Class)item_class
{
    return [Item class];
}

@end
