
#import "BBBFrontPageControllPageViewController.h"

#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

@implementation BBBFrontPageControllPageViewController

-(void)viewDidLayoutSubviews {
    UIView* view = self.view;
    NSArray* subviews = view.subviews;

    if( [subviews count] == 2 ) {
        UIScrollView* scrollView = nil;
        UIPageControl* pageControll = nil;
        for( UIView* subview in subviews ) {
            if( [subview isKindOfClass:[UIScrollView class]] ) {
                scrollView = (UIScrollView*)subview;
            } else if( [subview isKindOfClass:[UIPageControl class]] ) {
                pageControll = (UIPageControl*)subview;
            }
        }
        if( scrollView != nil && pageControll != nil ) {
            scrollView.frame = view.bounds;
            [view bringSubviewToFront:pageControll];
        }
    }
    [super viewDidLayoutSubviews];
}

@end
