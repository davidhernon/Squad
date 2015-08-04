//
//  RoomsAroundMeTableViewCell.h
//  Ecstatic
//
//  Created by David Hernon on 2015-07-20.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomsAroundMeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *channel_title;
@property (weak, nonatomic) NSDictionary *channel_info;

@end
