//
//  RandomBallFactory.m
//  MyGame
//
//  Created by harmonyshoes on 16/9/5.
//  Copyright © 2016年 robert. All rights reserved.
//

#import "RandomBallFactory.h"
#import "Ball.h"


@interface RandomBallFactory ()
{}


@property (nonatomic) NSUInteger width;
@property (nonatomic) NSUInteger length;

@end


@implementation RandomBallFactory



-(Ball*) generateNewBall: (NSInteger) range output: (NSUInteger*) index {
    int ballColorIndex = arc4random() % MAXCOLOR;
    Ball* ball = [[Ball alloc] initWithColor: ballColorIndex];
    
    *index = arc4random() % range;
    return ball;
}



-(NSArray*) generateNewBallsWithCount: (NSInteger) count {
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity: count];
    for( int i = 0; i < count; i++) {
        
        int ballColorIndex = arc4random() % MAXCOLOR;
        Ball* ball = [[Ball alloc] initWithColor: ballColorIndex];
        [mutableArray addObject:ball];
    }
    return [mutableArray copy];
}

-(NSArray*) generateNewPositionWithRange: (NSUInteger) range withCount: (NSUInteger) count {
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity: count];
    NSMutableSet *set = [[NSMutableSet alloc] init];
    for(int i = 0; i< count ; i++){
        
        int index = arc4random() % range;
        NSString *indexString =[NSString stringWithFormat: @"%d", index];
        while([set containsObject: indexString]) {
            index = (index++) % (range);
        }
        
        [set addObject: indexString];
        [mutableArray addObject:indexString];
    }
    
    return [mutableArray copy];
}

@end
