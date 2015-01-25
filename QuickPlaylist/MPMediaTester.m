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

-(BOOL)isEqual:(id)object
{
    return object == self;
}

-(NSUInteger)hash
{
    return rand();
}

@end

@implementation MPMediaQuery

-(NSArray *)items
{
    NSMutableArray * arr = [NSMutableArray array];
    for(int i = 0; i < 1000; ++i){
        [arr addObject:[[MPMediaItem alloc] init]];
    }
    return arr;
}

-(void)addFilterPredicate:(MPMediaPredicate *)predicate
{}

@end

#endif
