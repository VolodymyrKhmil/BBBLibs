#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

#import "BBBZeroProgresView.h"

@implementation BBBZeroProgresView

- (void)showPorgress:(NSUInteger)progress withWholeAmount:(NSUInteger)amount {
    
}

- (NSInteger)heightForProgressView {
    return 0;
}

@end
