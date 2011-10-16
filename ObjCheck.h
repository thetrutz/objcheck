#import <Foundation/Foundation.h>

@interface ObjCheck: NSObject {}

+ (id) genNum;
+ (id) genBool;
+ (id) genChar;
+ (id) genArray: (id(^)()) gen;
+ (id) genString;

+ forAll: (id(^)(id)) property withGenerators: (id) generators;

@end