//
//  RHFoursquare.m
//  RightHere
//
//  Created by Maxime de Chalendar on 02/08/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "AFHTTPRequestOperation.h"
#import "Reachability.h"

#import "RHFoursquareModel.h"

#import "RHNetworkActivityHandler.h"
#import "RHFoursquareClient.h"
#import "RHPlace.h"

typedef enum { eNearby, eNameSearch } eRequestKind;

@interface RHFoursquareModel ()

@property (strong, nonatomic) CLLocationManager * locationManager;
@property (strong, nonatomic) RHFoursquareClient * client;

@end


/*----------------------------------------------------------------------------*/
#pragma mark - Implementation
/*----------------------------------------------------------------------------*/
@implementation RHFoursquareModel


/*----------------------------------------------------------------------------*/
#pragma mark - Init
/*----------------------------------------------------------------------------*/
- (id)init {
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDistanceFilter:kCLDistanceFilterNone];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
            [_locationManager startUpdatingLocation];
        }
        _client = [[RHFoursquareClient alloc] init];
    }
    return self;
}


/*----------------------------------------------------------------------------*/
#pragma mark - Getting places
/*----------------------------------------------------------------------------*/
- (void)getPlacesNearMe {
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized)
        return ;

    NSString * latLong = [NSString stringWithFormat:@"%f,%f", _locationManager.location.coordinate.latitude, _locationManager.location.coordinate.longitude];
    NSMutableURLRequest * request = [_client requestWithMethod:@"GET" path:@"venues/explore" parameters:@{@"ll": latLong, @"authentication": @(YES)}];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[RHNetworkActivityHandler sharedInstance] endNetworkTask];
        [self parseResponse:responseObject forRequest:eNearby];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[RHNetworkActivityHandler sharedInstance] endNetworkTask];
        self.error = error;
    }];
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable) {
        [[RHNetworkActivityHandler sharedInstance] startNetworkTask];
        [operation start];
    }
}

- (void)getPlacesWithName:(NSString *)name {
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized)
        return ;

    NSString * latLong = [NSString stringWithFormat:@"%f,%f", _locationManager.location.coordinate.latitude, _locationManager.location.coordinate.longitude];
    NSMutableURLRequest * request = [_client requestWithMethod:@"GET" path:@"venues/search" parameters:@{@"ll": latLong,
                                                                                                         @"query":name,
                                                                                                         @"authentication": @(YES)}];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[RHNetworkActivityHandler sharedInstance] endNetworkTask];
        [self parseResponse:responseObject forRequest:eNameSearch];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[RHNetworkActivityHandler sharedInstance] endNetworkTask];
        self.error = error;
    }];
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable) {
        [[RHNetworkActivityHandler sharedInstance] startNetworkTask];
        [operation start];
    }
}


/*----------------------------------------------------------------------------*/
#pragma mark - Parsing Foursquare's response
/*----------------------------------------------------------------------------*/
- (void)parseResponse:(id)response forRequest:(eRequestKind)kind {
    NSError * error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        self.error = error;
        return ;
    } else if (![result isKindOfClass:[NSDictionary class]]
               || ![result[@"response"] isKindOfClass:[NSDictionary class]])
        return [self hadErrorParsing];

    NSDictionary * responseBlock = result[@"response"];
    NSMutableArray * tmpPlaces = [NSMutableArray array];
    if (kind == eNearby) {
        if (![responseBlock[@"groups"] isKindOfClass:[NSArray class]])
            return [self hadErrorParsing];
        for (id group in responseBlock[@"groups"])
            if ([group isKindOfClass:[NSDictionary class]] && [group[@"items"] isKindOfClass:[NSArray class]])
                for (id item in group[@"items"])
                    if ([item isKindOfClass:[NSDictionary class]] && [item[@"venue"] isKindOfClass:[NSDictionary class]])
                        [self addVenue:item[@"venue"] inContainer:tmpPlaces];
    } else if (kind == eNameSearch) {
        if (![responseBlock[@"venues"] isKindOfClass:[NSArray class]])
            return [self hadErrorParsing];
        for (id venue in responseBlock[@"venues"])
            if ([venue isKindOfClass:[NSDictionary class]])
                [self addVenue:venue inContainer:tmpPlaces];
    }
    self.places = tmpPlaces;
}

- (void)addVenue:(NSDictionary *)venue inContainer:(NSMutableArray *)container {
    NSString * address = nil;
    NSNumber * distance = nil;
    if ([venue[@"location"] isKindOfClass:[NSDictionary class]]) {
        if ([venue[@"location"][@"address"] isKindOfClass:[NSString class]])
            address = venue[@"location"][@"address"];
        if ([venue[@"location"][@"distance"] isKindOfClass:[NSNumber class]])
            distance = venue[@"location"][@"distance"];
    }
    
    [container addObject:[[RHPlace alloc] initWithName:venue[@"name"]
                                               address:address
                                              distance:distance
                                      andFoursquareUID:venue[@"id"]]];
}

- (void)hadErrorParsing {
    self.error = [[NSError alloc] initWithDomain:@"Foursquare" code:42 userInfo:@{@"desc": @"Unable to parse FourSquare's anwser..."}];
}

@end
