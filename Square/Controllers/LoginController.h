//
//  LoginController.h
//  Square
//
//  Created by Hasan S. Al-Bukhari on 11/7/16.
//  Copyright © 2016 INTIX. All rights reserved.
//

#import "MasterController.h"
#import "LoadingView.h"
#import "CheckBox.h"
#import "APIHelper.h"
#import "HttpHandler.h"

@protocol LoginControllerDelegate <NSObject>

@required
- (void)userLoggedIn;
@end

@interface LoginController : MasterController <APIAuthorizationDelegate, HttpDelegate>
{
    __weak id <LoginControllerDelegate> _delegate;
}

@property (strong, nonatomic) HttpHandler *tokenHttpHandler;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet LoadingView *loadingView;
@property (weak, nonatomic) IBOutlet CheckBox *rememberButton;
@property (weak, nonatomic) IBOutlet UILabel *rememberLabel;
@property (weak, nonatomic) IBOutlet UIView *rememberView;

@property (nonatomic, weak) id <LoginControllerDelegate> delegate;

- (void)prepareViewsForLogin;

@end
