//
//  RHUserViewController.m
//  RightHere
//
//  Created by Maxime de Chalendar on 03/08/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "RHUserViewController.h"

#import "RHWebViewController.h"
#import "RHUser.h"

@interface RHUserViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UIButton *webSite;
@property (weak, nonatomic) IBOutlet UITextView *bio;

@property (strong, nonatomic) RHUser * user;

@end


/*----------------------------------------------------------------------------*/
#pragma mark - Implementation
/*----------------------------------------------------------------------------*/
@implementation RHUserViewController


/*----------------------------------------------------------------------------*/
#pragma mark - Observer
/*----------------------------------------------------------------------------*/
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"error"]) {
        NSError * error = [object valueForKeyPath:keyPath];
        UIAlertView * av = [[UIAlertView alloc] initWithTitle:[error domain]
                                                      message:[error userInfo][@"desc"]
                                                     delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];        
    } else if ([keyPath isEqualToString:@"user"]) {
        _user = [object valueForKeyPath:keyPath];
        [_picture setImage:[_user picture]];
        [_userName setText:[_user userName]];
        [_fullName setText:[_user fullName]];
        if ([[_user website] length]) {
            [_webSite setTitle:[_user website] forState:UIControlStateNormal];
            [_webSite setHidden:NO];
        }
        [_bio setText:[_user bio]];
    }
}


/*----------------------------------------------------------------------------*/
#pragma mark - IBActions
/*----------------------------------------------------------------------------*/
- (IBAction)touchedWebsite:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[_user website]]];
}

@end
