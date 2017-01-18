//
//  BBBAudioChunkPlayer.m
//  BonjourChat
//
//  Created by volodymyrkhmil on 11/28/16.
//  Copyright © 2016 Oliver Drobnik. All rights reserved.
//

#import "BBBAudioChunkPlayer.h"

#define kOutputBus 0
#define kInputBus 1

@interface BBBAudioChunkPlayer()

@property (nonatomic, assign, readwrite) AudioComponentInstance audioUnit;

@end

@implementation BBBAudioChunkPlayer

#pragma mark - Static

static id<BBBAudioStream> streamData;
static NSData *currentData;
static NSInteger dataIndex;

#pragma mark - Callbacks

static OSStatus playbackCallback(void *inRefCon,
                                 AudioUnitRenderActionFlags *ioActionFlags,
                                 const AudioTimeStamp *inTimeStamp,
                                 UInt32 inBusNumber,
                                 UInt32 inNumberFrames,
                                 AudioBufferList *ioData) {
    
    for (int i = 0 ; i < ioData->mNumberBuffers; i++){
        AudioBuffer buffer = ioData->mBuffers[i];
        unsigned char *frameBuffer = buffer.mData;
        unsigned char *bytePtr = NULL;
        NSUInteger bytesSize = 0;
        for (int j = 0; j < inNumberFrames*2; j++){
            unsigned char byte = 0b0;


            if (dataIndex + 1 < bytesSize) {
                ++dataIndex;
                byte = bytePtr[dataIndex];
            } else {
                currentData = [streamData nextChunk];
                dataIndex = 0;
                if (currentData != nil) {
                    bytePtr = (unsigned char *)[currentData bytes];
                    byte = bytePtr[dataIndex];
                    bytesSize = [currentData length] / sizeof(unsigned char);
                }
            }
            
            frameBuffer[j] = byte;
        }
    }
    return noErr;
}

static OSStatus recordingCallback(void *inRefCon,
                                  AudioUnitRenderActionFlags *ioActionFlags,
                                  const AudioTimeStamp *inTimeStamp,
                                  UInt32 inBusNumber,
                                  UInt32 inNumberFrames,
                                  AudioBufferList *ioData) {
    return noErr;
}

#pragma mark - Shared

+ (instancetype)sharedPlayer {
    static BBBAudioChunkPlayer *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [BBBAudioChunkPlayer new];
    });
    
    return instance;
}

#pragma mark - Public

- (BOOL)prepareWithStream:(nonnull id<BBBAudioStream>)stream {
    BOOL status = YES;
    
    [BBBAudioChunkPlayer setNewStream:stream];
    
    AudioComponentDescription audioDescription = [BBBAudioChunkPlayer audioDescription];
    AudioComponent inputComponent = [BBBAudioChunkPlayer inputComponentForDescription:audioDescription];
    
    status &= [BBBAudioChunkPlayer createAudioUnit:&_audioUnit forInput:inputComponent];
    
    AudioStreamBasicDescription streamDescription = [BBBAudioChunkPlayer streamDescription];
    if (self.record) {
        status &= [BBBAudioChunkPlayer setupRecordingForUnit:self.audioUnit withStreamDescription:streamDescription];
    }
    
    if (self.play) {
        status &= [BBBAudioChunkPlayer setupPlayForUnit:self.audioUnit withStreamDescription:streamDescription];
    }
    status &= [BBBAudioChunkPlayer initialiseUnit:self.audioUnit];
    
    return status;
}

- (BOOL)start {
    return [BBBAudioChunkPlayer checkStatus: AudioOutputUnitStart(self.audioUnit)];
}

- (BOOL)stop {
    return [BBBAudioChunkPlayer checkStatus: AudioOutputUnitStop(self.audioUnit)];
}

- (BOOL)finish {
    streamData = nil;
    currentData = nil;
    return [BBBAudioChunkPlayer checkStatus: AudioComponentInstanceDispose(self.audioUnit)];
}

#pragma mark - Private

+ (void)setNewStream:(nonnull id<BBBAudioStream>)stream {
    streamData = stream;
    currentData = nil;
    dataIndex = 0;
}

