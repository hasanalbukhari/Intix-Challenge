//
//  FoursquareController.h
//  Square
//
//  Created by Hasan S. Al-Bukhari on 11/8/16.
//  Copyright © 2016 INTIX. All rights reserved.
//

#import "MasterController.h"
#import "LoginController.h"
#import "ProfileController.h"

@interface FoursquareController : MasterController <ProfileControllerDelegate, LoginControllerDelegate>

@property (weak, nonatomic) LoginController *loginController;
@property (weak, nonatomic) ProfileController *profileController;

@end
