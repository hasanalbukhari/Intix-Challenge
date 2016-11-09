//
//  LoginController.m
//  Square
//
//  Created by Hasan S. Al-Bukhari on 11/7/16.
//  Copyright © 2016 INTIX. All rights reserved.
//

#import "LoginController.h"
#import "AccessTokenParser.h"

@implementation LoginController

@synthesize rememberButton;
@synthesize loadingView;
@synthesize loginButton;
@synthesize rememberLabel;
@synthesize rememberView;
@synthesize tokenHttpHandler;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setLocalizedText];
    [self styleLoadingView];
    [self setupRememberButton];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self cancelLoging];
}

- (void)setLocalizedText {
    [loginButton setTitle:[self.languageDetails LocalString:@"Login"] forState:UIControlStateNormal];
}

- (void)styleLoadingView {
    [loadingView.messageLabel setTextColor:[UIColor whiteColor]];
    [loadingView.loadingBall setColor:[UIColor whiteColor]];
    [loadingView.reloadButton setTintColor:[UIColor whiteColor]];
    [loadingView.reloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setupRememberButton
{
    [rememberButton setBorderWidth:0.5];
    [rememberButton setBorderColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    [rememberButton setSelected:YES];
    [rememberButton setHitEdgeInsets:UIEdgeInsetsMake(-10.0f, -10.0f, -10.0f, -10.0f)];
}

- (void)prepareViewsForLogin {
    [loginButton setTitle:[self.languageDetails LocalString:@"Login"] forState:UIControlStateNormal];
    [loadingView stopLoading];
    [loginButton setHidden:NO];
    [rememberView setHidden:NO];
}

- (IBAction)loginButtonTapped:(UIButton *)sender {
    if ([[[loginButton titleLabel] text] isEqualToString:[self.languageDetails LocalString:@"Cancel"]]) {
        [self cancelLoging];
    } else {
        [self requestAuthorizationPage];
    }
}

- (void)requestAuthorizationPage {
    NSURL *authURL = [NSURL URLWithString:[[self.singlton apiHelper] authorizationURL]];
    
    [[self.singlton apiHelper] setDelegate:self];
    [[UIApplication sharedApplication] openURL:authURL];
    
    [rememberView setHidden:YES];
    [loadingView startLoadingWitMessage:@"Waiting"];
    [loginButton setTitle:[self.languageDetails LocalString:@"Cancel"] forState:UIControlStateNormal];
}

- (void)cancelLoging {
    [self prepareViewsForLogin];
    [[self.singlton apiHelper] setDelegate:nil];
    if (tokenHttpHandler) {
        [tokenHttpHandler cancel];
        tokenHttpHandler = nil;
    }
    [self.userDetails setCode:nil];
}

- (void)userAuthorized:(NSString *)code {
    [self.userDetails setNoCache:![rememberButton isSelected]];
    [self.userDetails setCode:code];
    if (![[self.userDetails code] isEqualToString:@""]) {
        [self getAccessToken];
    } else {
        [loadingView stopLoadingWithMessage:@"Fail"];
        [loginButton setTitle:[self.languageDetails LocalString:@"Login"] forState:UIControlStateNormal];
        [rememberView setHidden:NO];
    }
}

- (void)getAccessToken {
    if (tokenHttpHandler) {
        [tokenHttpHandler cancel];
    }
    
    [(tokenHttpHandler = [[HttpHandler alloc] initWithDelegate:self]) callMethod:PListGetAccessTokenURIKey withParams:@[PListAccessTokenCodeParam, PListAccessTokenGrantTypeParam, PListAccessTokenRedirectURIParam] andValues:@[self.userDetails.code, @"authorization_code", [self.singlton.apiHelper valueForKey:PListRedirectURLKey]] andExtras:@[] requiresToken:NO withRequestMethod:@"GET"];
}

- (void)response:(NSString *)response WithParams:(NSArray *)params {
    AccessTokenParser *parser = [[AccessTokenParser alloc] initWithJSON:response];
    if (parser.accessToken && ![parser.accessToken isEqualToString:@""]) {
        [loadingView stopLoadingWithSuccess];
        [loginButton setHidden:YES];
        [self.userDetails setAccess_token:parser.accessToken];
        if (_delegate)
            [_delegate userLoggedIn];
    } else {
        [loadingView stopLoadingWithMessage:@"Fail"];
        [loginButton setTitle:[self.languageDetails LocalString:@"Login"] forState:UIControlStateNormal];
        [rememberView setHidden:NO];
    }
}

- (void)responseWithError:(NSString *)error WithParams:(NSArray *)params {
    [loadingView stopLoadingWithMessage:@"Fail"];
    [loginButton setTitle:[self.languageDetails LocalString:@"Login"] forState:UIControlStateNormal];
    [rememberView setHidden:NO];
}

@end
