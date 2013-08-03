//
//  RHPost.h
//  RightHere
//
//  Created by Maxime de Chalendar on 03/08/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RHPost : NSObject

@property (strong, nonatomic, readonly) NSString * text;
@property (strong, nonatomic, readonly) NSURL * pictureURL;
@property (strong, nonatomic, readonly) NSString * userId;

- (id)initWithText:(NSString *)text userId:(NSString *)userId andPictureURL:(NSURL *)url;

@end
