//
//  MediaPickerViewController.m
//  Ecstatic
//
//  Created by David Hernon on 2015-07-27.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "MediaPickerViewController.h"

@interface MediaPickerViewController ()

@end

@implementation MediaPickerViewController

NSString *cellIdentifier = @"room_around_me_table_view_cell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self getSDSEventTracks];
    _channel_title_textfield.delegate = self;
    _search_textfield.delegate = self;
    
    _soundCloudResultsTableView.backgroundColor = [UIColor clearColor];
    
    
    // Remove line between cells
    self.soundCloudResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.soundCloudResultsTableView.allowsMultipleSelectionDuringEditing = YES;
    self.selectedTracks = [[NSMutableArray alloc] init];
    self.selectedTrackIndices = [[NSMutableArray alloc] init];
    self.soundCloudAlbumImages = [[NSMutableArray alloc] init];
    self.selected_favorites_indices = [[NSMutableArray alloc] init];
    self.selected_sds_indices = [[NSMutableArray alloc] init];
    self.selected_search_indices = [[NSMutableArray alloc] init];
    //    [self getAlbumImageArray];
    
    _current_media_picker_type = @"sds_mixes";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.selectedTracks = [[NSMutableArray alloc] init];
    
    //Get the album images
    [self getAlbumImageArray];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tracksFromSoundCloud.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MediaItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"media_item_cell"];
    
    if(!cell) //Every time cell is nil, dequeue not working
    {
        cell = [[MediaItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"media_item_cell"];
        
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    NSDictionary *track = [self.tracksFromSoundCloud objectAtIndex:indexPath.row];
    tableView.backgroundColor = [UIColor clearColor];
    NSString *title = [track objectForKey:@"title"];
    cell.track_title.text = title;
    
    if(indexPath.row < [_soundCloudAlbumImages count])
    {
        cell.album_image.image = [_soundCloudAlbumImages objectAtIndex:indexPath.row];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    for (int i = 0; i < _selectedTrackIndices.count; i++) {
        NSUInteger num = [[_selectedTrackIndices objectAtIndex:i] intValue];
        
        if (num == indexPath.row) {
            //            [self setCellColor:[UIColor whiteColor] ForCell:cell];
            cell.backgroundColor = [UIColor colorWithRed:0.369 green:0.078 blue:0.298 alpha:0.25];;
            // Once we find a match there is no point continuing the loop
            
            
            break;
        }
    }
    
    
    
    return cell;
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //MediaItem* mediaItemSelected = [self mediaItemFromCell:indexPath.row];
    //    NSDictionary *itemOne = [self.tracksFromSoundCloud objectAtIndex:indexPath.row];
    MediaItem* mediaItemSelected = [[MediaItem alloc] initWithSoundCloudTrack:[self.tracksFromSoundCloud objectAtIndex:indexPath.row]];
    
    if([tableView cellForRowAtIndexPath:indexPath].backgroundColor != [UIColor clearColor]){
        //        cell clicked and it was previously selected
        [self removeMediaItemFromSelectedTracks:mediaItemSelected];
        //        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        [tableView cellForRowAtIndexPath:indexPath].backgroundColor = [UIColor clearColor];
        [_selectedTrackIndices removeObject:@(indexPath.row)];
    }else{
        //        cell clicked and it was not previously selected
        if(![self itemAlreadySelected:mediaItemSelected])
            [self.selectedTracks addObject:mediaItemSelected];
        //        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [tableView cellForRowAtIndexPath:indexPath].backgroundColor = [UIColor colorWithRed:0.369 green:0.078 blue:0.298 alpha:0.25];
        //skip over this step if we are on search
        if(![_current_media_picker_type isEqualToString:@"search"])
            [_selectedTrackIndices addObject:@(indexPath.row)];
    }
    //    [self printSelectedTracks];
    
}


/*********/ // TEXT FIELD METHODS
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    NSString *channel_name = _channel_title_textfield.text;
    NSString *soundcloud_search_string = _search_textfield.text;
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    return YES;
}

-(void)dismissKeyboard {
    [_search_textfield resignFirstResponder];
    [_channel_title_textfield resignFirstResponder];
}

/*********/ // END OF TEXT FIELD METHODS

-(void) addSoundCloudFavorites:(NSArray*)tracks
{
//    MWLogDebug(@"soundCloudMediaPicker - soundCloudMediaPickerViewController - addSoundCloudFavorites - adding tracks, number of tracks: %i", tracks.count);
    self.tracksFromSoundCloud = tracks;
    [self.soundCloudResultsTableView reloadData];
    
}

-(void)printSelectedTracks
{
    for(MediaItem* mediaItem in self.selectedTracks){
        NSLog(@"%@", mediaItem.track_title);
    }
}

//Checks to see if the MediaItem selected was already selected
-(BOOL)itemAlreadySelected:(MediaItem*)selected
{
    for(MediaItem * mediaItem in self.selectedTracks)
    {
        if(selected.track_title == mediaItem.track_title && selected.artist == mediaItem.artist)
        {
            return true;
        }
    }
    return false;
}

//Change which list we track selections with
// used for highlighting the proper songs in the list depending on which list is selected
-(void)changeSelectedListWithString:(NSString*)new_list from:(NSString*)old_list
{
    
//    MWLogDebug(@"soundCloudMediaPicker - soundCloudMediaPickerViewController - changeSelectedListWithString - to new list: %@ from old_list: %@", new_list, old_list);
    
    //save the current track indices into the proper lists
    if([_current_media_picker_type isEqualToString:@"favorites"]){
        _selected_favorites_indices = _selectedTrackIndices;
    }else if([_current_media_picker_type isEqualToString:@"sds_mixes"]){
        _selected_sds_indices = _selectedTrackIndices;
    }else{
        _selected_search_indices = _selectedTrackIndices;
    }
    
    //change which current indices list we are holding
    _current_media_picker_type  = new_list;
    
    //set the selectedIndices to the new list selected indices
    if([new_list isEqualToString:@"favorites"]){
        _selectedTrackIndices = _selected_favorites_indices;
    }else if([new_list isEqualToString:@"sds_mixes"]){
        _selectedTrackIndices = _selected_sds_indices;
    }else{
        //search
        _selectedTrackIndices = _selected_search_indices;
    }
    
    _selected_search_indices = @[];
}


-(void)removeMediaItemFromSelectedTracks:(MediaItem *)itemToRemove
{
    NSUInteger indexToDelete = -1;
    NSUInteger counter = 0;
    for(MediaItem * mediaItem in self.selectedTracks)
    {
        if(itemToRemove.track_title == mediaItem.track_title && itemToRemove.artist == mediaItem.artist)
        {
            indexToDelete = counter;
        }
        counter++;
    }
    if(indexToDelete!=-1){
        [self.selectedTracks removeObjectAtIndex:indexToDelete];
    }
}

//-(IBAction)addSelectedTracksToPlaylist:(id)sender
//{
//    [[Playlist sharedPlaylist] addTracks:self.selectedTracks];
//    for(MediaItem* item in self.selectedTracks)
//    {
//        [Ecstatic addSong:[item serializeMediaItem]];
//    }
//}

-(void) getAlbumImageArray
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _soundCloudAlbumImages = nil;
        _soundCloudAlbumImages = [[NSMutableArray alloc] init];
        while(_tracksFromSoundCloud == nil)
        {
            [NSThread sleepForTimeInterval:0.1f];
        }
        
        for(NSDictionary *track in _tracksFromSoundCloud)
        {
            NSString *url = [track objectForKey:@"artwork_url"];
            if([url isEqual:[NSNull null]]){
                url = @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSi8MYn94Vl1HVxqMb7u31QSRa3cNCJOYhxw7xI_GGDvcSKQ7xwPA370w";
            }
            NSURL *imageURL = [NSURL URLWithString:url];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            UIImage *myImage = [UIImage imageWithData:imageData];
            [_soundCloudAlbumImages addObject:myImage];
            [_soundCloudResultsTableView performSelectorOnMainThread:@selector(reloadData)
                                                          withObject:nil
                                                       waitUntilDone:NO];
        }
        
    });
    
}



