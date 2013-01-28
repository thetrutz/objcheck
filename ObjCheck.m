#import "ObjCheck.h"
#import <Foundation/Foundation.h>
#import <stdlib.h>
#import "NSArray-Extension.h"

@implementation NSObject (performSelectorWithArgs)

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

@end

@implementation ObjCheck

+ (NSNumber *) genNum {
	return [NSNumber numberWithInt: arc4random()];
}

+ (NSNumber *) genBool {
	return [NSNumber numberWithBool: arc4random() % 2 == 0 ];
}

+ (NSNumber *) genChar {
//	return [NSNumber numberWithChar: (char) (arc4random() % 128)];
    static NSString *const ascii = @" !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
    return @([ascii characterAtIndex:(arc4random()%[ascii length])]);
}

+ (NSArray *) genArray: (id(^)()) gen {
	NSMutableArray* arr = [NSMutableArray array];

	int len = arc4random() % 5;

	int i;
	for (i = 0; i < len; i++) {
		[arr addObject: gen()];
	}

	return arr;
}

+ (NSString *) genString {
	NSArray* arr = [self genArray: ^() { return (id) [ObjCheck genChar]; }];

	NSMutableString* s = [NSMutableString stringWithCapacity: [arr count]];

	int i;
	for (i = 0; i < [arr count]; i++) {
		[s appendString: [NSString stringWithFormat: @"%c", [[arr objectAtIndex: i] charValue]]];
	}

	return s;
}

+ (BOOL)forAll: (id) target withProperty: (SEL) property withGenerators: (NSArray *) generators {
	int i, j;
	for (i = 0; i < 100; i++) {
		NSArray* values = [NSMutableArray array];

		for (j = 0; j < [generators count]; j++) {
			id value = ((id(^)()) [generators objectAtIndex: j])();

			values = [values arrayByAddingObject: value];
		}

		NSNumber* propertyHolds = [target performSelector: property withArgs: values];

		if(![propertyHolds boolValue]) {
            NSString *parameteStr = [[values mapBlock:^(id o){ return [o description]; }] componentsJoinedByString:@"\n"];
            NSString *message = [NSString stringWithFormat:@"*** Failed!\ntarget class %@\nselector %@\nparameters\n%@",[target class], NSStringFromSelector(property),parameteStr];

            NSLog(@"%@",message);

			return NO;
		}
	}

	NSLog(@"+++ OK, passed 100 tests.");
    return YES;
}

@end
