#import "NSObject+BBBMultyThhreading.h"

@implementation NSObject(BBBMultyThhreading)

static dispatch_queue_t queue;

#pragma mark - Properties

- (dispatch_queue_t)bbb_concurrent_queue {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create([self bbb_identifierWith:@"concurrent"], DISPATCH_QUEUE_CONCURRENT);
    });
    
    return queue;
}

- (dispatch_queue_t)bbb_serial_queue {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create([self bbb_identifierWith:@"serial"], DISPATCH_QUEUE_SERIAL);
    });
    
    return queue;
}

#pragma mark - Private

- (const char *)bbb_identifierWith:(NSString *)appendance {
    NSString *bundleIdentifier  = [[NSBundle mainBundle] bundleIdentifier];
    NSString *className         = NSStringFromClass([self class]);
    NSString *identifier        = [NSString stringWithFormat:@"%@.%@.%@", bundleIdentifier, className, appendance];
    
    return [identifier UTF8String];
}

@end
