//
//  RSS_Item.h
//  Generic RSS-JSON Parser
//
//  Created by AYLON-4 on 27/01/15.
//  Copyright (c) 2015 AYLON-4. All rights reserved.
//

#import "Jastor.h"
#import "Channel.h"
#import "StringObject.h"

@interface RSS_Item : Jastor

@property (nonatomic , copy) NSString* text;
@property (nonatomic , retain) Channel* channel;
@property (nonatomic , copy) NSString* version;

@end
