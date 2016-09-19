//
//  BoardView.h
//  MyGame
//
//  Created by harmonyshoes on 16/9/6.
//  Copyright © 2016年 robert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardViewObserver.h"
#import "BallBoardSuperView.h"

@interface BoardView : BallBoardSuperView

@property (nonatomic, strong) id<BoardViewObserver> delegate;
@property (nonatomic, readonly) CGFloat cellWidth;

//-(void) setBoardSize: (NSUInteger) width and: (NSUInteger) length);
-(UIView*) addBallViewWithColor : (UIColor*) ballColor atX: (NSUInteger) x andY: (NSUInteger) y;
-(void) removeBallViewAtIndex: (Index) index;
-(void) initView ;
-(void) reinitView ;
@end
