//
//  Ecstatic.m
//  Ecstatic
//
//  Created by David Hernon on 2015-07-20.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "Ecstatic.h"
#import "Ecstatic-Swift.h"
#import "MediaItem.h"

@implementation Ecstatic

static SocketIOClient *static_socket;
static NSArray *addSongQueue;

+ (void) initializeSocket
{
    addSongQueue = [[NSArray alloc] init];
    
    static_socket = [[SocketIOClient alloc] initWithSocketURL:@"http://19f5b3f8.ngrok.io" options:nil];
//    static_socket = [[SocketIOClient alloc] initWithSocketURL:@"http://davidhernon.local:8080" options:nil];
//    static_socket = [[SocketIOClient alloc] initWithSocketURL:@"http://localhost:8080" options:nil];

    
    [static_socket on: @"create_room" callback: ^(NSArray* data, void (^ack)(NSArray*)) {
        NSLog(@"");
        NSDictionary *channel = [data[0] objectForKey:@"player_state"];
        [[Room currentRoom ] initWithDict:channel];
        [Ecstatic addSongsFromQueue];
    }];
    
    [static_socket on: @"rooms" callback: ^(NSArray* data, void (^ack)(NSArray*)) {
        NSLog(@"");
        NSArray *channels = data[0];
        NSMutableArray *parsed_channels = [[NSMutableArray alloc] init];
        for(NSDictionary *channel in channels)
        {
            NSMutableDictionary *parsed_channel = [[NSMutableDictionary alloc] init];
            NSDictionary *player_state = [self getSocketInfoAsDict:[channel objectForKey:@"socket_info"]];
            NSDictionary *p_s = [player_state objectForKey:@"player_state"];
            [parsed_channel setValue:p_s forKey:@"player_state"];
            [parsed_channel setValue:[channel objectForKey:@"room_id"] forKey:@"room_id"];
            NSDictionary *users = [channel objectForKey:@"users"];
            [parsed_channel setValue:users forKey:@"users"];
            // current time is timestamp of the last server return
            [parsed_channel setValue:[channel objectForKey:@"current_time"] forKey:@"current_time"];
            
            [parsed_channels addObject:parsed_channel];
        }
        [[Channels currentChannels] setChannels:parsed_channels];
        
    }];
    
    [static_socket on: @"join_room" callback: ^(NSArray* data, void (^ack)(NSArray*)) {
        NSLog(@"");
    }];
    
    [static_socket on: @"users" callback: ^(NSArray* data, void (^ack)(NSArray*)) {
        NSLog(@"");
    }];
    
    [static_socket on: @"add_song" callback: ^(NSArray* data, void (^ack)(NSArray*)) {
        NSLog(@"");
        NSDictionary *song = ((NSDictionary*) data[0]);
        MediaItem *new_song = [[MediaItem alloc] initWIthDict:song];
        [[Playlist sharedPlaylist] addTrack:new_song];
        [[Playlist sharedPlaylist] reloadPlayer];
    }];
    
    [static_socket connect];
}

+ (void) createRoom:(NSString *)room_title
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        while(!static_socket.connected){
            [NSThread sleepForTimeInterval:0.1f];
        }
        
        NSDictionary * postDictionary = [NSDictionary dictionaryWithObjects:@[room_title] forKeys:@[@"room_name"]];
        
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:postDictionary options:NSJSONReadingMutableContainers error:nil];
        [static_socket emitObjc:@"create_room" withItems:@[jsonData]];
    });
}

+ (void) getRooms
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        while(!static_socket.connected){
            [NSThread sleepForTimeInterval:0.1f];
        }
        
        [static_socket emitObjc:@"rooms" withItems:nil];
    });
}

+ (void) join_room:(NSString*)room_id
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        while(!static_socket.connected){
            [NSThread sleepForTimeInterval:0.1f];
        }
        NSDictionary *room = [NSDictionary dictionaryWithObjects:@[room_id] forKeys:@[@"room_id"]];
        NSData *jsonDict = [NSJSONSerialization dataWithJSONObject:room
                                                           options:nil
                                                             error:nil];
        [static_socket emitObjc:@"join_room" withItems:@[jsonDict]];
        
    });
}

+ (void) users:(NSString*)room_id
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        while(!static_socket.connected){
            [NSThread sleepForTimeInterval:0.1f];
        }
        NSDictionary *room = [NSDictionary dictionaryWithObjects:@[room_id] forKeys:@[@"room_id"]];
        NSData *jsonDict = [NSJSONSerialization dataWithJSONObject:room
                                                           options:nil
                                                             error:nil];
        [static_socket emitObjc:@"join_room" withItems:@[jsonDict]];
        
    });
}

+ (void) addSong:(NSDictionary*)serializedMediaItem
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:serializedMediaItem
                                                       options:nil
                                                         error:&error];
    
    [static_socket emitObjc:@"add_song" withItems:@[jsonData]];
}

+ (void) addSongsToQueue:(NSArray*)songs
{
    addSongQueue = songs;
}

+ (void) addSongsFromQueue
{
    for(MediaItem* song in addSongQueue)
    {
        [Ecstatic addSong:[song serializeMediaItem]];
    }
}

+ (NSDictionary*) getSocketInfoAsDict:(NSString*)dict
{
    NSData *data = [dict dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"string:%@",dict);
    NSDictionary *socket_info_dict = [NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
    return socket_info_dict;
}

@end
