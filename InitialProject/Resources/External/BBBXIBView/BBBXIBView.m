#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

#import "BBBXIBView.h"

@interface BBBXIBView ()

@property (nonatomic, strong) NSMutableArray *customConstraints;

@end

@implementation BBBXIBView

#pragma mark - Initializers

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    
    if (self != nil) {
        [self commonInit];
    }
    
    return self;
}

#pragma mark - Public

- (void)define {
}

#pragma mark - Private

- (void)commonInit {
    [self define];
    
    _customConstraints = [[NSMutableArray alloc] init];
    
    UIView *view = nil;
    NSString *className = [NSStringFromClass([self class]) componentsSeparatedByString:@"."].lastObject;
    
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:className
                                                     owner:self
                                                   options:nil];
    for (id object in objects) {
        if ([object isKindOfClass:[UIView class]]) {
            view = object;
            break;
        }
    }
    
    if (view != nil) {
        _containerView = view;
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
        [self setNeedsUpdateConstraints];
    }
}

#pragma mark - Override

- (void)updateConstraints {
    [self removeConstraints:self.customConstraints];
    [self.customConstraints removeAllObjects];
    
    if (self.containerView != nil) {
        UIView *view = self.containerView;
        NSDictionary *views = NSDictionaryOfVariableBindings(view);
        
        [self.customConstraints addObjectsFromArray:
         [NSLayoutConstraint constraintsWithVisualFormat:
          @"H:|[view]|"
                                                 options:0
                                                 metrics:nil
                                                   views:views]];
        [self.customConstraints addObjectsFromArray:
         [NSLayoutConstraint constraintsWithVisualFormat:
          @"V:|[view]|"
                                                 options:0
                                                 metrics:nil
                                                   views:views]];
        
        [self addConstraints:self.customConstraints];
    }
    
    [super updateConstraints];
}

@end
