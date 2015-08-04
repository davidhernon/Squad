//
//  ExploreViewController.m
//  Ecstatic
//
//  Created by David Hernon on 2015-07-20.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "ExploreViewController.h"

@interface ExploreViewController ()

@end

@implementation ExploreViewController

static NSString *rooms_around_me_cell_identifier = @"room_around_me_table_view_cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [[Channels currentChannels] addDelegate:self];
    _rooms_around_me = [[NSArray alloc] init];
    
}

- (void) ack
{
    _rooms_around_me = [Channels currentChannels].channelArray;
    [_rooms_table_view reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:YES];
    //hide player button depending on if there is a current track
    if([Player sharedPlayer].currentTrack)
    {
        _player_button.hidden = NO;
    }else{
        _player_button.hidden = YES;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [Ecstatic getRooms];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)homeButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"exploreToHome" sender:self];
}
- (IBAction)playerButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"exploreToPlayer" sender:self];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Around Me";
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = 0;
    for(NSDictionary *channel in _rooms_around_me)
    {
        //if the channel player state exists - meaning a song was added by original user
        if([channel objectForKey:@"player_state"]){
            count++;
        }
    }
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RoomsAroundMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rooms_around_me_cell_identifier];
    
    //get channel for this cell
    NSDictionary *channel = [self getValidChannelFromIndex:(int)indexPath.row];
    NSString* room_id = [channel objectForKey:@"room_id"];
    
    //if cell is nil we will have to deque it manually
    if (cell == nil){
        NSLog(@"Explore - ExploreViewController - cellForRowAtIndexPath - oh shit, cell was nil!");
    }
    NSDictionary *player_state = [channel objectForKey:@"player_state"];
    cell.channel_title.text = [player_state objectForKey:@"room_name"];
    cell.channel_info = channel;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *channel = [self getValidChannelFromIndex:indexPath.row];
    [[Room currentRoom] initWithDict:[channel objectForKey:@"player_state"]];
    [[Player sharedPlayer] joinRoom:channel];
    [self performSegueWithIdentifier:@"exploreToPlayer" sender:self];
}

- (void)showRoomsAroundMe:(NSArray*)room_dictionaries
{
    _rooms_around_me = [[NSArray alloc] init];
    _rooms_around_me = room_dictionaries;
    [self viewWillAppear:YES];
}

- (IBAction)createChannel:(id)sender {
    [[Player sharedPlayer] resetPlayer];
    [self performSegueWithIdentifier:@"exploreToMediaPicker" sender:self];
}

- (NSDictionary*) getValidChannelFromIndex:(int)index
{
    NSDictionary *channel = [[NSDictionary alloc] init];
    
    int counter = 0;
    int target_index = 0;
    
    while(target_index <= index){
        NSDictionary *it_channel = [_rooms_around_me objectAtIndex:counter];
        //if channel player state exists
        if([it_channel objectForKey:@"player_state"]){
            channel = it_channel;
            target_index++;
        }
        counter++;
    }
    return channel;
}

@end
