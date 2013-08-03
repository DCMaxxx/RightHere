//
//  RHPlace.m
//  RightHere
//
//  Created by Maxime de Chalendar on 02/08/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "RHPlace.h"


/*----------------------------------------------------------------------------*/
#pragma mark - Implemenation
/*----------------------------------------------------------------------------*/
@implementation RHPlace


/*----------------------------------------------------------------------------*/
#pragma mark - Init
/*----------------------------------------------------------------------------*/
- (id)initWithName:(NSString *)name address:(NSString *)address distance:(NSNumber *)distance andFoursquareUID:(NSString *)foursquareUID {
    if (self = [super init]) {
        _name = name;
        _address = address;
        _distance = distance;
        _foursquareUID = foursquareUID;
    }
    return self;
}

@end
