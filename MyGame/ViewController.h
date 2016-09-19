//
//  ViewController.h
//  MyGame
//
//  Created by harmonyshoes on 16/9/5.
//  Copyright © 2016年 robert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardViewObserver.h"
#import "ResultViewObserver.h"

@interface ViewController : UIViewController <BoardViewObserver, ResultViewObserver>

//BoardViewObserver
-(void)onBoardTapByIndexAtRow: (NSUInteger) x andColumn: (NSUInteger) y;

//ResultViewObserver
-(void) onRestart;
-(void) onNewScoreUserNameInputed: (NSString*) name;
@end

