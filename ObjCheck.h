#import <Foundation/Foundation.h>

@interface ObjCheck: NSObject {}

+ (NSNumber *) genNum;
+ (NSNumber *) genBool;
+ (NSNumber *) genChar;
+ (NSArray *) genArray: (id(^)()) gen;
+ (NSString *) genString;

+ forAll: (NSNumber*(^)(id)) property withGenerators: (id) generators;

@end