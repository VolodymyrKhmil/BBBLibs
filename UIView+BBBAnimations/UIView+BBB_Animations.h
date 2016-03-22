//
//  UIView+Animations.h
//  Sqord
//
//  Created by volodymyrkhmil on 3/17/16.
//  Copyright © 2016 Sqord. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BBBAnimationEndBlock)(void);

@interface UIView(BBBAnimations)

- (UIView*)BBB_moveFrom:(CGPoint)begin to:(CGPoint)end withDuration:(NSTimeInterval)duration withDelay:(NSTimeInterval)delay;
- (UIView*)BBB_pulseWithScale:(CGFloat)scale revert:(BOOL)revert repeats:(NSUInteger)repeats duration:(NSTimeInterval)duration withDelay:(NSTimeInterval)delay;
- (UIView*)BBB_bounnceWithDirection:(CGVector)direction insets:(UIEdgeInsets)insets materialBounceValue:(CGFloat)material withDelay:(NSTimeInterval)delay;

- (UIView*)BBB_animateInOrder:(BBBAnimationEndBlock)completion;
- (UIView*)BBB_animateInParalel:(BBBAnimationEndBlock)completion;

@end
