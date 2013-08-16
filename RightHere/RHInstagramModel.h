//
//  RHInstagram.h
//  RightHere
//
//  Created by Maxime de Chalendar on 03/08/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RHUser.h"

@interface RHInstagramModel : NSObject

@property (strong, nonatomic) NSArray * posts;
@property (strong, nonatomic) NSError * error;
@property (strong, nonatomic) RHUser * user;

- (void)getMediasFromPlaceId:(NSString *)placeId;
- (void)searchForUserWithId:(NSString *)userId;

@end
