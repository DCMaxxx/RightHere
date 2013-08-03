//
//  RHInstagramClient.m
//  RightHere
//
//  Created by Maxime de Chalendar on 02/08/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "InstagramAPI.h"
#import "RHInstagramClient.h"


/*----------------------------------------------------------------------------*/
#pragma mark - Implementation
/*----------------------------------------------------------------------------*/
@implementation RHInstagramClient


/*----------------------------------------------------------------------------*/
#pragma mark - Init
/*----------------------------------------------------------------------------*/
- (id)init {
    return (self = [super initWithBaseURL:[NSURL URLWithString:@"https://api.instagram.com/v1/"]]);
}

/*----------------------------------------------------------------------------*/
#pragma mark - HTTPClient
/*----------------------------------------------------------------------------*/
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameter {
    BOOL needsAuthentication = ([parameter objectForKey:@"authentication"] != nil);
    NSMutableDictionary * tmp = [parameter mutableCopy];
    if (needsAuthentication) {
        [tmp removeObjectForKey:@"authentication"];
        [tmp setObject:CLIENT_ID forKey:@"client_id"];
        [tmp setObject:CLIENT_SECRET forKey:@"client_secret"];
    }
    parameter = tmp;
    return [super requestWithMethod:method path:path parameters:parameter];
}

@end
