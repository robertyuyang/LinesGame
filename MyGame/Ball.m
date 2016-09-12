
#import "Ball.h"



@implementation Ball 

@synthesize color = _color;
@synthesize shape = _shape;

-(instancetype) initWithColor: (BALLCOLOR) color {
    _color = color;
    _shape = 0;
    return self;
}

-(NSString*) description {
    NSArray *colorName = [[NSArray alloc] initWithObjects: @"(Blue)", @"(Red)", @"(Green)", @"(Black)", @"(Yellow)", nil];
    return (NSString*)[colorName objectAtIndex: _color];
}
   
@end





