#import <Foundation/Foundation.h>

@interface NSString(BBBPattern)

- (nonnull NSString *)BBB_textWithoutPatternt:(nonnull NSString *)pattern
                              inRange:(nullable NSRange *)range;
- (nonnull NSString *)BBB_normalizedTextWithExpression:(nonnull NSString*)expression;
- (nonnull NSString *)BBB_textWithPatternt:(nonnull NSString *)pattern
                         withRange:(nullable NSRange *)range;

@end
