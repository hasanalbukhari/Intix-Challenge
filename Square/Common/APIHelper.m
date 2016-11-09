//
//  APIHelper.m
//  Souq Price Tracker
//
//  Created by Hasan S. Al-Bukhari on 2/26/16.
//  Copyright © 2016 Hasan. All rights reserved.
//

#import "APIHelper.h"

@implementation APIHelper

@synthesize plistDictionary;
@synthesize clientId = _clientId;
@synthesize clientSecret = _clientSecret;
@synthesize baseURL = _baseURL;
@synthesize authorizationURL = _authorizationURL;
@synthesize apiVersion = _apiVersion;

- (id)init
{
    if (self = [super init]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"api_config" ofType:@"plist"];
        if (path) {
            plistDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
        }
    }
    return  self;
}

- (NSString *)authorizationURL {
    if (!_authorizationURL) {
        NSString *authorizationURI = [self valueForKey:PListAuthorizationUriKey];
        NSString *redirectURL = [self valueForKey:PListRedirectURLKey];
    
        _authorizationURL = [NSString stringWithFormat:
                            @"%@/%@/?redirect_uri=%@&client_id=%@&response_type=code",
                             self.baseURL, authorizationURI, redirectURL, self.clientId];
    }
    
    DDLogVerbose(@"Authorizatoin URL: %@", _authorizationURL);
    return _authorizationURL;
}

- (id) valueForKey:(NSString *)key {
    return [plistDictionary valueForKey:key];
}

- (id) uriForMethod:(NSString *)method_name {
    return [self valueForKey:method_name];
}

- (void)userAuthorized:(NSString *)code {
    DDLogVerbose(@"User Authorized with code: %@", code);
    if (_delegate)
    {
        DDLogVerbose(@"Delegate informed for Authorization.");
        [_delegate userAuthorized:code];
    }
    else
    {
        DDLogVerbose(@"No delegate to get informed for authorization!");
    }
}

- (NSString *)clientId {
    if (!_clientId) {
        _clientId = [self valueForKey:PListClientIdKey];
    }
    return _clientId;
}

- (NSString *)clientSecret {
    if (!_clientSecret) {
        _clientSecret = [self valueForKey:PListClientSecretKey];
    }
    return _clientSecret;
}

- (NSString *)baseURL {
    if (!_baseURL) {
        _baseURL = [self valueForKey:PListBaseUrlKey];
    }
    return _baseURL;
}

- (NSString *)apiVersion {
    if (!_apiVersion) {
        _apiVersion = [self valueForKey:PListApiVersionKey];
    }
    return _apiVersion;
}

@end
