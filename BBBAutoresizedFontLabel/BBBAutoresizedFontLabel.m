#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

#import "BBBAutoresizedFontLabel.h"

@implementation BBBAutoresizedFontLabel

#pragma marl - Life Cycle

- (void)layoutSubviews {
    [super layoutSubviews];
    
    __block CGFloat largestFontSize = self.font.pointSize;
    
    CGFloat (^neededWidth)(void) = ^CGFloat {
        CGSize countedSize = [self.text sizeWithAttributes:@{NSFontAttributeName : [self.font fontWithSize:largestFontSize]}];
        NSInteger devider = self.numberOfLines == 0 ? (self.frame.size.height - self.verticalMargin * 2) / countedSize.height : self.numberOfLines;
        CGFloat neededWidth = countedSize.width / ((devider > 1) ? devider : 1);
        return neededWidth;
    };
    CGFloat (^neededHeight)(void) = ^CGFloat {
        CGSize countedSize = [self.text sizeWithAttributes:@{NSFontAttributeName : [self.font fontWithSize:largestFontSize]}];
        NSInteger multiplier = self.numberOfLines == 0 ? 1 : self.numberOfLines;
        CGFloat neededheight = countedSize.height * multiplier;
        return neededheight;
    };

    while ((!self.notCheckHorizontaly && neededWidth() > self.frame.size.width - self.horizontalMargin * 2) ||
           (!self.notCheckVericaly && neededHeight() > self.frame.size.height - self.verticalMargin * 2)) {
        largestFontSize--;
    }
    self.font = [self.font fontWithSize:largestFontSize];
}

@end
