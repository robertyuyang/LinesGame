//
//  UIView+Location.h
//  MyGame
//
//  Created by mac on 9/11/16.
//  Copyright © 2016 robert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Locatoin)

@property (nonatomic, readonly) CGFloat left;
@property (nonatomic, readonly) CGFloat right;
@property (nonatomic, readonly) CGFloat top;
@property (nonatomic, readonly) CGFloat bottom;
@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;

@end
