#import "ObjCheck.h"
#import <Foundation/Foundation.h>
#import <stdlib.h>
#import "NSArray-Extension.h"
#import "NSObject+SmartDescription.h"

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

@implementation NSObject (ObjCheck)

- (id) performSelector: (SEL) sel withArgs: (NSArray *) args {
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature: [self methodSignatureForSelector: sel]];
    [inv setSelector: sel];
    [inv setTarget: self];

    int i;
    for (i = 0; i < [args count]; i++) {
        id a = [args objectAtIndex: i];
        [inv setArgument: &a atIndex: 2 + i]; // 0 is target, 1 i cmd-selector
    }

    [inv invoke];

    NSNumber *r;
    [inv getReturnValue: &r];

    return r;
}

- (void)validateArbitrary {
    NSArray *propertiesWithoutValue = [[self mapProp:^id(objc_property_t prop, char propType, NSString *propName) {
        return propType == @encode(id)[0]         // is an object-property (not a primitive type)
            && [self valueForKey:propName] == nil // property is empty
             ? propName : nil;
    }] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return evaluatedObject != [NSNull null];
    }]];
    // todo throw an exception
    if ([propertiesWithoutValue count]) {
        NSLog(@"%s: Not all properties of instance %@ of class <%@> are filled with sample data (they should be in order for the tests to have any significance). Please write generators for the following properties:\n%@",__PRETTY_FUNCTION__, self, [self class], propertiesWithoutValue);
        NSAssert(NO,@"");
    }
}

@end

@implementation SenTestCase (ObjCheck)

- (void)property:(SEL)property holdsForParameters:(NSArray *)generators {
    int i, j;
    for (i = 0; i < 100; i++) {
        NSArray* values = [NSMutableArray array];

        for (j = 0; j < [generators count]; j++) {
            id value = ((id(^)()) [generators objectAtIndex: j])();

            values = [values arrayByAddingObject: value];
        }

        NSNumber* propertyHolds = [self performSelector: property withArgs: values];
        STAssertTrue([propertyHolds boolValue],@"*** Failed!\nproperty: %@\nparameters\n%@", NSStringFromSelector(property),[[values mapBlock:^(id o){ return [o description]; }] componentsJoinedByString:@"\n"]);
    }

    NSLog(@"+++ OK, %@ passed 100 tests.",NSStringFromSelector(property));
}

@end