+ (AudioComponentDescription)audioDescription {
    AudioComponentDescription desc;
    desc.componentType          = kAudioUnitType_Output;
    desc.componentSubType       = kAudioUnitSubType_RemoteIO;
    desc.componentFlags         = 0;
    desc.componentFlagsMask     = 0;
    desc.componentManufacturer  = kAudioUnitManufacturer_Apple;
    
    return desc;
}

+ (AudioComponent)inputComponentForDescription:(AudioComponentDescription)description {
    return AudioComponentFindNext(NULL, &description);
}

+ (AudioStreamBasicDescription)streamDescription {
    AudioStreamBasicDescription description;
    
    description.mSampleRate			= 44100.00;
    description.mFormatID			= kAudioFormatLinearPCM;
    description.mFormatFlags		= kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    description.mFramesPerPacket	= 1;
    description.mChannelsPerFrame	= 1;
    description.mBitsPerChannel		= 16;
    description.mBytesPerPacket		= 2;
    description.mBytesPerFrame		= 2;
    
    return description;
}

+ (BOOL)createAudioUnit:(AudioComponentInstance*)unit forInput:(AudioComponent)input {
    return [BBBAudioChunkPlayer checkStatus: AudioComponentInstanceNew(input, unit)];
}

+ (BOOL)setupRecordingForUnit:(AudioComponentInstance)unit withStreamDescription:(AudioStreamBasicDescription)description {
    BOOL status = YES;
    UInt32 flag = 1;
    status &= [BBBAudioChunkPlayer checkStatus:AudioUnitSetProperty(unit,
                                                                    kAudioOutputUnitProperty_EnableIO,
                                                                    kAudioUnitScope_Input,
                                                                    kInputBus,
                                                                    &flag,
                                                                    sizeof(flag))];
    status &= [BBBAudioChunkPlayer checkStatus:AudioUnitSetProperty(unit,
                                                                    kAudioUnitProperty_StreamFormat,
                                                                    kAudioUnitScope_Output,
                                                                    kInputBus,
                                                                    &description,
                                                                    sizeof(description))];
    AURenderCallbackStruct callbackStruct;
    callbackStruct.inputProc = recordingCallback;
    status &= [BBBAudioChunkPlayer checkStatus:AudioUnitSetProperty(unit,
                                                                    kAudioOutputUnitProperty_SetInputCallback,
                                                                    kAudioUnitScope_Global,
                                                                    kInputBus,
                                                                    &callbackStruct,
                                                                    sizeof(callbackStruct))];
    
    return status;
}

+ (BOOL)setupPlayForUnit:(AudioComponentInstance)unit withStreamDescription:(AudioStreamBasicDescription)description {
    BOOL status = YES;
    UInt32 flag = 1;
    status &= [BBBAudioChunkPlayer checkStatus:AudioUnitSetProperty(unit,
                                                                    kAudioOutputUnitProperty_EnableIO,
                                                                    kAudioUnitScope_Output,
                                                                    kOutputBus,
                                                                    &flag,
                                                                    sizeof(flag))];
    status &= [BBBAudioChunkPlayer checkStatus:AudioUnitSetProperty(unit,
                                                                    kAudioUnitProperty_StreamFormat,
                                                                    kAudioUnitScope_Input,
                                                                    kOutputBus,
                                                                    &description,
                                                                    sizeof(description))];
    
    AURenderCallbackStruct callbackStruct;
    
    callbackStruct.inputProc = playbackCallback;
    status &= [BBBAudioChunkPlayer checkStatus:AudioUnitSetProperty(unit,
                                                                    kAudioUnitProperty_SetRenderCallback,
                                                                    kAudioUnitScope_Global,
                                                                    kOutputBus,
                                                                    &callbackStruct,
                                                                    sizeof(callbackStruct))];
    
    return status;
}
                                                                    
+ (BOOL)initialiseUnit:(AudioComponentInstance)unit {
    return [BBBAudioChunkPlayer checkStatus:AudioUnitInitialize(unit)];
}

+ (BOOL)checkStatus:(OSStatus)status {
    return status == noErr;
}

@end
