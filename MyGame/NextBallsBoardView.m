//
//  NextBallsBoard.m
//  MyGame
//
//  Created by mac on 9/11/16.
//  Copyright © 2016 robert. All rights reserved.
//

#import "NextBallsBoardView.h"


@interface NextBallsBoardView ()
{}



@end
@implementation NextBallsBoardView


-(void)initViewWithCellWidth: (CGFloat) cellWidth andCount: (NSUInteger) count {
    
    
    
//    self.cellWidth = (self.frame.size.width - 2 * self.padding) / self.columnCount;
    self.cellWidth = cellWidth;
    
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetLineWidth(context,  0.5f);
    
    for(int i = 0; i < 2; i++) {
        CGContextMoveToPoint(context, self.padding, self.padding + i * self.cellWidth);
        CGContextAddLineToPoint(context, self.frame.size.width - self.padding, self.padding + i * self.cellWidth);
    }
    
    for(int i = 0; i < count + 1; i++) {
        CGContextMoveToPoint(context, self.padding + i * self.cellWidth, self.padding);
        CGContextAddLineToPoint(context, self.padding + i * self.cellWidth, self.frame.size.height - self.padding);
    }
    
    CGContextStrokePath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:imageView];
    UIGraphicsEndImageContext();
    
}

-(UIView*) addBallViewWithColor : (UIColor*) ballColor atX: (NSUInteger) x andY: (NSUInteger) y {
   
    Index index = {y, x};
    UIView* oldBallView = [self dictGetBallViewAtIndex: index];
    [oldBallView removeFromSuperview];
    UIView* newBallView = [super addBallViewWithColor:ballColor atX:x andY:y];
   
    
    return newBallView;
    
}


//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self setFrame:frame];
//    }
//    return self;
//}
//
//- (void)setFrame:(CGRect)frame{
//    
//    CGSize size = frame.size;
//    [super setFrame:CGRectMake(frame.origin.x, frame.origin.y, MIN(size.width, size.height), MIN(size.width, size.height))];
//}

@end
