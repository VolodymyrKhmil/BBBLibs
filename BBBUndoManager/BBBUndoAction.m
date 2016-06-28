#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

#import "BBBUndoAction.h"

@interface BBBUndoAction()

@property (nonatomic, strong) BBBActionBlock action;
@property (nonatomic, strong) BBBUndoBlock undoAction;

@end

@implementation BBBUndoAction

#pragma mark - Public

- (void)perform {
    if (self.action != nil) {
        self.action();
    }
}
- (void)undo {
    if (self.undoAction != nil) {
        self.undoAction();
    }
}

#pragma mark - Initializers

- (instancetype)initWithAction:(BBBActionBlock)action undo:(BBBUndoBlock)undo {
    self = [super init];
    
    if (self != nil) {
        _action = action;
        _undoAction = undo;
    }
    
    return self;
}

- (instancetype)init {
    @throw @"Initalize obkect using initWithAction:undo:";
}

@end
