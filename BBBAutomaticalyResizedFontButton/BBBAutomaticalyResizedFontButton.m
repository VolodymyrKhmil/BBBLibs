
#import "BBBAutomaticalyResizedFontButton.h"

#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

@implementation BBBAutomaticalyResizedFontButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    __block CGFloat largestFontSize = self.titleLabel.font.pointSize;
    
    CGFloat (^neededWidth)(void) = ^CGFloat {
        CGSize countedSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : [self.titleLabel.font fontWithSize:largestFontSize]}];
        CGFloat neededWidth = countedSize.width;
        return neededWidth;
    };
    CGFloat (^neededHeight)(void) = ^CGFloat {
        CGSize countedSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : [self.titleLabel.font fontWithSize:largestFontSize]}];
        CGFloat neededheight = countedSize.height;
        return neededheight;
    };
    
    while ((!self.notCheckHorizontaly && neededWidth() > self.frame.size.width - self.horizontalMargin * 2) ||
           (!self.notCheckVericaly && neededHeight() > self.frame.size.height - self.verticalMargin * 2)) {
        largestFontSize--;
    }
    self.titleLabel.font = [self.titleLabel.font fontWithSize:largestFontSize];
}

@end
