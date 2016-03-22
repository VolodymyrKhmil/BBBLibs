#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

#import "UIView+BBB_Animations.h"
#import <objc/runtime.h>
#import "BBBAnimationBounceObject.h"
#import "BBBAnimationMoveObject.h"
#import "BBBAnimationPulseObject.h"

typedef void(^AnimationFinishedBlock)(void);

#pragma mark - Associated Object

@interface UIView (BBB_AnimationAssociatedObject)

@property (nonatomic, strong) id BBB_animationAssociatedObject;
@property (nonatomic, strong) UIDynamicAnimator *BBB_bounceAnimator;

@end

@implementation UIView (BBB_AnimationAssociatedObject)

@dynamic BBB_animationAssociatedObject;

- (void)setBBB_animationAssociatedObject:(id)object {
    objc_setAssociatedObject(self,   @selector(BBB_animationAssociatedObject), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)BBB_animationAssociatedObject {
    return objc_getAssociatedObject(self, @selector(BBB_animationAssociatedObject));
}

@dynamic BBB_bounceAnimator;

- (void)setBBB_bounceAnimator:(id)object {
    objc_setAssociatedObject(self,   @selector(BBB_bounceAnimator), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)BBB_bounceAnimator {
    return objc_getAssociatedObject(self, @selector(BBB_bounceAnimator));
}

@end

#pragma mark - Ctegory

@implementation UIView(BBBAnimations)

#pragma mark - Public

- (UIView*)BBB_moveFrom:(CGPoint)begin to:(CGPoint)end withDuration:(NSTimeInterval)duration withDelay:(NSTimeInterval)delay {
    
    BBBAnimationMoveObject *moveAnimation = [BBBAnimationMoveObject new];
    
    moveAnimation.from = begin;
    moveAnimation.to = end;
    moveAnimation.duration = duration;
    moveAnimation.delay = delay;
    
    [self BBB_addAnimation:moveAnimation];
    
    return self;
}

- (UIView*)BBB_pulseWithScale:(CGFloat)scale revert:(BOOL)revert repeats:(NSUInteger)repeats duration:(NSTimeInterval)duration withDelay:(NSTimeInterval)delay {
    
    BBBAnimationPulseObject *pulseAnimation = [BBBAnimationPulseObject new];
    
    pulseAnimation.scale = scale;
    pulseAnimation.revert = revert;
    pulseAnimation.repeats = repeats;
    pulseAnimation.duration = duration;
    pulseAnimation.delay = delay;
    
    [self BBB_addAnimation:pulseAnimation];
    
    return self;
}

- (UIView*)BBB_bounnceWithDirection:(CGVector)direction insets:(UIEdgeInsets)insets materialBounceValue:(CGFloat)material withDelay:(NSTimeInterval)delay {
    
    BBBAnimationBounceObject *bounceAnimation = [BBBAnimationBounceObject new];
    
    bounceAnimation.direction = direction;
    bounceAnimation.insets = insets;
    bounceAnimation.material = material;
    bounceAnimation.delay = delay;
    
    [self BBB_addAnimation:bounceAnimation];
    
    return self;
}

- (UIView*)BBB_animateInOrder:(BBBAnimationEndBlock)completion {
    NSMutableArray *animations = self.BBB_animationAssociatedObject;
    
    [self BBB_runInOrderAnimations:animations completion:completion];
    
    self.BBB_animationAssociatedObject = nil;
    
    return self;
}

- (UIView*)BBB_animateInParalel:(BBBAnimationEndBlock)completion {
    NSMutableArray *animations = self.BBB_animationAssociatedObject;
    
    self.BBB_animationAssociatedObject = nil;
    
    for (BBBAnimation *animation in animations) {
        [self BBB_runAnimation:animation completion:nil];
    }
    
    if (completion != nil) {
        completion();
    }
    
    return self;
}

#pragma amrk - Private

- (void)BBB_runInOrderAnimations:(NSMutableArray*)animations completion:(BBBAnimationEndBlock)completion {
    
    BBBAnimation *animation = animations.firstObject;
    
    [animations removeObject:animation];
    
    __weak UIView *weakSelf = self;
    
    if (animation != nil) {
        [self BBB_runAnimation:animation completion:^{
            [weakSelf BBB_runInOrderAnimations:animations completion:completion];
        }];
    } else if (completion != nil) {
        completion();
    }
    
}

- (void)BBB_addAnimation:(BBBAnimation*)animation {
    
    NSMutableArray *animations = self.BBB_animationAssociatedObject;
    if (animations == nil) {
        animations = [NSMutableArray new];
    }
    
    [animations addObject:animation];
    
    self.BBB_animationAssociatedObject = animations;
}

- (CGFloat)BBB_oponentScaleForScale:(CGFloat)scale {
    
    return 1 / scale;
    
}

#pragma mark - Private(Run Animation)

- (void)BBB_runAnimation:(BBBAnimation*)animation completion:(AnimationFinishedBlock)completion {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, animation.delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if ([animation isMemberOfClass:[BBBAnimationMoveObject class]]) {
            
            [self BBB_runMoveAnimation:(BBBAnimationMoveObject*)animation completion:completion];
            
        } else if ([animation isMemberOfClass:[BBBAnimationPulseObject class]]) {
            
            [self BBB_runPulseAnimation:(BBBAnimationPulseObject*)animation completion:completion];
            
        } else if ([animation isMemberOfClass:[BBBAnimationBounceObject class]]) {
            
            [self BBB_runBounceAnaimation:(BBBAnimationBounceObject*)animation completion:completion];
            
        }
    });
}

