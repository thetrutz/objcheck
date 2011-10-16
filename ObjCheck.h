#import <Foundation/Foundation.h>

@interface NSObject (performSelectorWithArgs)

- (id) performSelector: (SEL) sel withArgs: (NSArray *) args;

@end

@interface ObjCheck: NSObject {}

+ (NSNumber *) genNum;
+ (NSNumber *) genBool;
+ (NSNumber *) genChar;
+ (NSArray *) genArray: (id(^)()) gen;
+ (NSString *) genString;

+ forAll: (NSNumber*(^)(id)) property withGenerators: (NSArray *) generators;

@end