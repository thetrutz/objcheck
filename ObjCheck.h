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

+ (void)forAll: (id) target withProperty: (SEL) property withGenerators: (NSArray *) generators;

@end
