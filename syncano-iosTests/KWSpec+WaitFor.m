#import "KWSpec+WaitFor.h"

@implementation KWSpec (WaitFor)

+ (void) waitWithTimeout:(NSTimeInterval)timeout forCondition:(BOOL(^)())conditionalBlock {
    NSDate *timeoutDate = [[NSDate alloc] initWithTimeIntervalSinceNow:timeout];
    while (conditionalBlock() == NO) {
        if ([timeoutDate timeIntervalSinceDate:[NSDate date]] < 0) {
            return;
        }
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
}

@end