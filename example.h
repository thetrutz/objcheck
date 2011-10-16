#import <Foundation/Foundation.h>

@interface NSString (reverse)
- (NSString *) reverse;
@end

@interface Example: NSObject {}

+ (NSNumber *) isEven: (NSArray *) args;

+ (NSNumber *) genEven;

+ (NSNumber *) reversible: (NSArray *) args;

@end