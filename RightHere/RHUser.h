//
//  RHUser.h
//  RightHere
//
//  Created by Maxime de Chalendar on 03/08/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RHUser : NSObject

@property (strong, nonatomic, readonly) NSString * userName;
@property (strong, nonatomic, readonly) NSString * fullName;
@property (strong, nonatomic, readonly) NSString * website;
@property (strong, nonatomic, readonly) NSString * bio;
@property (strong, nonatomic, readonly) UIImage * picture;

- (id)initWithUserName:(NSString *)username fullName:(NSString *)fullName
               webSite:(NSString *)website bio:(NSString *)bio andPicture:(UIImage *)picture;


@end
