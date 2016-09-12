//
//  ViewController.h
//  MyGame
//
//  Created by harmonyshoes on 16/9/5.
//  Copyright © 2016年 robert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardViewObserver.h"

@interface ViewController : UIViewController <BoardViewObserver>

-(void)onBoardTapByIndexAtRow: (NSUInteger) x andColumn: (NSUInteger) y;
@end

