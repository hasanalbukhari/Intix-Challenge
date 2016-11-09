//
//  AccessTokenParser.h
//  Square
//
//  Created by Hasan S. Al-Bukhari on 11/8/16.
//  Copyright © 2016 INTIX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccessTokenParser : NSObject

@property (nonatomic, strong) NSString *accessToken;

- (id)initWithJSON:(NSString *)json;

@end
