
#import "BBBXIBView.h"

#pragma mark - Protocols

@class BBBCustomPageControlView;

@protocol BBBCustomPageControlViewDelegate <NSObject>

@optional
- (void)pageControlView:(BBBCustomPageControlView *)controlView didChangeToPage:(NSInteger)pageIndex;
- (BOOL)pageControlView:(BBBCustomPageControlView *)controlView shouldChangeToPage:(NSInteger)pageIndex;

@end

@protocol BBBPageProgessView <NSObject>

- (void)showPorgress:(NSUInteger)progress withWholeAmount:(NSUInteger)amount;
- (NSInteger)heightForProgressView;

@end

#pragma mark - Enumerations

typedef NS_ENUM(NSInteger, BBBShowType) {
    BBBHidePage
};

#pragma mark - Class

@interface BBBCustomPageControlView : BBBXIBView

- (void)showNextPage;
- (void)showPreviousPage;

@property (nonatomic, assign) BBBShowType showType;
@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *pages;

@property (nonatomic, assign) IBInspectable NSInteger pageIndex;
@property (nonatomic, assign) IBInspectable BOOL underProgress;

@property (nonatomic, strong) UIView<BBBPageProgessView> *progressView;
@property (nonatomic, weak) IBOutlet UIButton *previousButton;
@property (nonatomic, weak) IBOutlet UIButton *nextButton;

@property (nonatomic, weak) id<BBBCustomPageControlViewDelegate> delegate;
@property (nonatomic, assign) BOOL performCheck;

@end
