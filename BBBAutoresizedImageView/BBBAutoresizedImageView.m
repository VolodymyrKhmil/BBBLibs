
#import "BBBAutoresizedImageView.h"

#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

@implementation BBBAutoresizedImageView

- (void)layoutSubviews {
    
    CGSize originalSize = self.image.size;
    CGSize boxSize = self.frame.size;
    
    if (originalSize.height == 0) {
        originalSize.height = boxSize.height;
    }
    if (originalSize.width == 0) {
        originalSize.width = boxSize.width;
    }
    
    float widthScale = 0;
    float heightScale = 0;
    
    widthScale = boxSize.width/originalSize.width;
    heightScale = boxSize.height/originalSize.height;
    
    float scale = MIN(widthScale, heightScale);
    
    CGRect newFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, originalSize.width * scale, originalSize.height * scale);
    
    self.frame = newFrame;
    
    [super layoutSubviews];
}

@end
