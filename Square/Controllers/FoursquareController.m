//
//  FoursquareController.m
//  Square
//
//  Created by Hasan S. Al-Bukhari on 11/8/16.
//  Copyright © 2016 INTIX. All rights reserved.
//

#import "FoursquareController.h"

@implementation FoursquareController

@synthesize loginController;
@synthesize profileController;

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.title = [self.languageDetails LocalString:@"Me"];
    
    if ([self.userDetails userLoggedIn]) {
        [self userLoggedIn];
    } else {
        [self userLoggedOut];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:LoginController.class]) {
        loginController = segue.destinationViewController;
        [loginController setDelegate:self];
    } else if ([segue.destinationViewController isKindOfClass:ProfileController.class]) {
        profileController = segue.destinationViewController;
        [profileController setDelegate:self];
    }
}

- (void)userLoggedIn {
    [loginController.view.superview setHidden:YES];
    [profileController.view.superview setHidden:NO];
    [profileController setProfileInfo];
    [profileController getProfile];
}

- (void)userLoggedOut {
    [loginController.view.superview setHidden:NO];
    [profileController.view.superview setHidden:YES];
    [loginController prepareViewsForLogin];
}

@end
