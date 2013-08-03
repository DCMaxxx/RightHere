//
//  RHInstagram.h
//  RightHere
//
//  Created by Maxime de Chalendar on 03/08/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RHInstagram : NSObject

@property (strong, nonatomic) NSArray * posts;
@property (strong, nonatomic) NSError * error;

- (void)getMediasFromPlaceId:(NSString *)placeId;

@end
