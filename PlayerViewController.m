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
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    _track_title.text = [Player sharedPlayer].currentTrack.track_title;
    _artist.text = [Player sharedPlayer].currentTrack.artist;
    
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

@end
