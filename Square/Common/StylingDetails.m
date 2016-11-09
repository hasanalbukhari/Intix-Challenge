//
//  StylingDetails.m
//  Yummy Wok
//
//  Created by Devloper on 3/12/15.
//  Copyright (c) 2015 Devloper. All rights reserved.
//

#import "StylingDetails.h"

@implementation StylingDetails

@synthesize themeColor;

- (id)init
{
    if (self = [super init]) {
        themeColor = [UIColor colorWithRed:246/255.0 green:41/255.0 blue:94/255.0 alpha:1.0f];
    }
    return  self;
}

@end
