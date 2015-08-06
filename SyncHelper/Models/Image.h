//
//  Image.h
//  Database Component
//
//  Created by AYLON-4 on 02/02/15.
//  Copyright (c) 2015 AYLON-4. All rights reserved.
//

#import "Jastor.h"
#import "StringObject.h"

@interface Image : Jastor
@property (nonatomic,retain) StringObject* link;
@property (nonatomic,retain) StringObject* title;
@property (nonatomic,retain) StringObject* caption;
@end
