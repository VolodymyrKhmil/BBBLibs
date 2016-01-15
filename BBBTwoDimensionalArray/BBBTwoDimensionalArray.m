
#import "BBBTwoDimensionalArray.h"

#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

@interface BBBTwoDimensionalArray()

@property (strong, nonatomic) NSMutableArray<NSMutableArray*>* array;

@end

@implementation BBBTwoDimensionalArray

#pragma mark - Initializers

- (instancetype)initWithAmmountsRow:(NSUInteger)row andColumn:(NSUInteger)column {
    self = [super init];
    
    if (self != nil) {
        _array = [[NSMutableArray alloc] initWithCapacity:row];
        
        for (NSInteger i = 0; i < row; ++i) {
            [_array insertObject:[[NSMutableArray alloc] initWithCapacity:column] atIndex:i];
        }
    }
    
    return self;
}

- (instancetype)init {
    self = [super init];
    
    if (self != nil) {
        _array = [NSMutableArray new];
    }
    
    return self;
}

#pragma mark - Public

- (id)objectInRow:(NSUInteger)row andColumn:(NSUInteger)column {
    return [(NSMutableArray*)[_array objectAtIndex:row] objectAtIndex:column];
}

- (void)setObject:(id)object inRow:(NSUInteger)row andColumn:(NSUInteger)column {
    [(NSMutableArray*)[_array objectAtIndex:row] setObject:object atIndexedSubscript:column];
}

#pragma mark - Property

- (NSString*)description {
    return [self toString];
}

- (NSString*)debugDescription {
    return [self toString];
}

- (NSUInteger)verticalCount {
    return (_array[0] != nil) ? _array[0].count : 0;
}

- (NSUInteger)horizontalCount {
    return _array.count;
}

#pragma mark - Private

- (NSString*)toString {
    NSMutableString *string = [NSMutableString new];
    
    for (NSArray *innerArray in _array) {
        for (NSObject *object in innerArray) {
            [string appendFormat:@"%@ ", object];
        }
        [string appendString:@"\n"];
    }
    if ([string length] > 0) {
        [string deleteCharactersInRange:NSMakeRange([string length]-1, 1)];
    }
    return string;
}

@end
