//
//  VenuesController.h
//  Square
//
//  Created by Hasan S. Al-Bukhari on 11/9/16.
//  Copyright © 2016 INTIX. All rights reserved.
//

#import "MasterController.h"
#import "ViewController.h"
#import "VenuesListController.h"
#import "HttpHandler.h"

@interface VenuesController : MasterController <HttpDelegate, MapVenuesDataSource>


@property (weak, nonatomic) ViewController *mapController;
@property (weak, nonatomic) VenuesListController *listController;

@property (strong, nonatomic) HttpHandler *httpHandler;

@property (strong, nonatomic) NSMutableArray *venues;
@property (strong, nonatomic) NSMutableArray *checkin_venue_ids;

@end
