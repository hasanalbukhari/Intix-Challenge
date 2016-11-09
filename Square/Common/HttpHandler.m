//
//  HttpHandler.m
//  Yummy Wok
//
//  Created by Hasan S. Al-Bukhari on 12/11/14.
//  Copyright (c) 2014 Watershade. All rights reserved.
//

#import "HttpHandler.h"
#import "Singlton.h"

@implementation HttpHandler

@synthesize delegate = _delegate;
@synthesize baseUrl = _baseUrl;
@synthesize user_name = _user_name;
@synthesize password = _password;
@synthesize received_data = _received_data;
@synthesize download_connection = _download_connection;
@synthesize params = _params;
@synthesize extras = _extras;
@synthesize language = _language;
@synthesize access_token = _access_token;
@synthesize version = _version;
@synthesize singlton;

// only to initialise object and delegate. no server hits.
- (id)initWithDelegate:(id <HttpDelegate>)del
{
    if ([super init]) {
        
        singlton = [Singlton singlton];
        
        self.delegate = del;
        self.baseUrl = [[singlton apiHelper] baseURL];
        self.version = [[singlton apiHelper] apiVersion];
        self.access_token = [[singlton userDetails] access_token];
        self.language = [[singlton languageDetails] language];
        self.user_name = @"";
        self.password = @"";
    }
    return self;
}

- (void)callMethod:(NSString *)method_name withParams:(NSArray *)params andValues:(NSArray *)values andExtras:(NSArray *)extras {
    [self callMethod:method_name withParams:params andValues:values andExtras:extras requiresToken:YES withRequestMethod:@"GET"];
}

// call a service method.
- (void)callMethod:(NSString *)method_name withParams:(NSArray *)params andValues:(NSArray *)values andExtras:(NSArray *)extras requiresToken:(BOOL)requires_token withRequestMethod:(NSString *)request_method {
    self.extras = extras;
    self.params = @[method_name, params, values, extras];
    
    NSString *httpBody = @"";
    
    // initialise the method url.
    NSString *base_url = self.baseUrl;
    if (![method_name isEqualToString:PListGetAccessTokenURIKey]) {
        base_url = [NSString stringWithFormat:@"%@/v2", self.baseUrl];
        if ([base_url containsString:@"http://"]) {
            base_url = [base_url stringByReplacingOccurrencesOfString:@"http://" withString:@"http://api."];
        } else if ([base_url containsString:@"https://"]) {
            base_url = [base_url stringByReplacingOccurrencesOfString:@"https://" withString:@"https://api."];
        }
    }
    
    NSString *url;
    if (!requires_token)
        url = [NSString stringWithFormat:@"%@/%@?client_id=%@&client_secret=%@&v=%@", base_url, [[singlton apiHelper] uriForMethod:method_name], [[singlton apiHelper] clientId], [[singlton apiHelper] clientSecret], self.version];
    else
        url = [NSString stringWithFormat:@"%@/%@?oauth_token=%@&v=%@", base_url, [[singlton apiHelper] uriForMethod:method_name], singlton.userDetails.access_token, self.version];

    NSString *seperator = @"";
    // add parameters and values
    for (int i=0;i<params.count;i++)
    {
        if ([params[i] isEqualToString:@""]) {
            url = [Common replaceFirstOccuarnceFromString:url withOriginal:@"%@" AndReplacment:values[i]];
        } else {
            if ([request_method isEqualToString:@"POST"] || [request_method isEqualToString:@"PUT"]) {
                httpBody = [httpBody stringByAppendingString:[seperator stringByAppendingString: [NSString stringWithFormat:@"%@=%@", [[singlton apiHelper] valueForKey:[params objectAtIndex:i]], [values objectAtIndex:i]]]];
                seperator = @"&";
            } else {
                url = [url stringByAppendingString:[@"&" stringByAppendingString: [NSString stringWithFormat:@"%@=%@", [[singlton apiHelper] valueForKey:[params objectAtIndex:i]], [values objectAtIndex:i]]]];
            }
        }
    }
    NSData *bodyData = [httpBody dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *URL = [[NSURL alloc] initWithString:url];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:connection_time_out];
    
    [request setHTTPMethod:request_method];
    if ([request_method isEqualToString:@"POST"] || [request_method isEqualToString:@"PUT"])
        [request setHTTPBody:bodyData];
    
    self.received_data = [[NSMutableData alloc] init];
    
    // if the connection running cancel it. to init a new one.
    if (self.download_connection != nil) {
        [self.download_connection cancel];
        self.download_connection = nil;
    }
    // start the http hit
    self.download_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // logging curl command! nice ha :)
    DDLogVerbose(@"Curl Command: curl '%@' -d '%@'", url, [httpBody stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]);
}

// cancel the http hit. It's not garanteed that the data didn't received to the server. you will not get the response though.
- (void)cancel
{
    self.delegate = nil;
    if (self.download_connection != nil) {
        [self.download_connection cancel];
        self.download_connection = nil;
    }
}

// will be called if a password set to the services folder
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge previousFailureCount] == 0) {
        NSURLCredential *newCredential = [NSURLCredential credentialWithUser:self.user_name password:self.password persistence:NSURLCredentialPersistenceForSession];
        [[challenge sender] useCredential:newCredential forAuthenticationChallenge:challenge];
    } else {
        DDLogVerbose(ConnectionAuthenticationFailure);
        if (self.delegate)
            [self.delegate responseWithError:ConnectionAuthenticationFailure WithParams:self.params];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.download_connection cancel];
    self.download_connection = nil;
    
    if (self.delegate)
        [self.delegate responseWithError:error.description WithParams:self.params];
    DDLogVerbose(@"Connection Failed with error: %@", [error description]);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    NSInteger state = [httpResponse statusCode];
        
    if (state >= 400 && state <600)
    {
        // something wrong happen.
        [self.download_connection cancel];
        self.download_connection = nil;
        
        if (self.delegate)
            [self.delegate responseWithError:[response description] WithParams:self.params];
    }
    
    DDLogVerbose(@"HTTP Response : %@", [response description]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.received_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *decoded_string = [[NSString alloc] initWithBytes:[self.received_data bytes] length:[self.received_data length] encoding:NSUTF8StringEncoding];
    DDLogVerbose(@"XML : %@", decoded_string);
    
    if (self.delegate)
        [self.delegate response:decoded_string WithParams:self.params];
    
    self.download_connection = nil;
}

@end
