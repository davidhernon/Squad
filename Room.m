//
//  Room.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-05-07.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "Room.h"

@implementation Room

static Room *currentRoom = nil;


// dummy init
-(id)init
{
    self = [super init];
    if(self)
    {
        //initialize
    }
    return self;
}

//singleton initializer
+ (Room*)currentRoom
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MWLogDebug(@"Rooms - Room - currentRoom - initializing new singleton Room");
        currentRoom = [[Room alloc] init];
        currentRoom.room_number = @"0";
        currentRoom.is_owner = YES;
        currentRoom.title.text = [NSString stringWithFormat:@"%@'s Room", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"] ];
        currentRoom.host_username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        currentRoom.is_event = NO;
    });
    return currentRoom;
}

// make current user the owner of the room
- (void) makeOwner
{
    MWLogDebug(@"Rooms - Room - makeOwner - setting client as Room owner");
    currentRoom.is_owner = YES;
}

// make current user
- (void) makeNotOwner
{
    MWLogDebug(@"Rooms - Room - makeNowOwner - removing client as room owner");
    currentRoom.is_owner = NO;
}

// init with dict from django portion of site
- (void) initWithDict:(NSDictionary *)channel
{
//    MWLogDebug(@"Rooms - Room - initWithDict: - initializing room with a dict");
//    if(!currentRoom)
//        [Room currentRoom];
//    currentRoom.title.text = [room_info objectForKey:@"room_name"];
//    currentRoom.room_number = [room_info objectForKey:@"room_number"];
//    currentRoom.host_username = [room_info objectForKey:@"host_username"];
//    currentRoom.other_listeners = [room_info objectForKey:@"number_of_users"];
//	NSString* usr = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
//	if([usr isEqualToString:currentRoom.host_username]){
//		[self makeOwner];
//	}
//    NSLog(@"room number: %@", currentRoom.room_number);
//    NSDictionary *player_state = [[Ecstatic getSocketInfoAsDict:[channel objectForKey:@"socket_info"]] objectForKey:@"player_state"];
    currentRoom.room_name = [channel objectForKey:@"room_name"];
}

/**
 Function returns the number of other listeners in the current room
 */
-(int)getNumberOfListenersInRoom
{
    MWLogDebug(@"Rooms - Room - getNumberOfListenersInRoom - dummy method called, always returns 0");
    return [currentRoom.other_listeners intValue];
}

@end
