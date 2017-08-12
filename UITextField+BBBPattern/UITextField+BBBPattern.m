#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

#import "UITextField+BBBPattern.h"
#import <objc/runtime.h>

@implementation UITextField(BBBPattern)

@dynamic BBB_pattern;
//@dynamic BBB_changedBlock;

- (NSString *)BBB_pattern {
    return objc_getAssociatedObject(self, @selector(BBB_pattern));
}

- (void)setBBB_pattern:(NSString *)BBB_pattern {
    objc_setAssociatedObject(self, @selector(BBB_pattern), BBB_pattern, OBJC_ASSOCIATION_RETAIN);
    [self BBB_registerListener];
}

- (BBB_PatternTextFieldChangedBlock)BBB_changedBlock {
    return objc_getAssociatedObject(self, @selector(BBB_changedBlock));
}

- (void)setBBB_changedBlock:(BBB_PatternTextFieldChangedBlock)BBB_changedBlock {
    objc_setAssociatedObject(self, @selector(BBB_changedBlock), BBB_changedBlock, OBJC_ASSOCIATION_RETAIN);
    [self BBB_registerListener];
}

- (NSString *)BBB_nonPatternText {
    if (self.BBB_pattern != nil) {
        return self.text == nil ? nil : [UITextField BBB_text:self.text withoutPatternt:self.BBB_pattern];
    }
    
    return self.text;
}

#pragma mark - Private

- (void)BBB_registerListener {
    [self addTarget:self
             action:@selector(BBB_textFieldDidChange:)
   forControlEvents:UIControlEventEditingChanged];
    [self BBB_calculateTextForTextField:self];
}

#pragma mark - Actions

- (void)BBB_textFieldDidChange:(UITextField *)textField {
    [self BBB_calculateTextForTextField:textField];
}

- (void)BBB_calculateTextForTextField:(UITextField *)textField {
    if (self.BBB_pattern != nil) {
        NSString *nonPattern    = [UITextField BBB_text:textField.text withoutPatternt:self.BBB_pattern];
        NSString *pattern       = [UITextField BBB_text:nonPattern withPatternt:self.BBB_pattern];
        
        if (![textField.text isEqualToString:pattern]) {
            textField.text = pattern;
        }
    }
    if (textField.BBB_changedBlock != nil) {
        textField.BBB_changedBlock(textField);
    }
}

+ (NSString *)BBB_text:(NSString*)text withoutPatternt:(NSString *)pattern {
    NSMutableString *result = [NSMutableString new];
    for (NSInteger i = 0; i < MIN(pattern.length, text.length); ++i) {
        unichar patternCh   = [pattern characterAtIndex:i];
        unichar textCh      = [text characterAtIndex:i];
        
        if (patternCh == '#') {
            [result appendString:[NSString stringWithCharacters:&textCh length:1]];
        } else if (patternCh != textCh) {
            [result appendString:[NSString stringWithCharacters:&textCh length:1]];
        }
    }
    
    return result;
}

+ (NSString *)BBB_text:(NSString*)text withPatternt:(NSString *)pattern {
    NSMutableString *result = [NSMutableString new];
    
    for (NSInteger i = 0, j = 0; i < pattern.length && j < text.length; ++i) {
        
        unichar patternCh   = [pattern characterAtIndex:i];
        unichar textCh      = [text characterAtIndex:j];
        
        if (patternCh == '#') {
            [result appendString:[NSString stringWithCharacters:&textCh length:1]];
            ++j;
        } else {
            [result appendString:[NSString stringWithCharacters:&patternCh length:1]];
        }
    }
    
    return result;
}

@end
