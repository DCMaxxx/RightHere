//
//  RHUser.m
//  RightHere
//
//  Created by Maxime de Chalendar on 03/08/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "RHUser.h"


/*----------------------------------------------------------------------------*/
#pragma mark - Implementation
/*----------------------------------------------------------------------------*/
@implementation RHUser


/*----------------------------------------------------------------------------*/
#pragma mark - Init
/*----------------------------------------------------------------------------*/
- (id)initWithUserName:(NSString *)username fullName:(NSString *)fullName
               webSite:(NSString *)website bio:(NSString *)bio andPicture:(UIImage *)picture {
    if (self = [super init]) {
        _userName = username;
        _fullName = fullName;
        _website = website;
        _bio = bio;
        _picture = picture;
    }
    return self;
}

@end
