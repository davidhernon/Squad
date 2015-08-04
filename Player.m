
//
//  Player.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-12.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "Player.h"
#import "Playlist.h"


@implementation Player

static Player *ecstaticPlayer = nil;
//static AVPlayer *avPlayer = nil;

-(id)init{
    self=[super init];
    if(self){
        //Do custom init work
        [self updatePlaylist];
    }
    return  self;
}

/**
 Singleton Constructor for creating a single Player Object for the client
 Example usage:
 @code
 Player* player = [Player sharedPlayer];
 @endcode
 @return Player* for the singleton player, either a new one or the already created one.
 */
+ (Player*)sharedPlayer
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ecstaticPlayer = [[Player alloc] init];
        ecstaticPlayer.avPlayer = [[AVPlayer alloc] init];
        ecstaticPlayer.currentTrackIndex = 0;
        ecstaticPlayer.player_is_paused = NO;
        ecstaticPlayer.isNextSong = NO;
        ecstaticPlayer.user_joining_room = NO;
		ecstaticPlayer.user_hit_button = NO;
		ecstaticPlayer.player_is_locked = NO;
    });
    return ecstaticPlayer;
}

- (void) resetPlayer
{
    [[Player sharedPlayer] joinRoom:0 withElapsedTime:0.0f andIsPlaying:0 isLocked:false];
    _currentTrack = nil;
    [[Playlist sharedPlaylist] resetPlaylist];
    [self updatePlaylist];
    
    [[Playlist sharedPlaylist] reloadPlayer];
//    [SDSAPI getPlayerState:[Room currentRoom].room_number];
//    [self reloadUI];
//    [self play];
}

/**
the delegate to Player for Player to communicate with a view controller
 Example usage:
 @code
 [player addDelegate:self];
 @endcode
 @param (id) sender
 Usually called with the PlayerViewController to set up a delegate relation between the two
 @return void
 */
- (void) addDelegate:(id)sender
{
    _delegate = sender;
}

/**
 updates the playlist in the Player form the singleton Playlist object. also updates the delegate playlistTableView
 Example usage:
 @code
 [player updatePlaylist];
 @endcode
 @return (void)
 */
-(void) updatePlaylist
{
    ecstaticPlayer.playlist = [Playlist sharedPlaylist];
//    [_delegate updatePlaylistTable];
}

/**
 Method for playing or pausing and controlling which currentTrack is playing. Needs refactoring.
 Example usage:
 @code
 [[Player sharedPlayer] play];
 @endcode
 @return void
 */
-(void)play
{
    if([self playerNotPlayingAudioOrCurrentUserJoiningRoom])
    {
        if([self thereDoesntExistACurrentTrack])
        {
            [self playlistExistsAndIndexIsLessThanPlaylistLength];
            
        // else there is a current track and the player is just paused
        }else{
            //This hits when song makes it to the end, then a new song is added and user hits play or hits when User hits play after a pause
            [self playSignalFromUserOrPlayer];
            return;
        }
        
    // audio is not playing check if we are not paused
    }else if(!_player_is_paused){
        [self pauseSignalFromUserOrPlayer];
        return;
    // audio is not playing but we are not paused
    }else{
        [self setupAudioForPlayAfterPause];
        return;
    }
    
    [self callNextSong];
    [_avPlayer play];
    
}

- (void)updatePlayerStateAndUIWithNewSong
{
    [_delegate initPlayerUI:(1.0f*CMTimeGetSeconds(_avPlayer.currentItem.asset.duration)) withTrack:_currentTrack atIndex:_currentTrackIndex];
    _progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    _player_is_paused = NO;
}

