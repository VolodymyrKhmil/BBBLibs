#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

#import "BBBDefaultProgressView.h"
#import "BBBDefaultSingleProgressView.h"

@interface BBBDefaultProgressView ()

@property (nonatomic, strong) NSArray<BBBDefaultSingleProgressView *> *singleViews;

@end

@implementation BBBDefaultProgressView

#pragma mark - Initializers

- (instancetype)initWithProgressAmount:(NSUInteger)progressAmount {
    self = [super init];

    if (self != nil) {
        [self buildViewForProgress:progressAmount];
    }

    return self;
}

#pragma mark - BBBPageProgessView

- (void)showPorgress:(NSUInteger)progress withWholeAmount:(NSUInteger)amount {
    [self.singleViews enumerateObjectsUsingBlock:^(BBBDefaultSingleProgressView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (idx == progress) {
            obj.highlited = YES;
        } else {
            obj.highlited = NO;
        }
    }];
}

- (NSInteger)heightForProgressView {
    return ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) ? 110 : ([UIScreen mainScreen].bounds.size.height / 6.4);
}

#pragma mark - Private

- (void)buildViewForProgress:(NSUInteger)progress {
    BBBDefaultSingleProgressView *previousView = nil;
    NSMutableArray *views = [NSMutableArray new];

    NSLayoutConstraint * (^topConstraint)(UIView *) = ^NSLayoutConstraint *(UIView *view) {
        return [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    };
    NSLayoutConstraint * (^bottomConstraint)(UIView *) = ^NSLayoutConstraint *(UIView *view) {
        return [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    };
    NSLayoutConstraint * (^leftConstraint)(UIView *) = ^NSLayoutConstraint *(UIView *view) {
        return [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    };
    NSLayoutConstraint * (^rightConstraint)(UIView *) = ^NSLayoutConstraint *(UIView *view) {
        return [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    };
    NSLayoutConstraint * (^horizontalConstraint)(UIView *, UIView *) = ^NSLayoutConstraint *(UIView *leftView, UIView *rightView) {
        return [NSLayoutConstraint constraintWithItem:leftView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:rightView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    };
    NSLayoutConstraint * (^equalWidth)(UIView *, UIView *) = ^NSLayoutConstraint *(UIView *leftView, UIView *rightView) {
        return [NSLayoutConstraint constraintWithItem:leftView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:rightView attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    };

    for (int index = 0; index < progress; ++index) {
        BBBDefaultSingleProgressView *singleView = (BBBDefaultSingleProgressView *)[UIView loadViewWithNibNamed:@"BBBDefaultSingleProgressView"];
        singleView.translatesAutoresizingMaskIntoConstraints = NO;

        NSMutableArray<NSLayoutConstraint *> *constraints = [[NSMutableArray alloc] initWithObjects:topConstraint(singleView), bottomConstraint(singleView), nil];

        if (previousView == nil) {
            [constraints addObject:leftConstraint(singleView)];
        } else {
            [constraints addObject:horizontalConstraint(previousView, singleView)];
            [constraints addObject:equalWidth(previousView, singleView)];
        }

        if (index == progress - 1) {
            [constraints addObject:rightConstraint(singleView)];
        }

        [views addObject:singleView];
        [self addSubview:singleView];
        [self addConstraints:constraints];
        previousView = singleView;
    }

    self.singleViews = views;
}

@end
