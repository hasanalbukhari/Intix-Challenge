//
//  VenuesController.m
//  Square
//
//  Created by Hasan S. Al-Bukhari on 11/9/16.
//  Copyright © 2016 INTIX. All rights reserved.
//

#import "VenuesController.h"
#import "VenuesParser.h"

@implementation VenuesController

@synthesize mapController;
@synthesize listController;
@synthesize httpHandler;
@synthesize venues;
@synthesize checkin_venue_ids;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    venues = [[NSMutableArray alloc] init];
    checkin_venue_ids = [[NSMutableArray alloc] init];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:ViewController.class]) {
        mapController = segue.destinationViewController;
        [mapController setDatasource:self];
    } else if ([segue.destinationViewController isKindOfClass:VenuesListController.class]) {
        listController = segue.destinationViewController;
    }
}

- (void)fetchVenues:(venuesList)block with:(CLLocationCoordinate2D)location {
    if (httpHandler) {
        [httpHandler cancel];
    }
    
    [(httpHandler = [[HttpHandler alloc] initWithDelegate:self]) callMethod:PListGetVenuesURIKey withParams:@[PListVenuesLLParam] andValues:@[[NSString stringWithFormat:@"%f,%f", location.latitude, location.longitude]] andExtras:@[block] requiresToken:NO withRequestMethod:@"GET"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)checkIn:(checkInSuccess)block with:(Venue *)venue {
    [[[HttpHandler alloc] initWithDelegate:self] callMethod:PListCheckInURIKey withParams:@[PListCheckInVenueIDParam] andValues:@[venue.venue_id] andExtras:@[venue.venue_id, block, venue] requiresToken:YES withRequestMethod:@"POST"];
}

- (void)response:(NSString *)response WithParams:(NSArray *)params {
    if ([params[0] isEqualToString:PListGetVenuesURIKey]) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        VenuesParser *parser = [[VenuesParser alloc] initWithJSON:response];
        venues = parser.venues;
        
        venuesList block = params[3][0];
        
        block(parser.venues);
    } else if ([params[0] isEqualToString:PListCheckInURIKey]) {
        if ([response containsString:@"\"response\":{\"checkin\":{\"id\":\""]) {
            if (![checkin_venue_ids containsObject:params[3][0]])
                [checkin_venue_ids addObject:params[3][0]];
            
            checkInSuccess block = params[3][1];
            Venue *venue = params[3][2];
            block(venue);
        }
    }
}

- (void)responseWithError:(NSString *)error WithParams:(NSArray *)params {
    if ([params[0] isEqualToString:PListGetVenuesURIKey]) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

- (NSMutableArray *)checkinedVenues {
    return checkin_venue_ids;
}

@end
