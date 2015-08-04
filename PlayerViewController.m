//
//  PlayerViewController.m
//  Ecstatic
//
//  Created by David Hernon on 2015-07-20.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "PlayerViewController.h"

@interface PlayerViewController ()

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[Player sharedPlayer] addDelegate:self];

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{

        [self initPlayerUI:0.0f withTrack:[Player sharedPlayer].currentTrack atIndex:[Player sharedPlayer].currentTrackIndex];
    _channel_title.text = [Room currentRoom].room_name;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if(![Player sharedPlayer].currentTrack)
    {
        [[Player sharedPlayer] play];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exploreButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"playerToExplore" sender:self];
}

- (IBAction)homeButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"playerToHome" sender:self];
}

- (IBAction)playlistButtonAction:(id)sender
{
    [self performSegueWithIdentifier:@"playerToPlaylist" sender:self];
}

- (void) setCurrentSliderValue:(AVPlayer*)childPlayer
{
    AVPlayerItem *asset = childPlayer.currentItem;
    AVAsset *asset2 = asset.asset;
    float dur = CMTimeGetSeconds(asset2.duration)*1.0f;
    //if slier max val wasnt set, set it
    if(_slider.maximumValue == 0.0f || _slider.maximumValue == 1.0f)
    {
        float current_duration = (1.0f*CMTimeGetSeconds(childPlayer.currentItem.asset.duration));
        if(isnan(current_duration))
        {
            current_duration = 1.0f;
        }
        _slider.maximumValue = current_duration;
    }
    
    //set the current time and slider val
    float sec = CMTimeGetSeconds([childPlayer currentTime]);
    [_slider setValue:sec animated:YES];
    _current_time.text = [Utils convertTimeFromMillis:(int)1000*sec];
    NSLog(@"current time: %@", _current_time.text);
}

- (void) initPlayerUI:(float)duration withTrack:(MediaItem*)currentTrack atIndex:(int)index
{
    NSLog(@"Is the index null? : %d",index);
    if(!isnan(duration)){
        _slider.maximumValue = duration;
    }
    _slider.value = 0.0;
    _current_duration.text = currentTrack.duration;
    _current_time.text = @"0";
    
    _track_title.text = currentTrack.track_title;
    _artist.text = currentTrack.artist;
    _album_image.image = currentTrack.artwork;
    
}

- (void) redrawUI
{
//    MediaItem *currentTrack = [[Player sharedPlayer] currentTrack];
//    _track_title.text = currentTrack.track_title;
//    _artist.text = currentTrack.artist;
//    _album_image.image = currentTrack.artwork;
}


@end