-(void)callNextSong
{
//	Mixpanel *mixpanel = [Mixpanel sharedInstance];
//	[mixpanel track:@"played_song"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@?client_id=%@", _currentTrack.stream_url,[SoundCloudAPI getClientID]];//Your client ID
   
    if(!_currentTrack.is_local_item){
//        [_delegate clearDownloadFinishedUI];
    }
    NSURL *url;
//    if(_currentTrack.is_event_mix && _currentTrack.is_local_item)
    if(_currentTrack.is_local_item)
    {
        url = [NSURL fileURLWithPath:_currentTrack.local_file_path];
        //load the url into an asset and init the avplayer with it
        AVAsset *asset = [AVAsset assetWithURL:url];
        NSArray *metadata = [asset commonMetadata];
        AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
        _avPlayer = [AVPlayer playerWithPlayerItem:item];

    }else{
        url = [NSURL URLWithString:urlString];
        _avPlayer = [AVPlayer playerWithURL:url];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioPlayerDidFinishPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:[_avPlayer currentItem]];
    [self updatePlayerStateAndUIWithNewSong];
}

/**
 Calls the delegate to update the UISlider from the current time in the player
 Example usage:
 @code
 [self updateTime];
 [[Player sharedPlayer] updateTime];
 @endcode
 @return void
 */
-(void)updateTime
{
    [_delegate setCurrentSliderValue:_avPlayer];
//    [_delegate playerIsDoneLoadingNextSong];
}

/**
 Calls inside the updateTime selector to control functionality at the end of a song playing
 Example usage:
 @code
 Called in a callback when the song ends
 @endcode
 @param player
        AVAudioPlayer that was playing the song
        flag
        Boolean that indicates if the song played successfully or not
 @return (id) of the newly created MediaItem
 */
- (void)audioPlayerDidFinishPlaying
{
    
    if(_currentTrackIndex == [[Playlist sharedPlaylist] count] - 1)
    {
        _currentTrack = nil;
        [self updatePlaylist];
        return;
    }
    [self.progressTimer invalidate];
    self.progressTimer = nil;
    _currentTrack = nil;
    [ecstaticPlayer updatePlaylist];
    _currentTrackIndex++;
    _currentTrack = [_playlist objectAtIndex:_currentTrackIndex];
    [self updatePlaylist];
    [self callNextSong];
}

/**
 Does not seek while player is not playing
 Changes the currentTime value to the correct point as dictated by the UISlider
 Example usage:
 @code
 [[Player sharedPlayer] seek:slider.value]
 @endcode
 @param value
        Float variable indicating how for through the song you are. Usually set from a UISlider in PlayerViewController
 @return void
 */
