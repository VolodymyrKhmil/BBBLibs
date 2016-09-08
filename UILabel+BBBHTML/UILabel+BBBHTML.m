#import "UILabel+BBBHTML.h"
#import <objc/runtime.h>

@implementation UILabel(BBBHTML)

- (void)setBBB_htmlText:(NSString *)BBB_htmlText {
    objc_setAssociatedObject(self, @selector(BBB_htmlText), BBB_htmlText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
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
