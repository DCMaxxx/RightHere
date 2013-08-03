//
//  RHNetworkActivityHandler.m
//  RightHere
//
//  Created by Maxime de Chalendar on 03/08/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "RHNetworkActivityHandler.h"

@interface RHNetworkActivityHandler ()

@property (nonatomic) NSUInteger currentOperations;

@end


/*----------------------------------------------------------------------------*/
#pragma mark - Implementation
/*----------------------------------------------------------------------------*/
@implementation RHNetworkActivityHandler


/*----------------------------------------------------------------------------*/
#pragma mark - Singleton creation
/*----------------------------------------------------------------------------*/
+ (RHNetworkActivityHandler *)sharedInstance {
    static dispatch_once_t pred;
    static RHNetworkActivityHandler *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[RHNetworkActivityHandler alloc] init];
    });
    return shared;
}


/*----------------------------------------------------------------------------*/
#pragma mark - Showing and hiding indicator
/*----------------------------------------------------------------------------*/
- (void)startNetworkTask {
    if (_currentOperations++ == 0)
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)endNetworkTask {
    if (--_currentOperations == 0)
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}



@end
