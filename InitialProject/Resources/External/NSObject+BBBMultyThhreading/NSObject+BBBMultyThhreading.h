#import <Foundation/Foundation.h>

@interface NSObject(BBBMultyThhreading)

@property (nonatomic, readonly) dispatch_queue_t bbb_concurrent_queue;
@property (nonatomic, readonly) dispatch_queue_t bbb_serial_queue;


@end
