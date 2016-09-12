//
//  Ball.h
//  MyGame
//
//  Created by harmonyshoes on 16/9/5.
//  Copyright © 2016年 robert. All rights reserved.
//

#ifndef Ball_h
#define Ball_h

#import <Foundation/Foundation.h>
#import "GameConfig.h"




//Ball
@interface Ball: NSObject
{
    BALLCOLOR _color;
    NSUInteger _shape;
}

@property (nonatomic, readonly) BALLCOLOR color;
@property (nonatomic, readonly) NSUInteger shape;

-(instancetype) initWithColor: (BALLCOLOR) color;

@end

#endif /* Ball_h */


