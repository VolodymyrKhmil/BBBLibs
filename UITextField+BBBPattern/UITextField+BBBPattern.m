#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

#import "UITextField+BBBPattern.h"
#import <objc/runtime.h>
#import "NSString+BBBPattern.h"

#pragma mark - API

static inline BOOL BBB_selector_belongsToProtocol(SEL selector, Protocol * protocol);

@interface UITextField(Exchange)

- (void)BBB_setText:(NSString *)text;

- (void)BBB_setDelegate:(id<UITextFieldDelegate>)delegate;

- (id<UITextFieldDelegate>)BBB_delegate;

- (id)BBB_forwardingTargetForSelector:(SEL)aSelector;

- (BOOL)BBB_respondsToSelector:(SEL)aSelector;

@end

@interface UITextField(BBBDelegate) <UITextFieldDelegate>
@end

@interface UITextField(BBBPrivate)

+ (void)BBB_adaptTextField:(UITextField *)textField
              toExpression:(NSString *)expression;

+ (void)BBB_calculateText:(NSString *)text
             forTextField:(UITextField *)textField
              changeBlock:(BBB_PatternTextFieldChangedBlock)block
                withRange:(NSRange)range;

- (BOOL)BBB_isValidForText:(NSString*)text;

- (void)BBB_registerListener;

+ (Protocol *)BBB_textFieldProtocol;

- (BOOL)BBB_delegatesSelector:(SEL)aSelector;

@end

#pragma mark - Objects

@interface BBB_WeakObjectContainer : NSObject
@property (nonatomic, readonly, weak) id object;
@end

@implementation BBB_WeakObjectContainer
- (instancetype) initWithObject:(id)object
{
    if (!(self = [super init])) {
        return nil;
    }
    
    _object = object;
    
    return self;
}
@end

#pragma mark - Swizzle

@implementation UITextField(Exchange)

- (void)BBB_setText:(NSString *)text {
    if (![self BBB_isValidForText:text]) {
        return;
    }
    
    [UITextField BBB_calculateText:text
                      forTextField:self
                       changeBlock:nil
                         withRange:NSMakeRange(-1, -1)];
}

- (void)BBB_setDelegate:(id<UITextFieldDelegate>)delegate {
    [self BBB_setDelegate: self];
    BBB_WeakObjectContainer *object = [[BBB_WeakObjectContainer alloc] initWithObject:delegate];
    
    objc_setAssociatedObject(self,
                             @selector(BBB_setDelegate:),
                             object,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<UITextFieldDelegate>)BBB_delegate {
    return ((BBB_WeakObjectContainer *)objc_getAssociatedObject(self, @selector(BBB_setDelegate:))).object;
}

- (id)BBB_forwardingTargetForSelector:(SEL)aSelector {
    if ([self BBB_delegatesSelector:aSelector]) {
        return self.delegate;
    }
    
    return [self BBB_forwardingTargetForSelector:aSelector];
}

- (BOOL)BBB_respondsToSelector:(SEL)aSelector {
    if ([self BBB_delegatesSelector:aSelector]) {
        return YES;
    }
    
    return [self BBB_respondsToSelector:aSelector];
}

#pragma mark - Override

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod(self,
                                                               @selector(setText:)),
                                       class_getInstanceMethod(self, @selector(BBB_setText:)));
        
        method_exchangeImplementations(class_getInstanceMethod(self,
                                                               @selector(setDelegate:)),
                                       class_getInstanceMethod(self, @selector(BBB_setDelegate:)));
        
        method_exchangeImplementations(class_getInstanceMethod(self,
                                                               @selector(delegate)),
                                       class_getInstanceMethod(self, @selector(BBB_delegate)));
        
        method_exchangeImplementations(class_getInstanceMethod(self,
                                                               @selector(respondsToSelector:)),
                                       class_getInstanceMethod(self, @selector(BBB_respondsToSelector:)));
        
        method_exchangeImplementations(class_getInstanceMethod(self,
                                                               @selector(forwardingTargetForSelector:)),
                                       class_getInstanceMethod(self, @selector(BBB_forwardingTargetForSelector:)));
    });
}

@end

#pragma mark - Private

@implementation UITextField(BBBPrivate)

+ (void)BBB_adaptTextField:(UITextField *)textField
              toExpression:(NSString *)expression {
    
    NSString *nonPattern;
    if (textField.BBB_pattern != nil) {
        nonPattern = [textField.text BBB_textWithoutPatternt:textField.BBB_pattern
                                                     inRange:nil];
    } else {
        nonPattern = textField.text;
    }
    
    NSString *text = [nonPattern BBB_normalizedTextWithExpression:expression];
    
    if (textField.BBB_pattern != nil) {
        text = [text BBB_textWithPatternt:textField.BBB_pattern
                                withRange:nil];
    }
    
    if (![textField.text isEqualToString:text]) {
        
        [textField BBB_setText: text];
        if (textField.BBB_changedBlock != nil) {
            textField.BBB_changedBlock(textField);
        }
    }
}

- (void)BBB_changeCursorForRange:(NSRange)range {
    UITextPosition *beginning       = self.beginningOfDocument;
    UITextPosition *cursorLocation  = [self positionFromPosition:beginning
                                                          offset:(range.location + range.length)];
    if(cursorLocation) {
        [self setSelectedTextRange:[self textRangeFromPosition:cursorLocation
                                                    toPosition:cursorLocation]];
    }
}

