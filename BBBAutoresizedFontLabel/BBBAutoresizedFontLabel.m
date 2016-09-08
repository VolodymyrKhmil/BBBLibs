//
//  BBBAutoresizedFontLabel.m
//  Sqord
//
//  Created by volodymyrkhmil on 3/23/16.
//  Copyright © 2016 Sqord. All rights reserved.
//

#import "BBBAutoresizedFontLabel.h"

#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

@implementation BBBAutoresizedFontLabel

#pragma mark - Life Cycle

- (void)layoutSubviews {
    [super layoutSubviews];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.text.length > 0) {
            __block CGFloat largestFontSize = 0;
            
            CGFloat (^neededWidth)(void) = ^CGFloat {
                CGSize countedSize = [self.text sizeWithAttributes:@{NSFontAttributeName : [self.font fontWithSize:largestFontSize]}];
                NSInteger devider = self.numberOfLines == 0 ? (self.bounds.size.height - self.verticalMargin * 2) / countedSize.height : self.numberOfLines;
                CGFloat neededWidth = countedSize.width / ((devider > 1) ? devider : 1);
                return neededWidth;
            };
            CGFloat (^neededHeight)(void) = ^CGFloat {
                CGSize countedSize = [self.text sizeWithAttributes:@{NSFontAttributeName : [self.font fontWithSize:largestFontSize]}];
                NSInteger multiplier = self.numberOfLines == 0 ? 1 : self.numberOfLines;
                CGFloat neededheight = countedSize.height * multiplier;
                return neededheight;
            };
            
            while ((self.notCheckHorizontaly || neededWidth() <= self.bounds.size.width - self.horizontalMargin * 2) &&
                   (self.notCheckVericaly || neededHeight() <= self.bounds.size.height - self.verticalMargin * 2)) {
                ++largestFontSize;
            }
            self.font = [self.font fontWithSize:largestFontSize - 1];
        }
    });
}

@end
