#import "BBBAutoresizedFontLabel.h"
#import <CoreText/CoreText.h>

#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

@implementation BBBAutoresizedFontLabel

#pragma mark - Life Cycle

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.text.length > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CGFloat largestFontSize = 1;
            NSInteger numberOfLines = self.numberOfLines == 0 ? 1 : self.numberOfLines;
            
            NSInteger (^linesNumber)(void) = ^NSInteger {
                CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([self.font fontName]), largestFontSize, NULL);
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self.text];
                [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
                
                CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
                
                CGMutablePathRef path = CGPathCreateMutable();
                CGPathAddRect(path, NULL, CGRectMake(0,0,self.bounds.size.width - self.horizontalMargin * 2,100000));
                
                CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
                NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
                
                return lines.count;
            };
            
            BOOL (^widthIsOverLimit)(void) = ^BOOL {
                return numberOfLines < linesNumber();
            };
            
            BOOL (^heightIsOverLimit)(void) = ^BOOL {
                CGSize countedSize = [self.text sizeWithAttributes:@{NSFontAttributeName : [self.font fontWithSize:largestFontSize]}];
                CGFloat neededHeight = countedSize.height * numberOfLines;
                return numberOfLines < linesNumber() || neededHeight > self.bounds.size.height - self.verticalMargin * 2;
            };
            
            while ((self.notCheckHorizontaly || !widthIsOverLimit()) &&
                   (self.notCheckVericaly || !heightIsOverLimit())) {
                ++largestFontSize;
            }
            self.font = [self.font fontWithSize:largestFontSize - 1];
        });
    }
}

@end
