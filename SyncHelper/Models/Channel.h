//
//  Channel.h
//  Generic RSS-JSON Parser
//
//  Created by AYLON-4 on 27/01/15.
//  Copyright (c) 2015 AYLON-4. All rights reserved.
//

#import "Jastor.h"
#import "StringObject.h"
#import "Item.h"

@interface Channel : Jastor

//StringObject a mapping class for RSS string item that is in a NSDictionary container

@property (nonatomic , retain) StringObject* title;
@property (nonatomic , retain) StringObject* link;
@property (nonatomic , retain) StringObject* description;
@property (nonatomic , retain) StringObject* language;
@property (nonatomic , retain) StringObject* lastBuildDate;
@property (nonatomic , retain) StringObject* image;
@property (nonatomic , retain) StringObject* copyright;
@property (nonatomic , retain) StringObject* pubDate;
@property (nonatomic , retain) StringObject* category;
@property (nonatomic , retain) StringObject* generator;
@property (nonatomic , retain) NSArray* item;
@end
