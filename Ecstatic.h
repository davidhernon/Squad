//
//  Ecstatic.h
//  Ecstatic
//
//  Created by David Hernon on 2015-07-20.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Channels.h"
#import "Playlist.h"
#import "Room.h"

@class MediaItem;
@class SocketIOClient;

@interface Ecstatic : NSObject

+ (void) initializeSocket;
+ (void) createRoom:(NSString *)room_title;
+ (void) getRooms;
+ (void) join_room:(NSString*)room_id;
+ (void) users:(NSString*)room_id;
+ (void) addSong:(NSDictionary*)serializedMediaItem;
+ (void) addSongsToQueue:(NSArray*)songs;
+ (void) addSongsFromQueue;
+ (NSDictionary*) getSocketInfoAsDict:(NSString*)dict;

@end
