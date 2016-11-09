//
//  MasterController.m
//  Kader
//
//  Created by Devloper on 8/19/15.
//  Copyright © 2015 Devloper. All rights reserved.
//

#import "MasterController.h"

@implementation MasterController

@synthesize singlton;
@synthesize stylingDetails;
@synthesize userDetails;
@synthesize languageDetails;

- (void)viewDidLoad {
    [super viewDidLoad];

    // initialise local references to be used in all subclasses
    singlton = [Singlton singlton];
    stylingDetails = [singlton stylingDetails];
    languageDetails = [singlton languageDetails];
    userDetails = [singlton userDetails];
    
    [self styleBars];
}

- (void)styleBars {
    // status bar & navigation bar styling.
    if (self.tabBarController)
    {
        // navigation bar color
        self.tabBarController.tabBar.tintColor = [self.stylingDetails themeColor];
        self.tabBarController.tabBar.barTintColor = [UIColor whiteColor];
        self.tabBarController.tabBar.translucent = NO;
        
        if (self.tabBarController.navigationController)
            [Common styleNavigationBar:self.tabBarController.navigationController];
        else
            [self setNeedsStatusBarAppearanceUpdate];
    }
    else
    {
        if (self.navigationController)
        {
            [Common styleNavigationBar:self.navigationController];
        }
        else
        {
            [self setNeedsStatusBarAppearanceUpdate];
        }
    }
}

// will be called in view controllers with no navigation controller.
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
