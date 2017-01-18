//
//  BBBAudioChunkPlayer.h
//  BonjourChat
//
//  Created by volodymyrkhmil on 11/28/16.
//  Copyright © 2016 Oliver Drobnik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol BBBAudioStream <NSObject>

- (nullable NSData*)nextChunk;

@end

@interface BBBAudioChunkPlayer : NSObject

+ (nonnull instancetype)sharedPlayer;

- (BOOL)prepareWithStream:(nonnull id<BBBAudioStream>)stream;
- (BOOL)start;
- (BOOL)stop;
- (BOOL)finish;

@property (nonatomic, assign, readonly, nullable) AudioComponentInstance audioUnit;
@property (nonatomic, assign) BOOL record;
@property (nonatomic, assign) BOOL play;

@end
