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

- (id)initWithText:(NSString *)text andPictureURL:(NSURL *)url;

@end
