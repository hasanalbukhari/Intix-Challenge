//
//  AccessTokenParser.m
//  Square
//
//  Created by Hasan S. Al-Bukhari on 11/8/16.
//  Copyright © 2016 INTIX. All rights reserved.
//

#import "AccessTokenParser.h"

@implementation AccessTokenParser

@synthesize accessToken;

- (id)initWithJSON:(NSString *)json {
    
    if ((self = [super init])) {
        
        accessToken = @"";
        
        @try {
            
            NSError *e = nil;
            NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                     options:kNilOptions
                                                                       error:&e];
            
            accessToken = [jsonDict valueForKey:@"access_token"];
            
        } @catch (NSException *exception) {
            accessToken = nil;
            NSLog(@"Access Token ::::: Json Parsing Exception ::::: %@", [exception debugDescription]);
        }
        @finally {
            
        }
    }
    
    return self;
}

@end
