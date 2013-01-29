
#import "ObjCheckGen.h"

@implementation Gen

+ (NSNumber *) genNum {
    return [NSNumber numberWithInt: arc4random()];
}

+ (NSNumber *) genBool {
    return [NSNumber numberWithBool: arc4random() % 2 == 0 ];
}

+ (NSNumber *) genChar {
//    return [NSNumber numberWithChar: (char) (arc4random() % 128)];
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
    NSArray* arr = [self genArray: ^() { return (id) [Gen genChar]; }];
    
    NSMutableString* s = [NSMutableString stringWithCapacity: [arr count]];
    
    int i;
    for (i = 0; i < [arr count]; i++) {
        [s appendString: [NSString stringWithFormat: @"%c", [[arr objectAtIndex: i] charValue]]];
    }
    
    return s;
}

@end
