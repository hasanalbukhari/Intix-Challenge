//
//  VenuesParser.m
//  Square
//
//  Created by Hasan S. Al-Bukhari on 11/7/16.
//  Copyright © 2016 INTIX. All rights reserved.
//

#import "VenuesParser.h"
#import "Venue.h"

@implementation VenuesParser

@synthesize venues;

- (id)initWithJSON:(NSString *)json {
    
    if ((self = [super init])) {
        
        venues = [[NSMutableArray alloc] init];
        
        @try {
            
            NSError *e = nil;
            NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                     options:kNilOptions
                                                                       error:&e];
            
            NSDictionary *response = [jsonDict objectForKey:@"response"];
            NSDictionary *venues_dict = [response objectForKey:@"venues"];
            if (venues_dict) {
                for (NSDictionary *item  in venues_dict) {
                    Venue *venue = [[Venue alloc] init];
                
                    [venue setVenue_id:[item valueForKey:@"id"]];
                    [venue setVenue_name:[item valueForKey:@"name"]];
                    
                    NSDictionary *location_dict = [item objectForKey:@"location"];
                    if (location_dict) {
                        [venue setVenue_lat:[[location_dict valueForKey:@"lat"] stringValue]];
                        [venue setVenue_lng:[[location_dict valueForKey:@"lng"] stringValue]];
                        [venue setVenue_address:[location_dict valueForKey:@"address"]];
                        [venue setVenue_distance:[[location_dict valueForKey:@"distance"] stringValue]];
                    }
                    
                    // category
                    NSDictionary *cats_dict = [item objectForKey:@"categories"];
                    for (NSDictionary *cat_dict in cats_dict) {
                        [venue setVenue_category:[cat_dict valueForKey:@"name"]];
                        
                        NSDictionary *cat_icon_dict = [cat_dict objectForKey:@"icon"];
                        
                        NSString *prefix = [cat_icon_dict valueForKey:@"prefix"];
                        NSString *suffix = [cat_icon_dict valueForKey:@"suffix"];
                        NSString *url = [NSString stringWithFormat:@"%@100%@", prefix, suffix];
                        
                        [venue setVenue_category_icon:url];
                        
                        if ([[cat_dict valueForKey:@"primary"] boolValue]) {
                            break;
                        }
                    }
                
                    [venues addObject:venue];
                }
            }
            
        } @catch (NSException *exception) {
            venues = nil;
            NSLog(@"Venues ::::: Json Parsing Exception ::::: %@", [exception debugDescription]);
        }
        @finally {
            
        }
    }
    
    return self;
}

@end
