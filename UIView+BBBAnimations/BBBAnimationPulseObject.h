//
//  BBBAnimationPulseObject.h
//  Sqord
//
//  Created by volodymyrkhmil on 3/17/16.
//  Copyright © 2016 Sqord. All rights reserved.
//

#import "BBBAnimation.h"

@interface BBBAnimationPulseObject : BBBAnimation

@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) BOOL revert;
@property (nonatomic, assign) NSUInteger repeats;

@end
