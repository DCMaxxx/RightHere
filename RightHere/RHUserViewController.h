//
//  RHUserViewController.h
//  RightHere
//
//  Created by Maxime de Chalendar on 03/08/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RHUser.h"

@class RHInstagramModel;


@interface RHUserViewController : UIViewController

@property (weak, nonatomic) RHInstagramModel * igModel;
@property (weak, nonatomic) NSString * userId;

@end
