#import "NSString+BBBPattern.h"
#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

@implementation NSString(BBBPattern)

- (NSString *)BBB_textWithoutPatternt:(NSString *)pattern
                              inRange:(NSRange *)range {
    
    if (pattern.length == 0) {
        return self;
    }
    
    NSMutableString *result = [NSMutableString new];
    NSUInteger length       = 0;
    NSUInteger location     = 0;
    
    for (NSInteger i = 0; i < MIN(pattern.length, self.length); ++i) {
        unichar patternCh   = [pattern characterAtIndex:i];
        unichar textCh      = [self characterAtIndex:i];
        
        if (patternCh == '#') {
            [result appendString:[NSString stringWithCharacters:&textCh
                                                         length:1]];
        } else if (patternCh != textCh) {
            [result appendString:[NSString stringWithCharacters:&textCh
                                                         length:1]];
        } else if (range != nil) {
            
            if (i < range->location) {
                ++location;
            } else if (i < range->location + range->length) {
                ++length;
            }
            
        }
    }
    
    if (range != nil) {
        
        range->location -= location;
        range->length   -= length;
    }
    
    return result;
}

- (NSString *)BBB_normalizedTextWithExpression:(NSString*)expression {
    
    if (0 == expression.length) {
        return self;
    }
    
    NSMutableString *mutable = [self mutableCopy];
    for(int index = 0; index < mutable.length; ++index) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", expression];
        
        while (mutable.length > 0) {
            
            if ([predicate evaluateWithObject: mutable]){
                return mutable;
            }
            [mutable deleteCharactersInRange: NSMakeRange(mutable.length - 1, 1)];
        }
    }
    
    return @"";
}

- (NSString *)BBB_textWithPatternt:(NSString *)pattern
                         withRange:(NSRange *)range {
    
    NSMutableString *result = [NSMutableString new];
    
    NSUInteger length   = 0;
    NSUInteger location = 0;
    
    for (NSInteger i = 0, j = 0; i < pattern.length && j < self.length; ++i) {
        
        unichar patternCh   = [pattern characterAtIndex:i];
        unichar textCh      = [self characterAtIndex:j];
        
        if (patternCh == '#') {
            
            [result appendString:[NSString stringWithCharacters:&textCh
                                                         length:1]];
            ++j;
        } else {
            
            [result appendString:[NSString stringWithCharacters:&patternCh
                                                         length:1]];
            if (range != nil && j < range->location) {
                ++location;
            }
        }
    }
    
    if (range != nil) {
        
        range->length   += length;
        range->location += location;
    }
    
    return result;
}

@end
