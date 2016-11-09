#import "UILabel+BBBHTML.h"
#import <objc/runtime.h>

#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

@implementation UILabel(BBBHTML)

- (void)setBBB_htmlText:(NSString *)BBB_htmlText {
    objc_setAssociatedObject(self, @selector(BBB_htmlText), BBB_htmlText, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    NSError *error = nil;
    self.attributedText = [[NSAttributedString alloc]
                           initWithData: [BBB_htmlText dataUsingEncoding:NSUTF16StringEncoding]
                           options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                           documentAttributes: nil
                           error: &error];
    
    if (error != nil) {
        self.text = @"";
    }
}

- (NSString*)BBB_htmlText {
    return objc_getAssociatedObject(self, @selector(BBB_htmlText));
}

@end
