//
//  BallFactory.h
//  MyGame
//
//  Created by harmonyshoes on 16/9/5.
//  Copyright © 2016年 robert. All rights reserved.
//

#ifndef BallFactory_h
#define BallFactory_h

#import <Foundation/Foundation.h>
#import "Ball.h"

@protocol BallFactory

@required
//-(Ball*) generateNewBall1: (NSInteger) range output: (NSUInteger*) index;
-(NSArray*) generateNewBallsWithCount: (NSInteger) count;
-(NSArray*) generateNewPositionWithRange: (NSUInteger) range withCount: (NSUInteger) count;

@end

#endif /* BallFactory_h */
