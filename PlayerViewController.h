//
//  PlayerViewController.h
//  Ecstatic
//
//  Created by David Hernon on 2015-07-20.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import "PlayerDelegate.h"
@class PlayerDelegate;

@interface PlayerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *track_title;
@property (weak, nonatomic) IBOutlet UILabel *artist;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *current_duration;
@property (weak, nonatomic) IBOutlet UILabel *current_time;
@property (weak, nonatomic) IBOutlet UIImageView *album_image;
@property (weak, nonatomic) IBOutlet UILabel *channel_title;

@end
