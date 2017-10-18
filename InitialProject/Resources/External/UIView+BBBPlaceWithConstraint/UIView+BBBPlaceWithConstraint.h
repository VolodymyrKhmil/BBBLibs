
#import <UIKit/UIKit.h>

@interface UIView(BBBPlaceWithConstraint)

+ (NSArray<NSLayoutConstraint *>*)placeView:(UIView*)view onOtherView:(UIView*)otherView;

@end
