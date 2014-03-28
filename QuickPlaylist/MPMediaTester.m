//
//  MPMediaTester.m
//  QuickPlaylist
//
//  Created by Kelby on 3/28/14.
//  Copyright (c) 2014 Kelby Green. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

#if TARGET_IPHONE_SIMULATOR

@implementation MPMediaItem

-(NSString *)valueForProperty:(NSString *)property
{
    int r = arc4random() % 100;
    
    if([property isEqualToString:MPMediaItemPropertyArtist]){
        return [NSString stringWithFormat:@"Test Artist %d", r];
    }
    else if([property isEqualToString:MPMediaItemPropertyTitle]){
        return [NSString stringWithFormat:@"Test Title %d", r];
    }
    return @"";
}

@end

@implementation MPMediaQuery

-(NSArray *)items
{
    return @[[[MPMediaItem alloc] init]];
}

@end

#endif
