
#import <Foundation/Foundation.h>

@interface Gen : NSObject

+ (NSNumber *)genNum;
+ (NSNumber *)genBool;
+ (NSNumber *)genChar;
+ (NSArray  *)genArray:(id(^)())gen;
+ (NSString *)genString;

@end
