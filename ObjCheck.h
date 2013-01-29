#import <Foundation/Foundation.h>

@interface NSObject (performSelectorWithArgs)

- (id) performSelector: (SEL) sel withArgs: (NSArray *) args;
- (void)validateArbitrary;

@end

@interface ObjCheck: NSObject {}

+ (BOOL)forAll: (id) target withProperty: (SEL) property withGenerators: (NSArray *) generators;

@end
