//
//  RHFoursquare.h
//  RightHere
//
//  Created by Maxime de Chalendar on 02/08/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RHFoursquareController : NSObject

@property (strong, nonatomic) NSArray * places;
@property (strong, nonatomic) NSError * error;

- (void)getPlacesNearMe;
- (void)getPlacesWithName:(NSString *)name;

@end
