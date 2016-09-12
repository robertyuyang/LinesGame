//
//  BallBoardSuperView.h
//  MyGame
//
//  Created by mac on 9/11/16.
//  Copyright © 2016 robert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface BallBoardSuperView : UIView


@property (nonatomic, readwrite) NSUInteger rowCount;
@property (nonatomic, readwrite) NSUInteger columnCount;
@property (nonatomic, readwrite) CGFloat cellWidth;
@property (nonatomic, readonly) CGFloat padding;
@property (nonatomic, readonly) CGFloat transformScale;
@property (nonatomic, strong) NSMutableDictionary* ballViewDict;

- (UIView*) ballView: (UIColor*) ballColor withScale: (float) scale;
-(CGPoint) getCellCenterByIndex: (Index) index;
-(UIView*) addBallViewWithColor : (UIColor*) ballColor atX: (NSUInteger) x andY: (NSUInteger) y;
-(UIView*) dictGetBallViewAtIndex: (Index) index;
-(void) dictsetIndex: (Index)index ofBallView: (UIView*) ballView;
-(void) dictchangeIndexFrom: (Index) fromIndex to: (Index) toIndex ofBallView: (UIView*) ballView;
-(void) dicRemoveIndex: (Index) index;


@end
