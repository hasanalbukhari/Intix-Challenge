//
//  Venue.h
//  Square
//
//  Created by Hasan S. Al-Bukhari on 11/7/16.
//  Copyright © 2016 INTIX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Venue : NSObject

@property (nonatomic, strong) NSString *venue_id;
@property (nonatomic, strong) NSString *venue_name;
@property (nonatomic, strong) NSString *venue_category;
@property (nonatomic, strong) NSString *venue_category_icon;
@property (nonatomic, strong) NSString *venue_lat;
@property (nonatomic, strong) NSString *venue_lng;
@property (nonatomic, strong) NSString *venue_distance;
@property (nonatomic, strong) NSString *venue_address;

@end
