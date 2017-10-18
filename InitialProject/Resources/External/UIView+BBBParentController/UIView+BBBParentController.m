//
//  UIView+BBBParentController.m
//  q9elements.mobile
//
//  Created by volodymyrkhmil on 3/20/17.
//  Copyright © 2017 TechMagic. All rights reserved.
//

#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

#import "UIView+BBBParentController.h"


@implementation UIView (BBBParentController)

@dynamic BBB_parentController;

- (UIViewController*)BBB_parentController {
    UIResponder *responder = self;
    while ([responder isKindOfClass:[UIView class]])
        responder = [responder nextResponder];
    return (UIViewController *)responder;
}

@end
