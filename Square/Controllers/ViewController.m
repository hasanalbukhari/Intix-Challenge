//
//  ViewController.m
//  Square
//
//  Created by Hasan S. Al-Bukhari on 11/7/16.
//  Copyright © 2016 INTIX. All rights reserved.
//

#import "ViewController.h"
#import <SDWebImage/SDWebImageManager.h>

@implementation ViewController

@synthesize mapView;
@synthesize noteView;
@synthesize locationManager;
@synthesize lastLocation;
@synthesize lastLocationMarker;
@synthesize markers;
@synthesize venueCategoryLabel;
@synthesize venueDistanceLabel;
@synthesize venueImageButton;
@synthesize venueNameLabel;
@synthesize venueView;
@synthesize venueViewLeftConstraint;
@synthesize venueViewRightConstraint;
@synthesize venueCheckInButton;
@synthesize venues;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    markers = [[NSMutableArray alloc] init];
    
    [venueView setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    [venueView setBorderColor:[self.stylingDetails themeColor]];
    [venueView setBorderWidth:0.5];
    
    [noteView setHidden:YES];
    [self hideVenueView];
    
    mapView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getLocation];

    self.tabBarController.title = [self.languageDetails LocalString:@"NearBy"];
}

- (void)getLocation
{
    if (locationManager == nil)
    {
        [self initLocationManager];
    }
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [locationManager requestWhenInUseAuthorization];
    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [locationManager startUpdatingLocation];
    } else {
        [noteView setHidden:NO];
    }
}

- (void)initLocationManager {
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    DDLogVerbose(@"location manager error: %@", error.description);
}

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            DDLogVerbose(@"User still thinking granting location access!");
            [locationManager stopUpdatingLocation];
        } break;
        case kCLAuthorizationStatusDenied: {
            DDLogVerbose(@"User denied location access request!!");
            [noteView setHidden:NO];
            [locationManager stopUpdatingLocation];
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            [noteView setHidden:YES];
            [locationManager startUpdatingLocation]; // Will update location immediately
        } break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    lastLocation = [locations lastObject];
    DDLogVerbose(@"last location: lat %f - lon %f", lastLocation.coordinate.latitude, lastLocation.coordinate.longitude);
    
    if (!lastLocationMarker) {
        [self moveCamToLat:lastLocation.coordinate.latitude andLong:lastLocation.coordinate.longitude];
    }
    
    [self addMarkerTo:lastLocation.coordinate];
    
    [self searchVenues];
}

- (void)drawVenuesOnMap {
    if (markers) {
        for (GMSMarker *marker in markers) {
            marker.map = nil;
        }
        markers = nil;
    }
    
    markers = [[NSMutableArray alloc] init];
    for (Venue *venue in venues) {
        [self addVenueMarker:venue];
    }
}

#pragma mark map delegate
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    
}

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture {
    if (gesture) {
        [noteView setHidden:YES];
    }
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    DDLogVerbose(@"tapped marker title: %@", marker.title);
    NSInteger index = [markers indexOfObject:marker];
    if (index >= 0 && index <= markers.count) {
        tapped_venue = [venues objectAtIndex:index];
        [self showVenueViewWith:tapped_venue];
    }
    return YES;
}

#pragma mark map help methods
- (void)addVenueMarker:(Venue *)venue
{
    GMSMarker *venueMarker = [[GMSMarker alloc] init];
    venueMarker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
    venueMarker.position = CLLocationCoordinate2DMake([venue.venue_lat floatValue], [venue.venue_lng floatValue]);
    venueMarker.map = mapView;
    venueMarker.title = venue.venue_name;
    venueMarker.tappable = YES;
    [markers addObject:venueMarker];
}

- (void)addMarkerTo:(CLLocationCoordinate2D)pin_location
{
    if (lastLocationMarker)
        lastLocationMarker.map = nil;

    lastLocationMarker = [[GMSMarker alloc] init];
    lastLocationMarker.icon = [GMSMarker markerImageWithColor:[self.stylingDetails themeColor]];
    lastLocationMarker.position = pin_location;
    lastLocationMarker.zIndex = 1;
    lastLocationMarker.tappable = NO;
    lastLocationMarker.map = mapView;
}

- (void)moveCamToLat:(CLLocationDegrees)lat andLong:(CLLocationDegrees)lon {
    [self moveCamToLat:lat andLong:lon andZoom:16.0];
}

- (void)moveCamToLat:(CLLocationDegrees)lat andLong:(CLLocationDegrees)lon andZoom:(float)zoom {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
                                                            longitude:lon
                                                                 zoom:zoom];
    
    mapView.camera = camera;
}

- (void)searchVenues {
    if (_datasource) {
        [_datasource fetchVenues:^(NSMutableArray *fetched_venues) {
            venues = fetched_venues;
            [self drawVenuesOnMap];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        } with:lastLocation.coordinate];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
}

- (void)hideVenueView {
    [venueView setHidden:YES];
    [venueImageButton setImage:nil forState:UIControlStateNormal];
    [venueNameLabel setText:@""];
    [venueCategoryLabel setText:@""];
    [venueDistanceLabel setText:@""];
    [venueCheckInButton setTintColor:[UIColor colorWithRed:104/255.0 green:104/255.0 blue:104/255.0 alpha:1.0]];
}

- (void)showVenueViewWith:(Venue *)venue {
    venueViewLeftConstraint.constant = 8;
    venueViewRightConstraint.constant = 8;
    [venueView layoutIfNeeded];
    
    [venueView setHidden:NO];
    [venueImageButton sd_setImageWithURL:[NSURL URLWithString:venue.venue_category_icon] forState:UIControlStateNormal];
    [venueNameLabel setText:venue.venue_name];
    [venueCategoryLabel setText:venue.venue_category];
    [venueDistanceLabel setText:[NSString stringWithFormat:@"%@ m", venue.venue_distance]];
    if (_datasource && [[_datasource checkinedVenues] containsObject:venue.venue_id]) {
        [venueCheckInButton setTintColor:[self.stylingDetails themeColor]];
    } else {
        [venueCheckInButton setTintColor:[UIColor colorWithRed:104/255.0 green:104/255.0 blue:104/255.0 alpha:1.0]];
    }
}

- (IBAction)venueViewSwiped:(UISwipeGestureRecognizer *)sender {
    [venueView layoutIfNeeded];
    
    CGFloat x = 0;
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        x = -1000;
    } else if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        x = +1000;
    }
    
    venueViewLeftConstraint.constant += x;
    venueViewRightConstraint.constant -= x;
    
    [UIView animateWithDuration:0.5 animations:^{
        [venueView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self hideVenueView];
    }];
}

- (IBAction)checkInButtonTapped:(UIButton *)sender {
    if ([self.userDetails userLoggedIn]) {
        [self checkInToVenue:tapped_venue];
    } else {
        self.tabBarController.selectedIndex = 1;
    }
}

- (void)checkInToVenue:(Venue *)venue {
    if (_datasource) {
        [_datasource checkIn:^(Venue *v) {
            if (tapped_venue == v) {
                [venueCheckInButton setTintColor:[self.stylingDetails themeColor]];
            }
        } with:venue];
    }
}

@end
