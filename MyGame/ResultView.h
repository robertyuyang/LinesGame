//
//  ResultView.h
//  MyGame
//
//  Created by mac on 9/15/16.
//  Copyright © 2016 robert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultViewObserver.h"

@interface ResultView : UIView

@property (nonatomic, readwrite) NSUInteger newScore;
@property (nonatomic, readwrite) BOOL hasNewScore;
@property (nonatomic, strong) id<ResultViewObserver> delegate;


-(void) popUp;
-(void) resetViews;
@end
