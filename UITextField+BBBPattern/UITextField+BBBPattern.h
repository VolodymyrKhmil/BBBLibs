#import <UIKit/UIKit.h>

typedef void (^BBB_PatternTextFieldChangedBlock)(UITextField * _Nonnull);

@interface UITextField(BBBPattern)

@property (nonatomic, strong, nullable) IBInspectable NSString *BBB_pattern;
@property (nonatomic, strong, nullable, readonly) NSString *BBB_nonPatternText;
@property (nonatomic, copy, nullable) BBB_PatternTextFieldChangedBlock BBB_changedBlock;

@end
