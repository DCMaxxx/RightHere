//
//  RHPost.m
//  RightHere
//
//  Created by Maxime de Chalendar on 03/08/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "RHPost.h"


/*----------------------------------------------------------------------------*/
#pragma mark - Implementation
/*----------------------------------------------------------------------------*/
@implementation RHPost


/*----------------------------------------------------------------------------*/
#pragma mark - Init
/*----------------------------------------------------------------------------*/
- (id)initWithText:(NSString *)text andPictureURL:(NSURL *)url {
    if (self = [super init]) {
        _text = text;
        _pictureURL = url;
    }
    return self;
}

@end
