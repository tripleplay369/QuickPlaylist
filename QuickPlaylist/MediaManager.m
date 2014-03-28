//
//  MediaManager.m
//  QuickPlaylist
//
//  Created by Kelby on 3/28/14.
//  Copyright (c) 2014 Kelby Green. All rights reserved.
//

#import "MediaManager.h"

@interface MediaManager()

@property NSArray * allSongs;
@property NSMutableArray * playlist;

@end

@implementation MediaManager

@synthesize allSongs;
@synthesize playlist;

static MediaManager * shared_p = nil;

-(MediaManager *)init
{
    self = [super init];
    if(self){
        [self clearPlaylist];
    }
    return self;
}

+(MediaManager *)shared
{
    if(!shared_p){
        shared_p = [[MediaManager alloc] init];
    }
    
    return shared_p;
}

-(void)clearPlaylist
{
    playlist = [NSMutableArray array];
}

-(MPMediaItem *)getRandomSong
{
    if(!allSongs){
        MPMediaQuery * everything = [[MPMediaQuery alloc] init];
        MPMediaPropertyPredicate * predicate = [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInteger:MPMediaTypeMusic] forProperty:MPMediaItemPropertyMediaType];
        [everything addFilterPredicate:predicate];

        allSongs = [everything items];
    }
    
#warning doesn't work with no songs in library
    int trackNumber = arc4random() % [allSongs count];
    return [allSongs objectAtIndex:trackNumber];
}

-(void)addSongToPlaylist:(MPMediaItem *)song
{
    [playlist addObject:song];
}

-(void)removeSongFromPlaylist:(MPMediaItem *)song
{
    [playlist removeObject:song];
}

-(NSArray *)getPlaylist
{
    return playlist;
}

-(void)moveIndex:(int)startIndex toIndex:(int)endIndex
{
    MPMediaItem * song = [playlist objectAtIndex:startIndex];
    [playlist removeObjectAtIndex:startIndex];
    [playlist insertObject:song atIndex:endIndex];
}

@end
