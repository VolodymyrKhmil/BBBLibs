//
//  BBBAnimationBounceObject.h
//  Sqord
//
//  Created by volodymyrkhmil on 3/17/16.
//  Copyright © 2016 Sqord. All rights reserved.
//

#import "BBBAnimation.h"

@interface BBBAnimationBounceObject : BBBAnimation

@property (nonatomic, assign) CGVector direction;
@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, assign) CGFloat material;

@end
