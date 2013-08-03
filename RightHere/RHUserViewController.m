//
//  RHUserViewController.m
//  RightHere
//
//  Created by Maxime de Chalendar on 03/08/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "RHUserViewController.h"

#import "RHUser.h"

@interface RHUserViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UIButton *webSite;
@property (weak, nonatomic) IBOutlet UITextView *bio;

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
    }
}


/*----------------------------------------------------------------------------*/
#pragma mark - IBActions
/*----------------------------------------------------------------------------*/
- (IBAction)touchedWebsite:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[_webSite titleLabel] text]]];
}


/*----------------------------------------------------------------------------*/
#pragma mark - UI Update methods
/*----------------------------------------------------------------------------*/
- (void)updateUIWithUser:(RHUser *)user {
    [_picture setImage:[user picture]];
    [_userName setText:[user userName]];
    [_fullName setText:[user fullName]];
    if ([[user website] length]) {
        [_webSite setTitle:[user website] forState:UIControlStateNormal];
        [_webSite setHidden:NO];
    }
    if ([[user bio] length]) {
        [_bio setText:[user bio]];
    } else {
        [_bio setText:@"No bio..."];
        [_bio setTextColor:[UIColor lightGrayColor]];
        [_bio setTextAlignment:NSTextAlignmentCenter];
    }
}

@end
