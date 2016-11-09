//
//  ProfileController.m
//  Square
//
//  Created by Hasan S. Al-Bukhari on 11/8/16.
//  Copyright © 2016 INTIX. All rights reserved.
//

#import "ProfileController.h"
#import "UserParser.h"

@implementation ProfileController

@synthesize photoImageView;
@synthesize nameLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    photoImageView.layer.cornerRadius = photoImageView.frame.size.width / 2.0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.userDetails userLoggedIn])
        [self getProfile];
}

- (void)setProfileInfo {
    [photoImageView sd_setImageWithURL:[NSURL URLWithString:self.userDetails.profile_pic]];
    
    [nameLabel setText:self.userDetails.full_name];
}

- (void)getProfile {
    [[[HttpHandler alloc] initWithDelegate:self] callMethod:PListGetUserInfoURIKey withParams:@[] andValues:@[] andExtras:@[] requiresToken:YES withRequestMethod:@"GET"];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)response:(NSString *)response WithParams:(NSArray *)params {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    UserParser *parser = [[UserParser alloc] initWithJSON:response];
    if (parser.user) {
        [self.userDetails setUser:parser.user];
        [self setProfileInfo];
    }
}

- (void)responseWithError:(NSString *)error WithParams:(NSArray *)params {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (IBAction)logoutButtonTapped:(UIButton *)sender {
    [self.userDetails setUser:nil];
    if (_delegate)
        [_delegate userLoggedOut];
}

@end
