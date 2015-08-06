//
//  Item.m
//  Generic RSS-JSON Parser
//
//  Created by AYLON-4 on 27/01/15.
//  Copyright (c) 2015 AYLON-4. All rights reserved.
//

#import "Item.h"

@implementation Item
@synthesize description;


+ (Class)imageGallery_class
{
    return [Image class];
}

+ (Class)categories_class
{
    return [NSString class];
}

+ (Class)videoGallery_class
{
    return [Video class];
}

@end
