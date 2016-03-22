
#import "BBBAutomaticalyResizedFontButton.h"

#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

@implementation BBBAutomaticalyResizedFontButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    __block CGFloat largestFontSize = self.titleLabel.font.pointSize;
    
    CGFloat (^neededWidth)(void) = ^CGFloat{
        CGSize countedSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:largestFontSize]}];
        NSInteger devider = (self.frame.size.height - self.verticalMargin * 2) / countedSize.height;
        CGFloat neededWidth = countedSize.width / ((devider > 1) ? devider : 1);
        return neededWidth;
    };
    
    while (neededWidth() > self.frame.size.width - self.horizontalMargin * 2) {
        largestFontSize--;
    }
    self.titleLabel.font = [UIFont systemFontOfSize:largestFontSize];
}

@end
