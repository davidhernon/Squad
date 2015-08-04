//
//  Channels.h
//  Ecstatic
//
//  Created by David Hernon on 2015-07-31.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ExploreViewController;

@interface Channels : NSObject

@property (retain, nonatomic) NSArray* channelArray;
@property (retain, nonatomic) ExploreViewController *delegate;

+ (Channels*)currentChannels;
- (void) addDelegate:(ExploreViewController*)sender;
- (void) setChannels:(NSArray *)channelArray;


@end
