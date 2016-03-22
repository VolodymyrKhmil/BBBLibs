
#import "BBBLabelWithCustomFont.h"

#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

@implementation BBBLabelWithCustomFont
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.font = [UIFont fontWithName:self.fontType size:self.font.pointSize];
    
}
@end
