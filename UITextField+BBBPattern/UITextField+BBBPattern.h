//
//  UITextField+BBBPattern.h
//  SwayPay
//
//  Created by admin on 8/1/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BBB_PatternTextFieldChangedBlock)(UITextField * _Nonnull);

@interface UITextField(BBBPattern)

@property (nonatomic, strong, nullable) IBInspectable NSString *BBB_pattern;
@property (nonatomic, strong, nullable) IBInspectable NSString *BBB_regular;
@property (nonatomic, strong, nullable, readonly) NSString *BBB_nonPatternText;
@property (nonatomic, copy, nullable) BBB_PatternTextFieldChangedBlock BBB_changedBlock;

@end
