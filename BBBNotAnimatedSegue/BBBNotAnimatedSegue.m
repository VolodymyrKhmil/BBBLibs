//
//  BBBNotAnimatedSegue.m
//  QuizAndPlay
//
//  Created by Volodymyr Khmil on 3/8/16.
//  Copyright © 2016 Miaplaza Inc. All rights reserved.
//

#import "BBBNotAnimatedSegue.h"

@implementation BBBNotAnimatedSegue
- (void)perform {
    [self.sourceViewController.navigationController pushViewController:self.destinationViewController animated:NO];
}
@end
