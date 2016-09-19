//
//  BallBoardSuperView.m
//  MyGame
//
//  Created by mac on 9/11/16.
//  Copyright © 2016 robert. All rights reserved.
//

#import "BallBoardSuperView.h"

@interface BallBoardSuperView()
{}


@end


@implementation BallBoardSuperView

- (NSDictionary*) ballViewDict {
    if(!_ballViewDict) {
        _ballViewDict = [[NSMutableDictionary alloc] init];
    }
    return _ballViewDict;
}

-(CGFloat) padding {
    return 0;
}

-(CGFloat) transformScale{
    return 0.1;
}


-(UIView*) dictGetBallViewAtIndex: (Index) index {
    NSString *key = [self makeKeyByIndex:index];
    
    UIView* ballView = [self.ballViewDict objectForKey: key];
    return ballView;
}

-(void) dictsetIndex: (Index)index ofBallView: (UIView*) ballView {
    NSString *key = [self makeKeyByIndex:index];
    [self.ballViewDict setValue:ballView
                         forKey:key];
}

-(void) dictchangeIndexFrom: (Index) fromIndex to: (Index) toIndex ofBallView: (UIView*) ballView {
    NSString *key = [self makeKeyByIndex:fromIndex];
    [self.ballViewDict removeObjectForKey:key];
    [self dictsetIndex:toIndex ofBallView:ballView];
    

}

-(void) dicRemoveIndex: (Index) index {
    NSString *key = [self makeKeyByIndex:index];
    [self.ballViewDict removeObjectForKey:key];
}

-(NSString*) makeKeyByIndex: (Index) index {
    return [NSString stringWithFormat: @"%d",( index.row * self.columnCount + index.col )];
}



- (UIView*) ballView: (UIColor*) ballColor withScale: (float) scale{
    
    UIView *ballView = [[UIView alloc] initWithFrame: CGRectMake(0, 0,
                                                                 self.cellWidth * 0.8 ,
                                                                 self.cellWidth * 0.8 )];
    ballView.layer.cornerRadius = ballView.frame.size.width * 0.5;
    ballView.backgroundColor = ballColor;
    ballView.layer.borderWidth = 1;
    ballView.layer.borderColor = [[UIColor blackColor] CGColor];
    ballView.transform = CGAffineTransformMakeScale(scale, scale);
    
    return ballView;
    
}



-(CGPoint) getCellCenterByIndex: (Index) index {
    CGPoint pt;
    pt.x = self.padding + (index.col + 0.5) * self.cellWidth;
    pt.y = self.padding + (index.row + 0.5) * self.cellWidth;
    return pt;
}

-(UIView*) addBallViewWithColor : (UIColor*) ballColor atX: (NSUInteger) x andY: (NSUInteger) y {
    UIView* newBallView = [self ballView: ballColor withScale: self.transformScale];
    if(!newBallView) {
        return nil;
    }
    
    Index index = {y, x};
    
    
    newBallView.center = [self getCellCenterByIndex: index];
    
    
    [self addSubview: newBallView];
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration: 0.2];
    
    newBallView.transform = CGAffineTransformMakeScale(1, 1),
    
    
    [UIView commitAnimations];
    
    
    [self dictsetIndex:index ofBallView:newBallView];
    
    return newBallView;
    
}


-(void) removeAllBallViewsAndClearDict {
    for(NSString* key in self.ballViewDict) {
        UIView* ballView = [self.ballViewDict objectForKey: key];
        if(ballView) {
            [ballView removeFromSuperview];
            
        }
    }
    [self.ballViewDict removeAllObjects];
    
}


@end
