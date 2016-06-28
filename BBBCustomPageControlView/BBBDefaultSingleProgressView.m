#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

#import "BBBDefaultSingleProgressView.h"
#import "UIColor+ColorsStyle.h"

@interface BBBDefaultSingleProgressView ()

@property (weak, nonatomic) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *innerViewHeightConstraint;

@end

@implementation BBBDefaultSingleProgressView

#pragma mark - Life Cycle

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.innerView = _innerView;
}

#pragma mark - Property

- (void)setHighlited:(BOOL)highlited {
    _highlited = highlited;
    self.innerView.backgroundColor = _highlited ? [UIColor sqOrange] : [UIColor whiteColor];
    self.innerView.alpha = _highlited ? 1.0 : 0.5;
}

- (void)setInnerView:(UIView *)innerView {
    _innerView = innerView;
    _innerView.layer.cornerRadius = self.innerViewHeightConstraint.constant / 2;
}

- (void)setInnerViewHeightConstraint:(NSLayoutConstraint *)innerViewHeightConstraint {
    _innerViewHeightConstraint = innerViewHeightConstraint;
    
    self.innerView.layer.cornerRadius = _innerViewHeightConstraint.constant / 2;
}

@end
