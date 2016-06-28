
#import "BBBCustomPageControlView.h"

@interface BBBDefaultProgressView : UIView <BBBPageProgessView>

- (instancetype)initWithProgressAmount:(NSUInteger)progressAmount;
- (void)showPorgress:(NSUInteger)progress withWholeAmount:(NSUInteger)amount;

@end
