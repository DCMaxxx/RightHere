//
//  RHFoursquareClient.m
//  RightHere
//
//  Created by Maxime de Chalendar on 02/08/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "RHFoursquareClient.h"

#import "FoursquareAPI.h"


/*----------------------------------------------------------------------------*/
#pragma mark - Implementation
/*----------------------------------------------------------------------------*/
@implementation RHFoursquareClient

/*----------------------------------------------------------------------------*/
#pragma mark - Init
/*----------------------------------------------------------------------------*/
- (id)init {
    return (self = [super initWithBaseURL:[NSURL URLWithString:@"https://api.foursquare.com/v2/"]]);
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
    [tmp setObject:@"20130802" forKey:@"v"];
    parameter = tmp;
    return [super requestWithMethod:method path:path parameters:parameter];
}


@end
