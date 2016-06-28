
#import "BBBButtonWithCustomFont.h"
#import "UIButton+BBBDevice.h"

#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

@implementation BBBButtonWithCustomFont

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIFont *font = [UIFont fontWithName:self.fontType size:self.titleLabel.font.pointSize];
    if (font != nil) {
        self.titleLabel.font = font;
    }
    [self updateFontToDevice];
}

@end
