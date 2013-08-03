//
//  RHViewController.m
//  RightHere
//
//  Created by Maxime de Chalendar on 02/08/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "Reachability.h"

#import "RHViewController.h"

#import "RHNetworkActivityHandler.h"
#import "RHUserViewController.h"
#import "RHCollectionViewCell.h"
#import "RHFoursquare.h"
#import "RHInstagram.h"
#import "RHPlace.h"
#import "RHPost.h"

@interface RHViewController ()

@property (weak, nonatomic) IBOutlet UILabel * topLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;

@property (strong, nonatomic) NSArray * places;
@property (strong, nonatomic) RHFoursquare * foursquareSearcher;

@property (strong, nonatomic) NSArray * posts;
@property (strong, nonatomic) RHInstagram * instagramSearcher;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSTimer * timer;

@end


/*----------------------------------------------------------------------------*/
#pragma mark - Implementation
/*----------------------------------------------------------------------------*/
@implementation RHViewController


/*----------------------------------------------------------------------------*/
#pragma mark - Init
/*----------------------------------------------------------------------------*/
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _foursquareSearcher = [[RHFoursquare alloc] init];
        [_foursquareSearcher addObserver:self forKeyPath:@"places" options:NSKeyValueObservingOptionNew context:nil];
        [_foursquareSearcher addObserver:self forKeyPath:@"error" options:NSKeyValueObservingOptionNew context:nil];
        
        _instagramSearcher = [[RHInstagram alloc] init];
        [_instagramSearcher addObserver:self forKeyPath:@"posts" options:NSKeyValueObservingOptionNew context:nil];
        [_instagramSearcher addObserver:self forKeyPath:@"error" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}


/*----------------------------------------------------------------------------*/
#pragma mark - UIViewDelegate
/*----------------------------------------------------------------------------*/
- (void)viewDidLoad {
    [super viewDidLoad];
}


/*----------------------------------------------------------------------------*/
#pragma mark - UISearchDisplayController
/*----------------------------------------------------------------------------*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];

    RHPlace * place = [_places objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[place name]];
    NSString * detail = [[NSString alloc] init];
    if ([place address])
        detail = [detail stringByAppendingFormat:@"Address : %@%@", [place address], ([place distance] ? @", " : @"")];
    if ([place distance])
        detail = [detail stringByAppendingFormat:@"%@ m. away", [place distance]];
    [[cell detailTextLabel] setText:detail];
    [cell setTag:[indexPath row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    RHPlace * place = [_places objectAtIndex:[indexPath row]];
    [_topLabel setText:[NSString stringWithFormat:@"What's happening in %@ ?", [place name]]];
    [_topLabel setHidden:NO];
    [[self searchDisplayController] setActive:NO animated:YES];
    
    [_instagramSearcher getMediasFromPlaceId:[place foursquareUID]];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (_timer) {
        if ([_timer isValid])
            [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(getPlacesNow) userInfo:nil repeats:NO];
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
    } else if (object == _foursquareSearcher) {
        if ([keyPath isEqualToString:@"places"]) {
            _places = [_foursquareSearcher places];
            [[[self searchDisplayController] searchResultsTableView] reloadData];
        }
    } else if (object == _instagramSearcher) {
        if ([keyPath isEqualToString:@"posts"]) {
            _posts = [_instagramSearcher posts];
            [_collectionView reloadData];
            if (!_posts || ![_posts count]) {
                [_centerLabel setText:@"Oops... Couldn't find any pictures !"];
                [_centerLabel setHidden:NO];
            } else {
                [_centerLabel setHidden:YES];
            }
        }
    }
}


/*----------------------------------------------------------------------------*/
#pragma mark - UICollectionViewDataSource
/*----------------------------------------------------------------------------*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_posts count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RHCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PictureCell" forIndexPath:indexPath];
    NSInteger index = [indexPath row];
    RHPost * post = [_posts objectAtIndex:index];

    [[cell description] setText:[post text]];

//    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(concurrentQueue, ^{
//        if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable) {
//            [[RHNetworkActivityHandler sharedInstance] startNetworkTask];
//            NSData *image = [[NSData alloc] initWithContentsOfURL:post.pictureURL];
//            [[RHNetworkActivityHandler sharedInstance] endNetworkTask];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [[cell picture] setImage:[UIImage imageWithData:image]];
//            });
//        }
//    });
    [[cell picture] setImageWithURL:[post pictureURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    return cell;
}


/*----------------------------------------------------------------------------*/
#pragma mark - Passing to other ViewControllers
/*----------------------------------------------------------------------------*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"UserViewController"]) {
        NSArray * selectedCells = [[self collectionView] indexPathsForSelectedItems];
        NSIndexPath * path = [selectedCells objectAtIndex:0];
        NSUInteger index = [path row];
        RHPost * post = [_posts objectAtIndex:index];
        RHUserViewController * vc = [segue destinationViewController];
        [_instagramSearcher setUserViewController:vc];
        [_instagramSearcher searchForUserWithId:[post userId]];
    }
}

/*----------------------------------------------------------------------------*/
#pragma mark - Misc private methods
/*----------------------------------------------------------------------------*/
- (void)getPlacesNow {
    [_foursquareSearcher getPlacesWithName:[[[self searchDisplayController] searchBar] text]];
}

@end
