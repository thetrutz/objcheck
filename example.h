#import <Foundation/Foundation.h>

@interface NSString (reverse)
- (NSString *) reverse;
@end

@interface Example: NSObject {}

+ (NSNumber *) isEven: (id) args;

+ (NSNumber *) genEven;

+ (NSNumber *) reversible: (id) args;

@end