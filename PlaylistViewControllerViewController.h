//
//  PlaylistViewControllerViewController.h
//  Ecstatic
//
//  Created by David Hernon on 2015-07-27.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Playlist.h"
#import "MediaItemTableViewCell.h"
#import "PlaylistDelegate.h"

@interface PlaylistViewControllerViewController : UIViewController <PlaylistDelegate>
@property (weak, nonatomic) IBOutlet UITableView *playlistTableView;

@end
