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
    _rooms_around_me = [[NSArray alloc] init];
    [SDSAPI aroundMe:@"" withID:self];
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
    return self.rooms_around_me.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    RoomsAroundMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rooms_around_me_cell_identifier];
    
    //if cell is nil we will have to deque it manually
    if (cell == nil){
        NSLog(@"Explore - ExploreViewController - cellForRowAtIndexPath - oh shit, cell was nil!");
    }
    
    return [[UITableViewCell alloc] init];
}

- (void)showRoomsAroundMe:(NSArray*)room_dictionaries
{
    _rooms_around_me = [[NSArray alloc] init];
    _rooms_around_me = room_dictionaries;
    [self viewWillAppear:YES];
}

- (IBAction)createChannel:(id)sender {
    [self performSegueWithIdentifier:@"exploreToMediaPicker" sender:self];
}



@end
