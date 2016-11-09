//
//  Venue.m
//  Square
//
//  Created by Hasan S. Al-Bukhari on 11/7/16.
//  Copyright © 2016 INTIX. All rights reserved.
//

#import "Venue.h"

@implementation Venue

@synthesize venue_address;
@synthesize venue_category;
@synthesize venue_category_icon;
@synthesize venue_distance;
@synthesize venue_id;
@synthesize venue_lat;
@synthesize venue_lng;
@synthesize venue_name;

- (id)init
{
    if (self = [super init]) {
        venue_address = @"";
        venue_category = @"";
        venue_category_icon = @"";
        venue_distance = @"";
        venue_id = @"";
        venue_lat = @"";
        venue_lng = @"";
        venue_name = @"";
    }
    
    return  self;
}

- (BOOL)isEqual:(id)object {
    Venue *venue = object;
    return venue && [venue.venue_id isEqualToString:venue_id];
}

@end
