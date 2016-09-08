#import <UIKit/UIKit.h>

@interface UILabel(BBBDevices)

@property (nonatomic, assign) IBInspectable NSInteger iPhone4FontSize;
@property (nonatomic, assign) IBInspectable NSInteger iPhone5FontSize;
@property (nonatomic, assign) IBInspectable NSInteger iPhone6FontSize;
@property (nonatomic, assign) IBInspectable NSInteger iPhone6PlusFontSize;
@property (nonatomic, assign) IBInspectable NSInteger iPadFontSize;

- (void)updateFontToDevice;

@end
