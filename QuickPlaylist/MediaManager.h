//
//  MediaManager.h
//  QuickPlaylist
//
//  Created by Kelby on 3/28/14.
//  Copyright (c) 2014 Kelby Green. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MediaPlayer/MediaPlayer.h>

@interface MediaManager : NSObject

+(MediaManager *)shared;
-(NSMutableArray *)getRandomSongs:(int)n;
-(void)addSongToPlaylist:(MPMediaItem *)song;
-(void)removeSongFromPlaylist:(MPMediaItem *)song;
-(NSArray *)getPlaylist;
-(void)clearPlaylist;
-(void)moveIndex:(int)startIndex toIndex:(int)endIndex;

@end
