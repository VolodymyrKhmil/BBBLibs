
#import "BBBLabelWithCustomFont.h"
#import "UILabel+(BBBDevices).h"

#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

@implementation BBBLabelWithCustomFont
- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIFont *font = [UIFont fontWithName:self.fontType size:self.font.pointSize];
    if (font != nil) {
        self.font = font;
    }
    [self updateFontToDevice];
    
}
@end
