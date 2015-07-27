//
//  MediaItemTableViewCell.h
//  Ecstatic
//
//  Created by David Hernon on 2015-07-27.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaItemTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *track_title;
@property (weak, nonatomic) IBOutlet UILabel *artist;

@end
