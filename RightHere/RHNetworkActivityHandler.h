//
//  RHNetworkActivityHandler.h
//  RightHere
//
//  Created by Maxime de Chalendar on 03/08/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RHNetworkActivityHandler : NSObject

+ (RHNetworkActivityHandler *)sharedInstance;

- (void)startNetworkTask;
- (void)endNetworkTask;

@end
