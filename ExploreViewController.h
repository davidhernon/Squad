//
//  ExploreViewController.h
//  Ecstatic
//
//  Created by David Hernon on 2015-07-20.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomsAroundMeTableViewCell.h"
#import "Ecstatic.h"
#import "Player.h"

@interface ExploreViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *rooms_table_view;
@property (retain, nonatomic) NSArray* rooms_around_me;
@property (weak, nonatomic) IBOutlet UIButton *player_button;

- (void)showRoomsAroundMe:(NSArray*)room_dictionaries;

@end
