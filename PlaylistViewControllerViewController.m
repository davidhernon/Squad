//
//  PlaylistViewControllerViewController.m
//  Ecstatic
//
//  Created by David Hernon on 2015-07-27.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "PlaylistViewControllerViewController.h"

@interface PlaylistViewControllerViewController ()

@end

@implementation PlaylistViewControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [Playlist sharedPlaylist].playlist.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MediaItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"player_media_item_cell"];
    
    MediaItem *item_at_current_index = [[Playlist sharedPlaylist].playlist objectAtIndex:indexPath.row];
    
    cell.track_title.text = item_at_current_index.track_title;
    cell.artist.text = item_at_current_index.artist;
    cell.album_image.image = item_at_current_index.artwork;
    return cell;
    
}

- (void) redrawUI
{
    [_playlistTableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)backButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"playlistToPlayer" sender:self];
}



@end
