
#import <Foundation/Foundation.h>

@interface BBBTwoDimensionalArray : NSObject

@property (nonatomic) NSUInteger verticalCount;
@property (nonatomic) NSUInteger horizontalCount;

- (instancetype)initWithAmmountsRow:(NSUInteger)row andColumn:(NSUInteger)column;

- (id)objectInRow:(NSUInteger)row andColumn:(NSUInteger)column;
- (void)setObject:(id)object inRow:(NSUInteger)row andColumn:(NSUInteger)column;

@end
