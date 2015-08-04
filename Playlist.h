//
//  Playlist.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-25.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MediaItem.h"
#import "PlaylistDelegate.h"
@class Player;

@interface Playlist : NSObject

@property (nonatomic, weak) id<PlaylistDelegate> delegate;

@property NSMutableArray* playlist;
+ (Playlist*) sharedPlaylist;
-(NSUInteger)count;
- (void) addTrack:(MediaItem *)song;
- (void) addTracks:(NSMutableArray*)songsToAdd;
- (id)objectAtIndex:(NSUInteger)index;
-(void) removeTrack:(MediaItem*)song;
- (void) initWithDict:(NSDictionary*)playlist;
- (void) reloadPlayer;
-(void) clearPlaylist;
- (void) removeLocalSongById:(NSString*)track_id;
-(void)resetPlaylist;
- (void) initWithArray:(NSArray*)playlist;

@end
