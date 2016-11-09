//
//  VenuesParser.h
//  Square
//
//  Created by Hasan S. Al-Bukhari on 11/7/16.
//  Copyright © 2016 INTIX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VenuesParser : NSObject

@property (nonatomic, strong) NSMutableArray *venues;

- (id)initWithJSON:(NSString *)json;

@end
