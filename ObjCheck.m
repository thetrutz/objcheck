#import "ObjCheck.h"
#import <Foundation/Foundation.h>
#import <stdlib.h>

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
	return [NSNumber numberWithChar: (char) (arc4random() % 128)];
}

+ (NSArray *) genArray: (id(^)()) gen {
	NSMutableArray* arr = [NSMutableArray array];

	int len = arc4random() % 100;

	int i;
	for (i = 0; i < len; i++) {
		[arr addObject: gen()];
	}

	return arr;
}

+ (NSString *) genString {
	NSArray* arr = (NSArray*) [self genArray: ^() { return (id) [ObjCheck genChar]; }];

	NSString* s = [NSMutableString stringWithCapacity: [arr count]];

	int i;
	for (i = 0; i < [arr count]; i++) {
		s = [s stringByAppendingString: [NSString stringWithFormat: @"%c", [[(NSArray*) arr objectAtIndex: i] charValue]]];
	}

	return s;
}

+ forAll: (NSNumber*(^)(id)) property withGenerators: (NSArray *) generators {
	int i, j;
	for (i = 0; i < 100; i++) {
		NSArray* values = [NSMutableArray array];

		for (j = 0; j < [generators count]; j++) {
			id value = ((id(^)()) [generators objectAtIndex: j])();

			values = [values arrayByAddingObject: value];
		}

		NSNumber* propertyHolds = property(values);

		if(![propertyHolds boolValue]) {
			printf("*** Failed!\n%s\n", [[values description] UTF8String]);

			return;
		}
	}

	printf("+++ OK, passed 100 tests.\n");
}

@end