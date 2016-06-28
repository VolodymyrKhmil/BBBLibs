#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

#import "BBBUndoManager.h"
#import "BBBUndoAction.h"
#import <objc/runtime.h>

@interface BBBUndoAction(BBBUndoActionProperties)

@property (nonatomic, strong) BBBUndoAction * _Nullable BBB_previousAction;
@property (nonatomic, strong) BBBUndoAction * _Nullable BBB_nextAction;

@end

@implementation BBBUndoAction(BBBUndoActionProperties)

@dynamic BBB_previousAction;
@dynamic BBB_nextAction;

- (void)setBBB_nextAction:(BBBUndoAction *)BBB_nextAction {
    objc_setAssociatedObject(self,   @selector(BBB_nextAction), BBB_nextAction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setBBB_previousAction:(BBBUndoAction *)BBB_previousAction {
    objc_setAssociatedObject(self,   @selector(BBB_previousAction), BBB_previousAction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BBBUndoAction*)BBB_nextAction {
    return objc_getAssociatedObject(self, @selector(BBB_nextAction));
}

- (BBBUndoAction*)BBB_previousAction {
    return objc_getAssociatedObject(self, @selector(BBB_previousAction));
}

@end

@interface BBBUndoManager()

@property (nonatomic, strong) NSMutableDictionary<NSString*, BBBUndoAction*>  * _Nonnull actions;

@end

@implementation BBBUndoManager

#pragma mark - Initializers

- (instancetype)init {
    self = [super init];
    
    if (self != nil) {
        _actions = [NSMutableDictionary new];
    }
    
    return self;
}

#pragma mark - Public

+ (instancetype)sharedManager {
    static BBBUndoManager *instance = nil;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        instance = [BBBUndoManager new];
    });
    
    return instance;
}

- (void)addAction:(nonnull BBBUndoAction*)action forKey:(nonnull NSString*)key {
    BBBUndoAction *currentAction = self.actions[key];
    action.BBB_previousAction = currentAction;
    currentAction.BBB_nextAction = action;
    self.actions[key] = action;
}

- (nullable BBBUndoAction*)actionForKey:(nonnull NSString*)key {
    return self.actions[key];
}

- (void)removeActionForKey:(nonnull NSString*)key {
    [self.actions removeObjectForKey:key];
}

- (nullable BBBUndoAction*)performAction:(nonnull BBBUndoAction*)action {
    [action perform];
    return action.BBB_nextAction;
}

- (nullable BBBUndoAction*)undoAction:(nonnull BBBUndoAction*)action {
    [action undo];
    return action.BBB_previousAction;
}

@end
