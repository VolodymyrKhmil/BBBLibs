
#import <Foundation/Foundation.h>

typedef void (^BBBActionBlock)(void);
typedef void (^BBBUndoBlock)(void);

@interface BBBUndoAction : NSObject

- (nullable instancetype)initWithAction:(nonnull BBBActionBlock)action undo:(nonnull BBBUndoBlock)undo;

- (void)perform;
- (void)undo;

@end
