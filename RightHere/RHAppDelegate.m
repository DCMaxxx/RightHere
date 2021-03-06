//
//  RHAppDelegate.m
//  RightHere
//
//  Created by Maxime de Chalendar on 02/08/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "AFNetworkActivityIndicatorManager.h"
#import "Reachability.h"

#import "RHAppDelegate.h"


@implementation RHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:kReachabilityChangedNotification object:nil];
    _reachability = [Reachability reachabilityForInternetConnection];
    [_reachability startNotifier];
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"Location manager"
                                                      message:@"I can't get your position. Please fix it in settings."
                                                     delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
    return YES;
}
							
- (void)networkChanged:(NSNotification *)notification {
    NetworkStatus remoteHostStatus = [_reachability currentReachabilityStatus];
    if (remoteHostStatus == NotReachable) {
        UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"Network connection"
                                                      message:@"Your network connection seems to be down. Right Here requires internet connection."
                                                     delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
