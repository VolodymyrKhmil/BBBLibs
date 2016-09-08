//
//  BBBAutoresizedFontLabel.h
//  Sqord
//
//  Created by volodymyrkhmil on 3/23/16.
//  Copyright © 2016 Sqord. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NEUUnifiedLabel.h"

@interface BBBAutoresizedFontLabel : UILabel

@property (nonatomic) IBInspectable NSInteger horizontalMargin;
@property (nonatomic) IBInspectable NSInteger verticalMargin;

@property (nonatomic) IBInspectable BOOL notCheckVericaly;
@property (nonatomic) IBInspectable BOOL notCheckHorizontaly;

@end