- (void)BBB_runMoveAnimation:(BBBAnimationMoveObject*)animation completion:(AnimationFinishedBlock)completion {
    
    CGRect beginingFrame = self.frame;
    beginingFrame.origin = animation.from;
    
    CGRect endFrame = self.frame;
    endFrame.origin = animation.to;
    
    self.frame = beginingFrame;
    
    __weak UIView *weakSelf = self;
    
    [UIView animateWithDuration:animation.duration animations:^{
        weakSelf.frame = endFrame;
    } completion:^(BOOL finished) {
        if (completion != nil) {
            completion();
        }
    }];
    
}

- (void)BBB_runPulseAnimation:(BBBAnimationPulseObject*)animation scaleHorizontal:(BOOL)horizontalScale completion:(AnimationFinishedBlock)completion {
    
    __weak UIView *weakSelf = self;
    if (animation.repeats > 0) {
        
        --animation.repeats;
        CGFloat horizontalScaleValue = horizontalScale ? animation.scale : [self BBB_oponentScaleForScale:animation.scale];
        CGFloat verticalScaleValue = horizontalScale ? [self BBB_oponentScaleForScale:animation.scale] : animation.scale;
        
        [UIView animateWithDuration:animation.duration animations:^{
            
            weakSelf.transform = CGAffineTransformMakeScale(horizontalScaleValue, verticalScaleValue);
            
        } completion:^(BOOL finished){
            
            [weakSelf BBB_runPulseAnimation:animation scaleHorizontal:!horizontalScale completion:completion];
            
        }];
        
    } else  {
        
        void (^runCompletion)() = ^{
            if (completion != nil) {
                
                completion();
                
            }
        };
        
        if (animation.revert) {
            [UIView animateWithDuration:animation.duration animations:^{
                
                weakSelf.transform = CGAffineTransformMakeScale(1, 1);
                
            } completion:^(BOOL finished) {
                
                runCompletion();
                
            }];
        } else {
            runCompletion();
        }
}

}

- (void)BBB_runPulseAnimation:(BBBAnimationPulseObject*)animation completion:(AnimationFinishedBlock)completion {
    
    [self BBB_runPulseAnimation:animation scaleHorizontal:YES completion:completion];
    
}

- (void)BBB_runBounceAnaimation:(BBBAnimationBounceObject*)animation completion:(AnimationFinishedBlock)completion {
    if (self.BBB_bounceAnimator.isRunning) {
        @throw @"Can't perform bounce animation until previous is ended";
    }
    
    if (self.superview == nil) {
        @throw @"Can't perform bounce animation if has no superview";
    }
    
    if (self.BBB_bounceAnimator == nil) {
        self.BBB_bounceAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.superview];
    }
    
    [self.BBB_bounceAnimator removeAllBehaviors];
    
    UIGravityBehavior* gravityBehavior =
    [[UIGravityBehavior alloc] initWithItems:@[self]];
    gravityBehavior.gravityDirection = animation.direction;
    [self.BBB_bounceAnimator addBehavior:gravityBehavior];
    
    UICollisionBehavior* collisionBehavior =
    [[UICollisionBehavior alloc] initWithItems:@[self]];
    [collisionBehavior setTranslatesReferenceBoundsIntoBoundaryWithInsets:animation.insets];
    [self.BBB_bounceAnimator addBehavior:collisionBehavior];
    
    UIDynamicItemBehavior *elasticityBehavior =
    [[UIDynamicItemBehavior alloc] initWithItems:@[self]];
    elasticityBehavior.elasticity = animation.material;
    [self.BBB_bounceAnimator addBehavior:elasticityBehavior];

}

@end
