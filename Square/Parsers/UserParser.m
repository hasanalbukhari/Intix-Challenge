//
//  UserParser.m
//  Square
//
//  Created by Hasan S. Al-Bukhari on 11/8/16.
//  Copyright © 2016 INTIX. All rights reserved.
//

#import "UserParser.h"

@implementation UserParser

@synthesize user;

- (id)initWithJSON:(NSString *)json {
    
    if ((self = [super init])) {
        
        user = [[UserDetails alloc] initWithNoCache];
        
        @try {
            
            NSError *e = nil;
            NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                     options:kNilOptions
                                                                       error:&e];
            
            NSDictionary *response = [jsonDict objectForKey:@"response"];
            NSDictionary *user_dict = [response objectForKey:@"user"];
            
            [user setName:[user_dict valueForKey:@"firstName"]];
            NSString *lastName = [user_dict valueForKey:@"lastName"];
            
            if (lastName)
                [user setFull_name:[NSString stringWithFormat:@"%@ %@", user.name, lastName]];
            else
                [user setFull_name:user.name];
            
            NSDictionary *photo_dict = [user_dict objectForKey:@"photo"];
            if (photo_dict) {
                NSString *prefix = [photo_dict valueForKey:@"prefix"];
                NSString *suffix = [photo_dict valueForKey:@"suffix"];
                NSString *url = [NSString stringWithFormat:@"%@200%@", prefix, suffix];
                [user setProfile_pic:url];
            }
            
        } @catch (NSException *exception) {
            user = nil;
            DDLogVerbose(@"Foursquare User ::::: Json Parsing Exception ::::: %@", [exception debugDescription]);
        }
        @finally {
            
        }
    }
    
    return self;
}

@end
