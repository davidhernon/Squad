//
//  SoundCloudAPI.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-28.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicServiceAPI.h"
#import <UIKit/UIKit.h>
#import "MediaItem.h"
#import "SCUI.h"
#import "MediaPickerViewController.h"
@class soundCloudMediaPickerViewController;
//@class EventView;

@interface SoundCloudAPI : NSObject<MusicServiceAPI>


//+(NSArray*)searchSC;
+(void)getFavorites:(soundCloudMediaPickerViewController*)sender;
+ (void)getAccessTokenWithCompletion;
+ (void)storeUserDefaults;
+ (NSString*)getClientID;
+ (void)login:(id)sender;
+(void)searchSoundCloud:(NSString*)search_text withSender:(soundCloudMediaPickerViewController*)sender;
+(void)getSDSPlaylistsFromSoundCloud:(soundCloudMediaPickerViewController*)sender;
+(void)getSoundCloudTrackFromURL:(NSString*)string_url;
//+(void)getSoundCloudTrackFromURL:(NSString*)string_url fromSender:(EventView*)sender;
+(void)getSoundCloudTrackFromURL:(NSNumber*)sc_id fromMediaItem:(MediaItem*)sender;
@end
