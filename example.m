#import "example.h"
#import "ObjCheck.h"
#import <Foundation/Foundation.h>

@implementation NSString (reverse)

// From Mac Developer Tips
// http://macdevelopertips.com/objective-c/objective-c-categories.html
- (NSString *) reverse {
	NSString *result;

	int len = [self length];

	result = [NSMutableString stringWithCapacity: len];

	while (len > 0) {
		result = [result stringByAppendingString: [NSString stringWithFormat: @"%c", [self characterAtIndex: --len]]];
	}

	return result;
}

@end

@implementation Example

+ (NSNumber *) isEven: (id) args {
	NSNumber* i = [(NSArray*) args objectAtIndex: 0];

	BOOL b = [i intValue] % 2 == 0;

	return [NSNumber numberWithBool: b];
}

+ (NSNumber *) genEven {
	int i = [(NSNumber*)[ObjCheck genNum] intValue];

	if(i % 2 != 0) {
		i++;
	}

	return [NSNumber numberWithInt: i];
}

+ (NSNumber *) reversible: (id) args {
	NSString* s = [(NSArray*) args objectAtIndex: 0];
	NSString* r = [s reverse];
	NSString* s2 = [r reverse];

	BOOL b = [s isEqualToString: s2];

	return [NSNumber numberWithBool: b];
}

@end

int main(int argc, char **argv) {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	NSArray* gs = [NSMutableArray array];
	gs = [gs arrayByAddingObject: ^() { return [ObjCheck genNum]; }];
	
	// Are all integers even?
	[ObjCheck forAll: ^(id args) { return [Example isEven: args]; } withGenerators: gs];
	
	NSArray* gs2 = [NSMutableArray array];
	gs2 = [gs2 arrayByAddingObject: ^() { return [Example genEven]; }];
	
	// Are all even integers even?
	[ObjCheck forAll: ^(id args) { return [Example isEven: args]; } withGenerators: gs2];

	NSArray* gs3 = [NSMutableArray array];
	gs3 = [gs3 arrayByAddingObject: ^() { return [ObjCheck genString]; }];

	// Are all strings reversible?
	[ObjCheck forAll: ^(id args) { return [Example reversible: args]; } withGenerators: gs3];

	[pool drain];

	return 0;
}