+ (void)BBB_calculateText:(NSString *)text
             forTextField:(UITextField *)textField
              changeBlock:(BBB_PatternTextFieldChangedBlock)block
                withRange:(NSRange)range {
    
    if (textField.BBB_pattern.length != 0) {
        
        NSString *pattern = [text BBB_textWithPatternt:textField.BBB_pattern
                                             withRange:&range];
        
        if (![textField.text isEqualToString: pattern]) {
            
            [textField BBB_setText: pattern];
            [textField BBB_changeCursorForRange:range];
            
            if (block != nil) {
                block(textField);
            }
        }
    } else {
        
        [textField BBB_setText: text];
        if (block != nil) {
            block(textField);
        }
    }
}

- (BOOL)BBB_isValidForText:(NSString*)text {
    if (self.BBB_regular.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", self.BBB_regular];
        return [predicate evaluateWithObject:text];
    }
    
    return YES;
}

- (void)BBB_registerListener {
    [self addTarget:self
             action:@selector(BBB_textFieldDidChange:)
   forControlEvents:UIControlEventEditingChanged];
    
    [self BBB_setDelegate: self];
}

#pragma mark - Actions

- (void)BBB_textFieldDidChange:(UITextField*)textField {
    if (textField.BBB_changedBlock != nil) {
        textField.BBB_changedBlock(self);
    }
}

#pragma mark - Protocols

+ (Protocol *)BBB_textFieldProtocol {
    return objc_getProtocol([@"UITextFieldDelegate" cStringUsingEncoding:[NSString defaultCStringEncoding]]);
}

- (BOOL)BBB_delegatesSelector:(SEL)aSelector {
    if (self.delegate != nil) {
        return [self.delegate respondsToSelector:aSelector]
        && BBB_selector_belongsToProtocol(aSelector,
                                          [UITextField BBB_textFieldProtocol]);
    }
    
    return NO;
}

@end

#pragma mark - UITextFieldDelegate

@implementation UITextField(BBBDelegate)

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    
    NSString *text = [textField.text BBB_textWithoutPatternt:self.BBB_pattern
                                                     inRange:&range];
    NSString *final = [text stringByReplacingCharactersInRange:range
                                                    withString:string];
    
    if (![textField BBB_isValidForText:final]) {
        return NO;
    }
    
    if (self.BBB_pattern.length != 0) {
        
        [textField BBB_setText:text];
        
        if (![self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]
            || [self.delegate textField:textField
          shouldChangeCharactersInRange:range
                      replacementString:string]) {
                
            NSRange positionRange = NSMakeRange(range.location + string.length, 0);
            [UITextField BBB_calculateText:final
                              forTextField:textField
                               changeBlock:textField.BBB_changedBlock
                                 withRange:positionRange];
        }
        
        return NO;
    }
    
    if ([self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.delegate textField:textField
          shouldChangeCharactersInRange:range
                      replacementString:string];
    }
    return YES;
}

@end

#pragma mark - Public

@implementation UITextField(BBBPattern)

@dynamic BBB_pattern;
@dynamic BBB_regular;

- (NSString *)BBB_pattern {
    return objc_getAssociatedObject(self, @selector(BBB_pattern));
}

- (void)setBBB_pattern:(NSString *)BBB_pattern {
    if (![BBB_pattern isEqualToString:self.BBB_pattern]) {
        
        NSString *text = [self.text BBB_textWithoutPatternt:self.BBB_pattern
                                                    inRange:nil];
        
        objc_setAssociatedObject(self,
                                 @selector(BBB_pattern),
                                 BBB_pattern,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [UITextField BBB_calculateText:text
                          forTextField:self changeBlock:nil
                             withRange:NSMakeRange(-1, -1)];
        [self BBB_registerListener];
    }
}

- (NSString *)BBB_regular {
    return objc_getAssociatedObject(self,
                                    @selector(BBB_regular));
}

- (void)setBBB_regular:(NSString *)BBB_regular {
    if (![BBB_regular isEqualToString:self.BBB_regular]) {
        
        objc_setAssociatedObject(self,
                                 @selector(BBB_regular),
                                 BBB_regular,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [UITextField BBB_adaptTextField:self
                           toExpression:BBB_regular];
        
        [self BBB_registerListener];
    }
}

- (BBB_PatternTextFieldChangedBlock)BBB_changedBlock {
    return objc_getAssociatedObject(self,
                                    @selector(BBB_changedBlock));
}

- (void)setBBB_changedBlock:(BBB_PatternTextFieldChangedBlock)BBB_changedBlock {
    objc_setAssociatedObject(self,
                             @selector(BBB_changedBlock),
                             BBB_changedBlock,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self BBB_registerListener];
}

- (NSString *)BBB_nonPatternText {
    if (self.BBB_pattern != nil) {
        return self.text == nil ? nil : [self.text BBB_textWithoutPatternt:self.BBB_pattern
                                                                   inRange:nil];
    }
    
    return self.text;
}

@end

#pragma mark - Runtime Magic

BOOL BBB_selector_belongsToProtocol(SEL selector, Protocol * protocol) {
    for (int optionbits = 0; optionbits < (1 << 2); optionbits++) {
        BOOL required = optionbits & 1;
        BOOL instance = !(optionbits & (1 << 1));
        
        struct objc_method_description hasMethod = protocol_getMethodDescription(protocol, selector, required, instance);
        if (hasMethod.name || hasMethod.types) {
            return YES;
        }
    }
    
    return NO;
}
