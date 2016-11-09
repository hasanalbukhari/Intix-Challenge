//
//  ProfileController.h
//  Square
//
//  Created by Hasan S. Al-Bukhari on 11/8/16.
//  Copyright © 2016 INTIX. All rights reserved.
//

#import "MasterController.h"
#import "HttpHandler.h"

@protocol ProfileControllerDelegate <NSObject>

@required
- (void)userLoggedOut;
@end

@interface ProfileController : MasterController <HttpDelegate>
{
    __weak id <ProfileControllerDelegate> _delegate;
}

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic, weak) id <ProfileControllerDelegate> delegate;

- (void)getProfile;
- (void)setProfileInfo;

@end
