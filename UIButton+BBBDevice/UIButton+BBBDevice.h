//
//  UIButton+BBBDevice.h
//  Sqord
//
//  Created by volodymyrkhmil on 4/5/16.
//  Copyright © 2016 Sqord. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NEUUnifiedLabel.h"

@interface UIButton(BBBDevice)

@property (nonatomic, assign) IBInspectable NSInteger iPhone4FontSize;
@property (nonatomic, assign) IBInspectable NSInteger iPhone5FontSize;
@property (nonatomic, assign) IBInspectable NSInteger iPhone6FontSize;
@property (nonatomic, assign) IBInspectable NSInteger iPhone6PlusFontSize;
@property (nonatomic, assign) IBInspectable NSInteger iPadFontSize;

@property (nonatomic, strong) IBInspectable NSString *size;

- (void)updateFontToDevice;

@end
