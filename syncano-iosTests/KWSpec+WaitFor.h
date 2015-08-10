#import "KWSpec.h"

@interface KWSpec (WaitFor)

+ (void) waitWithTimeout:(NSTimeInterval)timeout forCondition:(BOOL(^)())conditionalBlock;

@end