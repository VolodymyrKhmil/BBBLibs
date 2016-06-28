
#import <Foundation/Foundation.h>

@class BBBUndoAction;

@interface BBBUndoManager : NSObject

+ (nullable instancetype)sharedManager;
- (void)addAction:(nonnull BBBUndoAction*)action forKey:(nonnull NSString*)key;
- (nullable BBBUndoAction*)actionForKey:(nonnull NSString*)key;
- (void)removeActionForKey:(nonnull NSString*)key;

- (nullable BBBUndoAction*)performAction:(nonnull BBBUndoAction*)action;
- (nullable BBBUndoAction*)undoAction:(nonnull BBBUndoAction*)action;

@end
