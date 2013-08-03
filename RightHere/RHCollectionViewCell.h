//
//  RHCollectionViewCell.h
//  RightHere
//
//  Created by Maxime de Chalendar on 02/08/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RHCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *description;

@end
