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

-(NSMutableArray *)getRandomSongs:(int)n
{
    if(!allSongs){
        MPMediaQuery * everything = [[MPMediaQuery alloc] init];
        MPMediaPropertyPredicate * predicate = [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInteger:MPMediaTypeMusic] forProperty:MPMediaItemPropertyMediaType];
        [everything addFilterPredicate:predicate];
        predicate = [MPMediaPropertyPredicate predicateWithValue:@(NO) forProperty:MPMediaItemPropertyIsCloudItem];
        [everything addFilterPredicate:predicate];

        allSongs = [everything items];
    }
    
    NSMutableSet * songs = [NSMutableSet set];
    while(songs.count < n && songs.count < allSongs.count){
        int trackNumber = arc4random() % [allSongs count];
        MPMediaItem * song = [allSongs objectAtIndex:trackNumber];
        if(![songs containsObject:song]){
            [songs addObject:song];
        }
    }
    
    return [NSMutableArray arrayWithArray:[songs allObjects]];
}

-(void)addSongToPlaylist:(MPMediaItem *)song
{
    [playlist addObject:song];
}

-(void)removeSongFromPlaylist:(int)index;
{
    [playlist removeObjectAtIndex:index];
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