-(void)searchSoundcloud:(NSString*)search_text
{
    //SWITCH switch from _old_list to search
    
//    [self changeSelectedListWithString:@"search" from:_current_media_picker_type];
//    
//    [SoundCloudAPI searchSoundCloud:search_text withSender:self];
//    //    [self viewDidLoad];
//    [self viewWillAppear:YES];
}

-(void)updateTable
{
    //    self.selectedTracks = [[NSMutableArray alloc] init];
    //    self.selectedTrackIndices = [[NSMutableArray alloc] init];
    [self.soundCloudResultsTableView reloadData];
    self.soundCloudAlbumImages = [[NSMutableArray alloc] init];
    [self getAlbumImageArray];
    
}

//-(IBAction)getFaves
//{
//    //SWITCH switch from old_list to favorites
//    [self changeSelectedListWithString:@"favorites" from:_current_media_picker_type];
//    
//    [SoundCloudAPI getFavorites:self];
//}

-(IBAction)getSDSEventTracks
{
    //SWITCH switch from old_list to sds_mixes
    [self changeSelectedListWithString:@"sds_mixes" from:_current_media_picker_type];
    
    [SoundCloudAPI getSDSPlaylistsFromSoundCloud:self];
}

- (IBAction)addSongsAction:(id)sender {
    
    if(self.selectedTracks.count == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Tracks Selected"
                                                        message:@"Select a track or hit Cancel to browse other Channels"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:@"Cancel", nil];
        [alert show];
        return;
    }

    [Ecstatic addSongsToQueue:self.selectedTracks];
    
    //create room with channel title set by user:
    [Ecstatic createRoom:_channel_title_textfield.text];

    [self performSegueWithIdentifier:@"mediaPickerToPlayer" sender:self];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //
    }
    else if (buttonIndex == 1) {
        [self performSegueWithIdentifier:@"mediaPickerToExplore" sender:self];
    }
}


@end
