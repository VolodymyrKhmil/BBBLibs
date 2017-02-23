//
//  UINavigationController+removeController.m
//  Sqord
//
//  Created by volodymyrkhmil on 7/7/16.
//  Copyright © 2016 Sqord. All rights reserved.
//

#import "UINavigationController+removeController.h"

@implementation UINavigationController(BBBremoveController)

- (void)BBB_removeControllerFromStack:(UIViewController *)controller {
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.viewControllers];
    [navigationArray removeObject:controller];
    self.viewControllers = navigationArray;
}

@end
