//
//  ViewController.h
//  Square
//
//  Created by Hasan S. Al-Bukhari on 11/7/16.
//  Copyright © 2016 INTIX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "MasterController.h"
#import "RoundedCornersView.h"
#import "Venue.h"

typedef void(^venuesList)(NSMutableArray *);
typedef void(^checkInSuccess)(Venue *);

@protocol MapVenuesDataSource <NSObject>

@required
- (void)fetchVenues:(venuesList)block with:(CLLocationCoordinate2D)location;
- (NSMutableArray *)checkinedVenues;
- (void)checkIn:(checkInSuccess)block with:(Venue*)venue;
@end

@interface ViewController : MasterController <CLLocationManagerDelegate, GMSMapViewDelegate>
{
    __weak id <MapVenuesDataSource> _datasource;
    Venue *tapped_venue;
}

@property (strong, nonatomic) NSMutableArray *markers;
@property (strong, nonatomic) NSMutableArray *venues;

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *noteView;
@property (weak, nonatomic) IBOutlet RoundedCornersView *venueView;
@property (weak, nonatomic) IBOutlet UIButton *venueImageButton;
@property (weak, nonatomic) IBOutlet UILabel *venueNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueDistanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *venueCheckInButton;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *lastLocation;
@property (strong, nonatomic) GMSMarker *lastLocationMarker;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *venueViewLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *venueViewRightConstraint;

@property (nonatomic, weak) id <MapVenuesDataSource> datasource;

@end
