//
//  UIButton+BBBDevice.m
//  Sqord
//
//  Created by volodymyrkhmil on 4/5/16.
//  Copyright © 2016 Sqord. All rights reserved.
//

#import "UIButton+BBBDevice.h"
#import "NSObject+associatedObject.h"

#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

@implementation UIButton(BBBDevice)

#pragma mark - Property

- (void)setIPhone4FontSize:(NSInteger)iPhone4FontSize {
    if ([DeviceOperations deviceModel] == DeviceModelIPhone4) {
        self.associatedObject = @(iPhone4FontSize);
        [self.titleLabel setFont: [self.titleLabel.font fontWithSize: iPhone4FontSize]];
    }
}

- (void)setIPhone5FontSize:(NSInteger)iPhone5FontSize {
    if ([DeviceOperations deviceModel] == DeviceModelIPhone5) {
        self.associatedObject = @(iPhone5FontSize);
        [self.titleLabel setFont: [self.titleLabel.font fontWithSize: iPhone5FontSize]];
    }
}

- (void)setIPhone6FontSize:(NSInteger)iPhone6FontSize {
    if ([DeviceOperations deviceModel] == DeviceModelIPhone6) {
        self.associatedObject = @(iPhone6FontSize);
        [self.titleLabel setFont: [self.titleLabel.font fontWithSize: iPhone6FontSize]];
    }
}

- (void)setIPhone6PlusFontSize:(NSInteger)iPhone6PlusFontSize {
    if ([DeviceOperations deviceModel] == DeviceModelIPhone6plus) {
        self.associatedObject = @(iPhone6PlusFontSize);
        [self.titleLabel setFont: [self.titleLabel.font fontWithSize: iPhone6PlusFontSize]];
    }
}

- (void)setIPadFontSize:(NSInteger)iPadFontSize {
    if ([DeviceOperations deviceModel] == DeviceModelIPad) {
        self.associatedObject = @(iPadFontSize);
        [self.titleLabel setFont: [self.titleLabel.font fontWithSize: iPadFontSize]];
    }
}

- (void)setSize:(NSString *)size {
    self.titleLabel.size = size;
    [self sizeToFit];
}

- (void)updateFontToDevice {
    if (self.associatedObject != nil)
        [self.titleLabel setFont: [self.titleLabel.font fontWithSize: [self.associatedObject integerValue]]];
}

- (NSInteger)iPhone4FontSize {
    return self.titleLabel.font.pointSize;
}

- (NSInteger)iPhone5FontSize {
    return self.titleLabel.font.pointSize;
}

- (NSInteger)iPhone6FontSize {
    return self.titleLabel.font.pointSize;
}

- (NSInteger)iPhone6PlusFontSize {
    return self.titleLabel.font.pointSize;
}

- (NSInteger)iPadFontSize {
    return self.titleLabel.font.pointSize;
}

@end
