//
//  BBBSafeNavigationController.m
//  Sqord
//
//  Created by volodymyrkhmil on 9/5/16.
//  Copyright © 2016 TechMagic. All rights reserved.
//

#import "BBBSafeNavigationController.h"
#import <objc/runtime.h>

@interface UINavigationController(BBBProperties)

@property (nonatomic, assign) BOOL BBB_shouldShowViewController;

@end

@implementation UINavigationController(BBBProperties)

@dynamic BBB_shouldShowViewController;

- (void)setBBB_shouldShowViewController:(BOOL)BBB_shouldShowViewController {
    objc_setAssociatedObject(self,   @selector(BBB_shouldShowViewController), @(BBB_shouldShowViewController), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)BBB_shouldShowViewController {
    return [objc_getAssociatedObject(self, @selector(BBB_shouldShowViewController)) boolValue];
}

@end

@interface UINavigationController (BBBPrivateAPI)

- (void)didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end

@implementation UINavigationController (BBBSafeNavigationController)

#pragma mark - Replacement

- (void)BBB_safePushViewController:(UIViewController*)controller animated:(BOOL)animated {
    if (!self.BBB_shouldShowViewController)
    {
        [self BBB_safePushViewController:controller animated:animated];
    }
    
    self.BBB_shouldShowViewController = YES;
}

-(void)BBB_didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self BBB_didShowViewController:viewController animated:animated];
    self.BBB_shouldShowViewController = NO;
}

#pragma mark - Override

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(pushViewController:animated:)), class_getInstanceMethod(self, @selector(BBB_safePushViewController:animated:)));
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(didShowViewController:animated:)), class_getInstanceMethod(self, @selector(BBB_didShowViewController:animated:)));
    });
}

@end
