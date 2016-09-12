//
//  BoardViewObserver.h
//  MyGame
//
//  Created by mac on 9/8/16.
//  Copyright © 2016 robert. All rights reserved.
//

#ifndef BoardViewObserver_h
#define BoardViewObserver_h

#import "Common.h"


@protocol BoardViewObserver

-(void)onBoardTapByIndexAtRow: (NSUInteger) row andColumn: (NSUInteger) col;
-(void)onBoardMoveFrom: (Index) fromIndex to:(Index) toIndex;


@end

#endif /* BoardViewObserver_h */
