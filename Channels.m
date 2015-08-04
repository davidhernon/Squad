//
//  Channels.m
//  Ecstatic
//
//  Created by David Hernon on 2015-07-31.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "Channels.h"
#import "ExploreViewController.h"

@implementation Channels

static Channels *channels = nil;

+ (Channels*)currentChannels
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        channels = [[Channels alloc] init];
        channels.channelArray = [[NSArray alloc] init];
    });
    return channels;
}

- (void) addDelegate:(ExploreViewController*)sender
{
    channels.delegate = sender;
}

- (void) setChannels:(NSArray *)channelArray
{
    channels.channelArray = channelArray;
    [_delegate ack];
    [_delegate.rooms_table_view reloadData];
}


@end
