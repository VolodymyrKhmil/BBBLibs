
#import "BBBButtonWithCustomFont.h"

#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

@implementation BBBButtonWithCustomFont

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.font = [UIFont fontWithName:self.fontType size:self.titleLabel.font.pointSize];
    
}

@end
