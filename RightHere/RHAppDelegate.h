//
//  RHAppDelegate.h
//  RightHere
//
//  Created by Maxime de Chalendar on 02/08/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"


@interface RHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Reachability * reachability;

@end
