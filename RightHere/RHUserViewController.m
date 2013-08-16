//
//  RHUserViewController.m
//  RightHere
//
//  Created by Maxime de Chalendar on 03/08/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import "RHUserViewController.h"
#import "RHInstagramModel.h"

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
#pragma mark - UIViewDelgate
/*----------------------------------------------------------------------------*/
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_igModel addObserver:self forKeyPath:@"user" options:NSKeyValueObservingOptionNew context:nil];
    [_igModel addObserver:self forKeyPath:@"error" options:NSKeyValueObservingOptionNew context:nil];
    [_igModel searchForUserWithId:_userId];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_igModel removeObserver:self forKeyPath:@"user"];
    [_igModel removeObserver:self forKeyPath:@"error"];
}

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
    else if ([keyPath isEqualToString:@"user"]) {
        RHUser * user = [object valueForKeyPath:keyPath];
        [self updateUIWithUser:user];
    }
}


/*----------------------------------------------------------------------------*/
#pragma mark - IBActions
/*----------------------------------------------------------------------------*/
- (IBAction)touchedWebsite:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[_webSite titleLabel] text]]];
}


/*----------------------------------------------------------------------------*/
#pragma mark - Misc private methods
/*----------------------------------------------------------------------------*/
- (void)updateUIWithUser:(RHUser *)user {
    [_picture setImageWithURL:[user pictureURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
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
