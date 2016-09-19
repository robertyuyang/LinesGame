//
//  BoardView.m
//  MyGame
//
//  Created by harmonyshoes on 16/9/6.
//  Copyright © 2016年 robert. All rights reserved.
//

#import "BoardView.h"
#import "Common.h"

#import "ShortestPath.h"



@interface BoardView()
{}

//@property (nonatomic, strong) NSMutableArray* ballViewArray;
@property (nonatomic, strong) UIView* currentSelectedBallView;
@property (nonatomic, readwrite) Index currentSelectedBallIndex;

@end
@implementation BoardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:frame];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    
    CGSize size = frame.size;
    [super setFrame:CGRectMake(frame.origin.x, frame.origin.y, MIN(size.width, size.height), MIN(size.width, size.height))];
}

-(void)layoutSubviews {
    
    [super layoutSubviews];

    
    
}



-(Index) getCellIndexAtLocationAt: (CGPoint) locationPt {
    Index cellIndex;
    cellIndex.col = (locationPt.x - self.padding) / self.cellWidth;
    cellIndex.row = (locationPt.y - self.padding) / self.cellWidth;
    return cellIndex;
}



//View

-(void) reinitView {
    self.currentSelectedBallView = nil;
    [self removeAllBallViewsAndClearDict];
    SPSetSize(self.rowCount, self.columnCount);
}
-(void) initView {
    
    SPSetSize(self.rowCount, self.columnCount);
    
    
    
    self.cellWidth = (self.frame.size.width - 2 * self.padding) / self.columnCount;
    
    
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetLineWidth(context,  0.5f);
    
    for(int i = 0; i < self.rowCount + 1; i++) {
        CGContextMoveToPoint(context, self.padding, self.padding + i * self.cellWidth);
        CGContextAddLineToPoint(context, self.frame.size.width - self.padding, self.padding + i * self.cellWidth);
    }
    
    for(int i = 0; i < self.columnCount + 1; i++) {
        CGContextMoveToPoint(context, self.padding + i * self.cellWidth, self.padding);
        CGContextAddLineToPoint(context, self.padding + i * self.cellWidth, self.frame.size.height - self.padding);
    }
    
    CGContextStrokePath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:imageView];
    UIGraphicsEndImageContext();
    
    [self addGestureRecognizer: [[ UITapGestureRecognizer alloc] initWithTarget : self action: @selector(onTapBoard:)]];
}

-(void) removeBallViewAtIndex: (Index) index {
    UIView* ballView = [self dictGetBallViewAtIndex:index];
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(){
                         ballView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                     }completion:^(BOOL finished){
                         [ballView removeFromSuperview];
                     }];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration: 0.2];
//    
//    
//    
//    
//    
//    [UIView commitAnimations];
    
    [self dicRemoveIndex: index ];
    
    SPRemoveBall(index);
}
-(UIView*) addBallViewWithColor : (UIColor*) ballColor atX: (NSUInteger) x andY: (NSUInteger) y {
    
    UIView* newBallView = [super addBallViewWithColor:ballColor atX:x andY:y];
   
    Index index= {y,x};
    SPAddBall(index);
    
    return newBallView;
    
}

-(void) changeBallViewAppearance: (UIView*) ballView selected: (BOOL) selected {
    if(selected) {
        ballView.layer.borderWidth = 5;
        ballView.layer.borderColor = [[UIColor purpleColor] CGColor];
    }
    else {
        ballView.layer.borderWidth = 1;
        ballView.layer.borderColor = [[UIColor blackColor] CGColor];
        
    }
    
}




-(BOOL)moveBallView: (UIView*) ballView
               from: (Index) fromIndex to: (Index) toIndex
         completion: (void(^)(void)) movedCompletion {
    
    NSMutableArray* path = [[NSMutableArray alloc] init];
    SPRemoveBall(fromIndex);//remove ball first, or all the paths from this ball to other ball will be blocked;
    BOOL connected = SPGetShortestPath(fromIndex, toIndex, path);
    
    if(!connected) {
        SPAddBall(fromIndex);//can not move, add ball again;
        NSLog(@"not connected");
        return NO;
    }
    
    [path removeObjectAtIndex:0];
    
    float movementCount = [path count];
    float duration = movementCount * 0.1;
    
    
    //[UIView beginAnimations:nil context:nil];
    //[UIView setAnimationDuration:duration];
    
    
    
    [UIView animateKeyframesWithDuration:duration
                                   delay:0
                                 options:UIViewKeyframeAnimationOptionCalculationModeLinear
                              animations:^(){
        int i = 0;
        for (NSNumber *matrixIndex in path) {
            Index index = SpGetIndexByMatrixIndex([matrixIndex intValue]);
            [UIView addKeyframeWithRelativeStartTime: (float)i / (float)movementCount
                                    relativeDuration: 1.0 / (float)movementCount
                                          animations:^{
                                              ballView.center = [self getCellCenterByIndex: index];
                                          }];
            i++;
            
        }
                              
        
    }
                              completion:^(BOOL finished){
                                  movedCompletion();
                              }];

    
    [self dictchangeIndexFrom:self.currentSelectedBallIndex
                       to:toIndex ofBallView:ballView];
    
    SPAddBall(toIndex);
    
    return YES;
}



//View end



-(void) tapBallView: (UIView*) ballView withIndex: (Index) index {
    
    if(self.currentSelectedBallView == ballView) {
        [self changeBallViewAppearance:ballView selected:NO];
        self.currentSelectedBallView = nil;
    }
    else {
        if(self.currentSelectedBallView) {
            [self changeBallViewAppearance: self.currentSelectedBallView selected:NO];
        }
        
        [self changeBallViewAppearance:ballView selected:YES];
        self.currentSelectedBallView = ballView;
        self.currentSelectedBallIndex = index;
        
    }
}

-(void)tapBlankCell: (Index) toIndex{
    if(self.currentSelectedBallView) {
        
        if(![self moveBallView: self.currentSelectedBallView
                          from: self.currentSelectedBallIndex
                            to:toIndex
                    completion:^(){
                        if(self.delegate) {
                            [self.delegate onBoardMoveFrom:self.currentSelectedBallIndex to: toIndex];
                        }
                        
                        [self changeBallViewAppearance:self.currentSelectedBallView selected:NO];
                        self.currentSelectedBallView = nil;
                    }]) {
            return;//move failed, maybe not connectted;
        }
        
        
    }
}

-(void)onTapBoard: (UITapGestureRecognizer*) tap {
    
    
    CGPoint pt = [tap locationInView: tap.view];
    Index index = [self getCellIndexAtLocationAt:pt];
    
    UIView* ballView = [self dictGetBallViewAtIndex:index];
    if(ballView) {
        [self tapBallView:ballView withIndex: index];
    }
    else {
        [self tapBlankCell:index];
    }
    
    if(self.delegate) {
        [self.delegate onBoardTapByIndexAtRow:index.row andColumn:index.col];
        
    }
    
}

@end
