#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

#import "BBBCustomPageControlView.h"
#import "BBBDefaultProgressView.h"

@implementation BBBCustomPageControlView

#pragma mark - Constants

static const NSInteger kLengthToButtons = 0;

#pragma mark - Public

- (void)showNextPage {
    BOOL canBechecked = [self.delegate respondsToSelector:@selector(pageControlView:shouldChangeToPage:)] && self.performCheck;
    if (!canBechecked || (canBechecked && [self.delegate pageControlView:self shouldChangeToPage:self.pageIndex + 1])) {
        ++self.pageIndex;
    }
}

- (void)showPreviousPage {
    BOOL canBechecked = [self.delegate respondsToSelector:@selector(pageControlView:shouldChangeToPage:)] && self.performCheck;
    if (!canBechecked || (canBechecked && [self.delegate pageControlView:self shouldChangeToPage:self.pageIndex - 1])) {
    --self.pageIndex;
    }
}

#pragma mark - Override

- (void)define {
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - Property

- (void)setPages:(NSArray *)pages {
    for (UIView *page in _pages) {
        [page removeFromSuperview];
    }
    _pages = pages;
    
    if (self.progressView == nil) {
        self.progressView = [[BBBDefaultProgressView alloc] initWithProgressAmount:self.pages.count];
    }

    NSLayoutConstraint * (^topConstraint)(UIView *) = ^NSLayoutConstraint *(UIView *view) {
        return [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    };
    NSLayoutConstraint * (^bottomConstraint)(UIView *) = ^NSLayoutConstraint *(UIView *view) {
        return [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeBottom multiplier:1 constant:(self.underProgress ? 0 : -[self.progressView heightForProgressView])];
    };
    NSLayoutConstraint * (^leftConstraint)(UIView *) = ^NSLayoutConstraint *(UIView *view) {
        return [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    };
    NSLayoutConstraint * (^rightConstraint)(UIView *) = ^NSLayoutConstraint *(UIView *view) {
        return [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    };

    for (UIView *view in _pages) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addViewOnSelf:view];

        NSArray<NSLayoutConstraint *> *constraints = @[ topConstraint(view), bottomConstraint(view), leftConstraint(view), rightConstraint(view) ];
        [self.containerView addConstraints:constraints];
        view.hidden = YES;
    }

    if (_pages.count > 0) {
        NSLog(@"%ld - index", (long)self.pageIndex);
        NSLog(@"%ld - pages", (long)_pages.count);
        self.pageIndex = 0;
    }
}

- (void)setPageIndex:(NSInteger)pageIndex {
    NSInteger previousPageIndex = _pageIndex;
    _pageIndex = pageIndex;
    UIView *currentView = previousPageIndex < self.pages.count ? [self.pages objectAtIndex:previousPageIndex] : nil;
    UIView *nextView = _pageIndex < self.pages.count ? [self.pages objectAtIndex:_pageIndex] : nil;
    
    [self.progressView showPorgress:_pageIndex withWholeAmount:self.pages.count];
    
    switch (self.showType) {
        case BBBHidePage:
            currentView.hidden = YES;
            nextView.hidden = NO;
            break;
            
        default:
            break;
    }
    if ([self.delegate respondsToSelector:@selector(pageControlView:didChangeToPage:)]) {
        [self.delegate pageControlView:self didChangeToPage:_pageIndex];
    }
}

- (void)setProgressView:(UIView<BBBPageProgessView> *)progressView {
    [_progressView removeFromSuperview];
    _progressView = progressView;
    _progressView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addViewOnSelf:_progressView];

    [_progressView addConstraint:[NSLayoutConstraint constraintWithItem:_progressView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:[_progressView heightForProgressView]]];

    NSArray<NSLayoutConstraint *> *constraints = @[ [NSLayoutConstraint constraintWithItem:_progressView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.previousButton attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:kLengthToButtons],
                                                    [NSLayoutConstraint constraintWithItem:_progressView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.nextButton attribute:NSLayoutAttributeLeading multiplier:1.0 constant:kLengthToButtons],
                                                    [NSLayoutConstraint constraintWithItem:_progressView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.nextButton attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0] ];

    [self.containerView addConstraints:constraints];
    [_progressView showPorgress:self.pageIndex withWholeAmount:self.pages.count];
}

- (void)setPreviousButton:(UIButton *)previousButton {
    _previousButton = previousButton;

    [self.containerView bringSubviewToFront:_previousButton];
}

- (void)setNextButton:(UIButton *)nextButton {
    _nextButton = nextButton;

    [self.containerView bringSubviewToFront:_nextButton];
}

#pragma mark - IBActions

- (IBAction)previousPressed {
    [self showPreviousPage];
}

- (IBAction)nextPressed {
    [self showNextPage];
}

#pragma mark - Private

- (void)addViewOnSelf:(UIView *)view {
    [self.containerView addSubview:view];

    [self placeViews];
}

- (void)placeViews {
    [self.containerView bringSubviewToFront:self.previousButton];
    [self.containerView bringSubviewToFront:self.nextButton];
    [self.containerView bringSubviewToFront:self.progressView];
}

@end
