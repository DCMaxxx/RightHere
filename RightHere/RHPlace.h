//
//  RHPlace.h
//  RightHere
//
//  Created by Maxime de Chalendar on 02/08/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RHPlace : NSObject

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSNumber * distance;
@property (strong, nonatomic) NSString * address;
@property (strong, nonatomic) NSString * foursquareUID;

- (id)initWithName:(NSString *)name address:(NSString *)address distance:(NSNumber *)distance andFoursquareUID:(NSString *)foursquareUID;

@end