-(void)seek:(float)value
{
    if(_avPlayer.rate != 0)
    {
//        [_avPlayer seekToTime:CMTimeMake(value, 1000)];
        [_avPlayer seekToTime:CMTimeMake(value, 1000) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    }
}

-(void) pause
{
    [_avPlayer pause];
}

-(void)next
{
    _avPlayer.rate = 0;
    [self audioPlayerDidFinishPlaying];
}

-(void)last
{
    if(CMTimeGetSeconds([_avPlayer currentTime]) <= 10.0f)
    {
        if(!_currentTrackIndex == 0)
        {
            _currentTrackIndex--;
            _currentTrack = nil;
            [self updatePlaylist];
            [self pause];
            _player_is_paused = YES;
            [self play];
            return;
        }
    }
    
    [_avPlayer seekToTime:CMTimeMake(0.0,1.0)];
    
}

-(BOOL)isPlaying
{
    if(_avPlayer.rate == 0 || _player_is_paused)
    {
        return NO;
    }else{
        return YES;
    }
}

-(void)hidePlayerUIWhenPlaylistIsFinished
{
//    [_delegate hideUI];
}

-(void) reloadUI
{
    [_delegate redrawUI];
}

- (void) joinRoom:(NSDictionary*)channel
{
    NSDictionary *player_state = [channel objectForKey:@"player_state"];
    [[Playlist sharedPlaylist] initWithArray:[player_state objectForKey:@"playlist"]];
    
    NSNumber *current_time_from_server = (NSNumber*)[channel objectForKey:@"current_time"];
    NSNumber *elapsed_time = [NSNumber numberWithInt:[[player_state objectForKey:@"elapsed"] intValue]];
    NSNumber *server_timestamp = (NSNumber*)[player_state objectForKey:@"timestamp"];
    
    int song_index = [[player_state objectForKey:@"playing_song_index"] intValue];
    int is_playing = [[player_state objectForKey:@"is_playing"] intValue];
    BOOL playing = (BOOL)[player_state objectForKey:@"is_playing"];
//    BOOL isLocked = [[player_state objectForKey:@"is_locked"] intValue];
    
    //convert into floats
    double ctfs = [current_time_from_server doubleValue];
    double st = [server_timestamp doubleValue];
    double et = [elapsed_time doubleValue];
    double el;
    
    //if it was paused while player_state sitting on server
    if(is_playing == 0){
        el = (double)(1000.0*et);
    }
    //if it was playing while player_state sat on server
    else{
        el = ctfs - st + (double)(1.0*et);
    }
    
    [self joinRoom:song_index withElapsedTime:el andIsPlaying:playing isLocked:YES];
}

//Sets up the player (elapsed time is in milli)
- (void) joinRoom:(int)index withElapsedTime:(double)elapsed andIsPlaying:(BOOL)is_playing isLocked:(BOOL)isLocked
{
	//if the player is empty or the playlist is empty, return
    if([Playlist sharedPlaylist].playlist.count == 0){
        if([self isPlaying]){
            [self pause];
        }
        _currentTrack = nil;
        _currentTrackIndex = 0;
        return;
    }
    _currentTrack = [[Playlist sharedPlaylist].playlist objectAtIndex:index];
    _currentTrackIndex = index;
    [self callNextSong];
    [self seek:(elapsed)];
    [_delegate setCurrentSliderValue:_avPlayer];
    [self reloadUI];
    _user_joining_room = YES;
	if(is_playing){
//		[self play];
        [_avPlayer play];
        [self seek:(elapsed)];
	}
	else{
		[self pause];
	}
    
}

-(BOOL)playerNotPlayingAudioOrCurrentUserJoiningRoom
{
    if(_avPlayer.rate == 0 || _user_joining_room)
    {
        _user_joining_room = NO;
        return true;
    }else{
        return false;
    }
}

-(BOOL)thereDoesntExistACurrentTrack
{
    return !_currentTrack;
}

-(BOOL)playlistExistsAndIndexIsLessThanPlaylistLength
{
   if( [_playlist count] > 0 && _currentTrackIndex < [_playlist count])
   {
       _currentTrack = [_playlist objectAtIndex:_currentTrackIndex];
       [self updatePlaylist];
       return true;
   }else{
       _avPlayer.rate = 0.0;
       return false;
   }
}

-(void)wasPlayPauseHitByUser:(BOOL)play
{
    if(_user_hit_button){
        [self userHitPlayPauseButtonForPlay:play];
    }
}

-(void)userHitPlayPauseButtonForPlay:(BOOL)play
{
    if(play)
    {
        _user_hit_button = NO;
		[SDSAPI realtimePlayer:@"play"];
    }else{
        _user_hit_button = NO;
		[SDSAPI realtimePlayer:@"pause"];
    }
}

-(void)userDidPause
{
//    [_delegate showPlayButton];
    [_avPlayer pause];
    _player_is_paused = YES;
}

-(void)userDidPlay
{
    [_avPlayer play];
    _player_is_paused = NO;
//    [_delegate showPauseButton];
}

-(void)playSignalFromUserOrPlayer
{
	[self userDidPlay];
    [self wasPlayPauseHitByUser:true];
}

-(void)pauseSignalFromUserOrPlayer
{
	[self userDidPause];
    [self wasPlayPauseHitByUser:false];
}

-(void)setupAudioForPlayAfterPause
{
    [_avPlayer play];
    _player_is_paused = NO;
}

-(void)setLock:(BOOL)player_is_locked{
	self.player_is_locked = player_is_locked;
//    if(player_is_locked)
//        [_delegate lock];
//    else
//        [_delegate unlock];
}

-(void) deleteSongWithDict:(NSDictionary*)remove_song_dict
{
    
}

@end
