//
//  BBBSlider.h
//  CameraRecordingApp
//
//  Created by admin on 7/21/17.
//  Copyright © 2017 Userfeel Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBBXIBView.h"

@interface BBBSlider : BBBXIBView

@property (nonatomic, assign) IBInspectable CGFloat step;
@property (nonatomic, assign) IBInspectable CGFloat minimum;
@property (nonatomic, assign) IBInspectable CGFloat maximum;
@property (nonatomic, assign) IBInspectable CGFloat value;

@end
