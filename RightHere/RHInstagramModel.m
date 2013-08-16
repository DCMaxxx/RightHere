//
//  RHInstagram.m
//  RightHere
//
//  Created by Maxime de Chalendar on 03/08/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "AFHTTPRequestOperation.h"
#import "Reachability.h"

#import "RHInstagramModel.h"

#import "RHInstagramClient.h"
#import "RHPost.h"

@interface RHInstagramModel ()

@property (strong, nonatomic) RHInstagramClient * client;

@end


/*----------------------------------------------------------------------------*/
#pragma mark - Implemenattation
/*----------------------------------------------------------------------------*/
@implementation RHInstagramModel


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
#pragma mark - Getting instagram informations
/*----------------------------------------------------------------------------*/
- (void)getMediasFromPlaceId:(NSString *)placeId {
    NSMutableURLRequest * request = [_client requestWithMethod:@"GET" path:@"locations/search" parameters:@{@"foursquare_v2_id": placeId,
                                                                                                            @"authentication": @(YES)}];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString * placeId = [self parseForId:responseObject];
        if (!placeId) {
            self.posts = nil;
            return ;
        }
        NSString * path = [NSString stringWithFormat:@"locations/%@/media/recent", placeId];
        NSMutableURLRequest * secondRequest = [_client requestWithMethod:@"GET" path:path parameters:@{@"authentication": @(YES)}];
        AFHTTPRequestOperation * secondOperation = [[AFHTTPRequestOperation alloc] initWithRequest:secondRequest];
        [secondOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.posts = [self parseForPosts:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.error = error;
        }];
        if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable) {
            [secondOperation start];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.error = error;
    }];
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable) {
        [operation start];
    }
}

- (void)searchForUserWithId:(NSString *)userId {
    NSString * path = [NSString stringWithFormat:@"users/%@", userId];
    NSMutableURLRequest * request = [_client requestWithMethod:@"GET" path:path parameters:@{@"authentication": @(YES)}];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self parseForUser:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.error = error;
    }];
     if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable) {
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
        return nil;
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
            NSString * userId = [[NSString alloc] init];
            if ([caption isKindOfClass:[NSDictionary class]]) {
                if ([caption[@"text"] isKindOfClass:[NSString class]])
                    text = caption[@"text"];
                id user = caption[@"from"];
                if ([user isKindOfClass:[NSDictionary class]] && [user[@"id"] isKindOfClass:[NSString class]])
                    userId = user[@"id"];
            }
            id image = post[@"images"];
            NSString * url = [[NSString alloc] init];
            if ([image isKindOfClass:[NSDictionary class]] && [image[@"standard_resolution"] isKindOfClass:[NSDictionary class]]
                && [image[@"standard_resolution"][@"url"] isKindOfClass:[NSString class]])
                url = image[@"standard_resolution"][@"url"];
            if ([text length] || [url length]) {
                RHPost * post = [[RHPost alloc] initWithText:text userId:userId andPictureURL:[NSURL URLWithString:url]];
                [result addObject:post];
            }
        }
    }
    return result;
}

- (void)parseForUser:(id)data {
    NSDictionary * parsedData = [self dataDictionaryFromData:data];
    if (!parsedData)
        return ;
    NSString * userName = ([parsedData[@"username"] isKindOfClass:[NSString class]] ? parsedData[@"username"] : @"");
    NSString * fullName = ([parsedData[@"full_name"] isKindOfClass:[NSString class]] ? parsedData[@"full_name"] : @"");
    NSString * pictureUrl = ([parsedData[@"profile_picture"] isKindOfClass:[NSString class]] ? parsedData[@"profile_picture"] : @"");
    NSString * bio = ([parsedData[@"bio"] isKindOfClass:[NSString class]] ? parsedData[@"bio"] : @"");
    NSString * website = ([parsedData[@"website"] isKindOfClass:[NSString class]] ? parsedData[@"website"] : @"");
    self.user = [[RHUser alloc] initWithUserName:userName fullName:fullName webSite:website bio:bio andPictureURL:[NSURL URLWithString:pictureUrl]];
}

- (NSArray *)dataArrayFromData:(NSData *)data {
    NSError * error = nil;
    id parsed = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        self.error = error;
        return nil;
    }
    if (![parsed isKindOfClass:[NSDictionary class]] || ![parsed[@"data"] isKindOfClass:[NSArray class]])
        nil;
    return parsed[@"data"];
}

- (NSDictionary *)dataDictionaryFromData:(NSData *)data {
    NSError * error = nil;
    id parsed = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        self.error = error;
        return nil;
    }
    if (![parsed isKindOfClass:[NSDictionary class]] || ![parsed[@"data"] isKindOfClass:[NSDictionary class]])
        nil;
    return parsed[@"data"];
}

@end
