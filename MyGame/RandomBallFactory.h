//
//  RandomBallFactory.h
//  MyGame
//
//  Created by harmonyshoes on 16/9/5.
//  Copyright © 2016年 robert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BallFactory.h"

@interface RandomBallFactory : NSObject <BallFactory>

-(Ball*) generateNewBall: (NSInteger) range output: (NSUInteger*) index;
-(NSArray*) generateNewBallsWithCount: (NSInteger) count;
-(NSArray*) generateNewPositionWithRange: (NSUInteger) range withCount: (NSUInteger) count;


@end
