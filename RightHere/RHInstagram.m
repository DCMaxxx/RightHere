//
//  RHInstagram.m
//  RightHere
//
//  Created by Maxime de Chalendar on 03/08/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "AFHTTPRequestOperation.h"
#import "Reachability.h"

#import "RHInstagram.h"

#import "RHNetworkActivityHandler.h"
#import "RHInstagramClient.h"
#import "RHPost.h"

@interface RHInstagram ()

@property (strong, nonatomic) RHInstagramClient * client;

@end


/*----------------------------------------------------------------------------*/
#pragma mark - Implemenattation
/*----------------------------------------------------------------------------*/
@implementation RHInstagram


/*----------------------------------------------------------------------------*/
#pragma mark - Init
/*----------------------------------------------------------------------------*/
- (id)init {
    if (self = [super init]) {
        _client = [[RHInstagramClient alloc] init];
    }
    return self;
}

/*----------------------------------------------------------------------------*/
#pragma mark - Getting medias
/*----------------------------------------------------------------------------*/
- (void)getMediasFromPlaceId:(NSString *)placeId {
    NSMutableURLRequest * request = [_client requestWithMethod:@"GET" path:@"locations/search" parameters:@{@"foursquare_v2_id": placeId,
                                                                                                            @"authentication": @(YES)}];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[RHNetworkActivityHandler sharedInstance] endNetworkTask];
        NSString * placeId = [self parseForId:responseObject];
        if (!placeId)
            return ;
        NSString * path = [NSString stringWithFormat:@"locations/%@/media/recent", placeId];
        NSMutableURLRequest * secondRequest = [_client requestWithMethod:@"GET" path:path parameters:@{@"authentication": @(YES)}];
        AFHTTPRequestOperation * secondOperation = [[AFHTTPRequestOperation alloc] initWithRequest:secondRequest];
        [secondOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[RHNetworkActivityHandler sharedInstance] endNetworkTask];
            self.posts = [self parseForPosts:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[RHNetworkActivityHandler sharedInstance] endNetworkTask];
            self.error = error;
        }];
        if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable) {
            [[RHNetworkActivityHandler sharedInstance] startNetworkTask];
            [secondOperation start];
        }
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
#pragma mark - Parsing Instagram's response
/*----------------------------------------------------------------------------*/
- (NSString *)parseForId:(id)data {
    NSArray * parsedData = [self dataArrayFromData:data];
    if (!parsedData)
        return nil;
    if (![parsedData count] || ![parsedData[0] isKindOfClass:[NSDictionary class]])
        return [self hadErrorParsing];
    return parsedData[0][@"id"];
}

- (NSArray *)parseForPosts:(id)data {
    NSArray * parsedData = [self dataArrayFromData:data];
    if (!parsedData)
        return nil;
    NSMutableArray * result = [NSMutableArray array];
    for (NSDictionary * post in parsedData) {
        if ([post isKindOfClass:[NSDictionary class]]
            && [post[@"type"] isKindOfClass:[NSString class]]
            && [post[@"type"] isEqualToString:@"image"]) {
            id caption = post[@"caption"];
            NSString * text = [[NSString alloc] init];
            if ([caption isKindOfClass:[NSDictionary class]] && [caption[@"text"] isKindOfClass:[NSString class]])
                text = caption[@"text"];
            id image = post[@"images"];
            NSString * url = [[NSString alloc] init];
            if ([image isKindOfClass:[NSDictionary class]] && [image[@"thumbnail"] isKindOfClass:[NSDictionary class]]
                && [image[@"thumbnail"][@"url"] isKindOfClass:[NSString class]])
                url = image[@"thumbnail"][@"url"];
            if ([text length] || [url length]) {
                RHPost * post = [[RHPost alloc] initWithText:text andPictureURL:[NSURL URLWithString:url]];
                [result addObject:post];
            }
        }
    }
    return result;
}

- (NSArray *)dataArrayFromData:(NSData *)data {
    NSError * error = nil;
    id parsed = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        self.error = error;
        return nil;
    }
    if (![parsed isKindOfClass:[NSDictionary class]] || ![parsed[@"data"] isKindOfClass:[NSArray class]])
        return [self hadErrorParsing];
    return parsed[@"data"];
}

- (id)hadErrorParsing {
    self.error = [NSError errorWithDomain:@"Instagram" code:42 userInfo:@{@"desc": @"Unable to parse Instagram's response"}];
    return nil;
}

@end
