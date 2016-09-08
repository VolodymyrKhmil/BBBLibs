//
//  BBBSafeNavigationController.m
//  Sqord
//
//  Created by volodymyrkhmil on 9/5/16.
//  Copyright © 2016 TechMagic. All rights reserved.
//

#import "BBBSafeNavigationController.h"
#import <objc/runtime.h>

#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

@interface UIViewController(BBBAnimationProperty)

@property (nonatomic, assign) BOOL BBB_shouldShowAnimated;

@end

@implementation UIViewController(BBBAnimationProperty)

@dynamic BBB_shouldShowAnimated;

- (void)setBBB_shouldShowAnimated:(BOOL)BBB_shouldShowAnimated {
    objc_setAssociatedObject(self,   @selector(BBB_shouldShowAnimated), @(BBB_shouldShowAnimated), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)BBB_shouldShowAnimated {
    return [objc_getAssociatedObject(self, @selector(BBB_shouldShowAnimated)) boolValue];
}

@end

@interface UINavigationController(BBBProperties)

@property (nonatomic, assign) BOOL BBB_shouldShowViewController;
@property (nonatomic, weak, readonly) NSMutableArray<UIViewController*> *BBB_controllers;

@end

@implementation UINavigationController(BBBProperties)

@dynamic BBB_shouldShowViewController;
@dynamic BBB_controllers;

- (void)setBBB_shouldShowViewController:(BOOL)BBB_shouldShowViewController {
    objc_setAssociatedObject(self,   @selector(BBB_shouldShowViewController), @(BBB_shouldShowViewController), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)BBB_shouldShowViewController {
    return [objc_getAssociatedObject(self, @selector(BBB_shouldShowViewController)) boolValue];
}

- (NSMutableArray<UIViewController*> *)BBB_controllers {
    NSMutableArray<UIViewController*> *controllers = objc_getAssociatedObject(self, @selector(BBB_controllers));
    if (controllers == nil) {
        controllers = [NSMutableArray new];
        objc_setAssociatedObject(self,   @selector(BBB_controllers), controllers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return controllers;
}

@end

@interface UINavigationController (BBBPrivateAPI)

- (void)didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end

@implementation UINavigationController (BBBSafeNavigationController)

#pragma mark - Replacement

- (void)BBB_safePushViewController:(UIViewController*)controller animated:(BOOL)animated {
    if (![self.BBB_controllers containsObject:controller]) {
        [self.BBB_controllers addObject:controller];
        controller.BBB_shouldShowAnimated = animated;
    }
    
    if (!self.BBB_shouldShowViewController) {
        self.BBB_shouldShowViewController = YES;
        [self BBB_safePushViewController:controller animated:animated];
    }
}

-(void)BBB_didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self BBB_didShowViewController:viewController animated:animated];
    self.BBB_shouldShowViewController = NO;
    [self.BBB_controllers removeObject:viewController];
    if (self.BBB_controllers.count > 0) {
        UIViewController *controller = self.BBB_controllers.firstObject;
        [self pushViewController:controller animated:controller.BBB_shouldShowAnimated];
    }
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
