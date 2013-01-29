#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>

@interface NSObject (ObjCheck)

- (id) performSelector: (SEL) sel withArgs: (NSArray *) args;
- (void)validateArbitrary;

@end

@interface SenTestCase (ObjCheck)

- (void)property:(SEL)property holdsForParameters:(NSArray *)generators;

@end
