//
//  BBBSlider.m
//  CameraRecordingApp
//
//  Created by admin on 7/21/17.
//  Copyright © 2017 Userfeel Ltd. All rights reserved.
//

#import "BBBSlider.h"

@interface BBBSlider()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelLeadingConstraint;

@end

@implementation BBBSlider

#pragma mark - Setters

- (void)setMaximum:(CGFloat)maximum {
    _maximum = maximum;
    [self updateMaximum];
}

- (void)setMinimum:(CGFloat)minimum {
    _minimum = minimum;
    [self updateMinimum];
}

- (void)setValue:(CGFloat)value {
    _value = value;
    [self updateValue];
}

#pragma mark - Override

- (void)define {
    [super define];
    self.step = 1;
}

#pragma mark - Methods

- (void)updateMinimum {
    self.slider.minimumValue = self.minimum;
    self.value = self.slider.value;
}

- (void)updateMaximum {
    self.slider.maximumValue = self.maximum;
    self.value = self.slider.value;
}

- (void)updateValue {
    CGFloat max = self.maximum;
    CGFloat min = self.minimum;
    
    if (max <= min) {
        return;
    }
    
    [self.slider setValue:self.value animated:NO];
    self.label.text = [NSString stringWithFormat:@"%li", (long)self.value];
    CGFloat countValue = self.value - min;
    
    CGFloat centering = 30 * ((((max - min) / 2) - countValue) / (max - min)) - (self.label.intrinsicContentSize.width / 2);
    CGFloat value = centering + self.slider.frame.origin.x + self.slider.frame.size.width * (countValue / (max - min));
    self.labelLeadingConstraint.constant = value;
    [self.label layoutIfNeeded];
}

#pragma mark - IBActions

- (IBAction)sliderMoved {
    CGFloat value = self.slider.value;
    
    CGFloat step = self.step;
    CGFloat halfStep = step / 2;
    
    CGFloat roundedValue = ((int)((value + halfStep) / step) * step);
    
    self.value = roundedValue;
}

@end
