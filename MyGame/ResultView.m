//
//  ResultView.m
//  MyGame
//
//  Created by mac on 9/15/16.
//  Copyright © 2016 robert. All rights reserved.
//

#import "ResultView.h"
#import "UIView+Location.h"

@interface ResultView()

@property (nonatomic, strong) UIView* bgView;
@property (nonatomic, strong) UIView* animationSpaceView;
@property (nonatomic, strong) UITextView* nameView;
@property (nonatomic, strong) UILabel* nameTextView;
@property (nonatomic, strong) UILabel* titleView;
@property (nonatomic, strong) UIButton* submitView;
@property (nonatomic, strong) UIDynamicAnimator* animator;

@end

@implementation ResultView

-(UILabel*)titleView {
    
     if(!_titleView) {
        _titleView = [[UILabel alloc] initWithFrame: CGRectMake(20, 5 , 110, 25 )];
        _titleView.text = @"HAHAHAHA";
    }
    
    return _titleView;
    
    
}
-(UIButton*)submitView{
    
    if(!_submitView) {
        _submitView = [[UIButton alloc] initWithFrame: CGRectMake(20, 70 , 80, 25 )];
        [_submitView setTitle:( self.hasNewScore ? @"SUBMIT" : @"RESTART") forState:UIControlStateNormal];
        _submitView.backgroundColor = [UIColor blueColor];
        [_submitView sizeToFit];
        [_submitView addTarget: self action: @selector(onClick) forControlEvents: UIControlEventTouchUpInside];
    }
    
    return _submitView;
}

-(IBAction) onClick {
    
    if(!self.delegate) {
        return;
    }
    if(self.hasNewScore) {
        [self.delegate onNewScoreUserNameInputed: self.nameView.text];
        if(self.nameView.text.length == 0){
            return;
        }
    }
    else{
        [self.delegate onRestart];
    }
}

-(UIView*) animationSpaceView {
    if(!_animationSpaceView) {
        CGFloat width =  self.bounds.size.width;
        CGFloat heigth = self.bounds.size.height / 2 + 50;
        _animationSpaceView = [[UIView alloc] initWithFrame: CGRectMake( 0, 0, width, heigth)];
    }
    
    //_animationSpaceView.alpha = 0.0;
    return _animationSpaceView;
}
-(UIView*) bgView {
    if(!_bgView) {
        CGFloat scrWidth = [UIScreen mainScreen].bounds.size.width;
        _bgView = [[UIView alloc] initWithFrame: CGRectMake(scrWidth * 0.1, 0 , scrWidth * 0.8, 130 )];
        _bgView.backgroundColor = [UIColor whiteColor];
        
    }
    
    //_bgView.alpha = 1.0;
    //[self addSubview: _bgView];
    
    return _bgView;
}

-(UILabel*) nameTextView {
     if(!_nameTextView) {
        CGFloat scrWidth = [UIScreen mainScreen].bounds.size.width;
        _nameTextView = [[UILabel alloc] initWithFrame: CGRectMake(20, 35 , 110, 25 )];
        _nameTextView.text = @"YOUR NAME:";
    }
    
    
    return _nameTextView;
}

-(UITextView*) nameView {
    if(!_nameView) {
        CGFloat scrWidth = [UIScreen mainScreen].bounds.size.width;
        _nameView = [[UITextView alloc] initWithFrame: CGRectMake(20 + 120, 35 , scrWidth * 0.35, 25 )];
        _nameView.layer.borderWidth = 1.0;
        [_nameView.layer setMasksToBounds: YES];
    }
    
    //[self.bgView addSubview: _nameView];
    
    return _nameView;
}

-(void)resetViews {
    if(!self.hasNewScore) {
        self.nameView.hidden = YES;
        self.nameTextView.hidden = YES;
        [self.submitView setTitle: @"RESTART" forState: UIControlStateNormal];
        
    }
    else {
        self.nameView.hidden = NO;
        self.nameTextView.hidden = NO;
        self.nameView.text = @"";
        [self.submitView setTitle: @"SUBMIT" forState: UIControlStateNormal];
    }
    
    if(self.hasNewScore) {
        self.titleView.text = [NSString stringWithFormat: @"NEW SCORE: %lu", (unsigned long)self.newScore];
    }
    else{
        self.titleView.text = @"GAME OVER";
    }
    [self.titleView sizeToFit];
    
    CGRect frame = self.bgView.frame;
    frame.origin.y = 0;
    self.bgView.frame = frame;
    
}
-(void)layoutSubviews {
    //self.alpha = 0.6;
    //self.backgroundColor = [UIColor blackColor];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    [self addSubview: self.animationSpaceView];
    [self.animationSpaceView addSubview: self.bgView];
    [self.bgView addSubview: self.nameView];
    [self.bgView addSubview: self.nameTextView];
    [self.bgView addSubview: self.submitView];
    [self.bgView addSubview: self.titleView];
    
    CGRect frame = self.frame;
    frame.origin.y -= self.bgView.height;
    frame.size.height += self.bgView.height;
    self.frame = frame;
    
    frame = self.animationSpaceView.frame;
    frame.size.height += self.bgView.height;
    self.animationSpaceView.frame = frame;
    
   
    
    self.titleView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem: self.titleView
                                                                 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.bgView
                                                                 attribute:NSLayoutAttributeCenterX multiplier:1.0
                                                                  constant:0.0];
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem: self.titleView
                                                                 attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.bgView
                                                                 attribute:NSLayoutAttributeTop multiplier:1.0
                                                                  constant:10.0];
    
    self.submitView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem: self.submitView
                                                                 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.bgView
                                                                 attribute:NSLayoutAttributeCenterX multiplier:1.0
                                                                  constant:0.0];
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem: self.submitView
                                                                 attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.bgView
                                                                 attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.0
                                                                  constant:-10.0];
    [self.bgView addConstraints: @[constraint, constraint2, constraint3, constraint4]];
    
    [self resetViews];
    
    //[self popUp];

    
}

-(void) popUp {
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView: self.animationSpaceView];
  
    NSArray* items = @[self.bgView];
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems: items];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems: items];
    UIDynamicItemBehavior * itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:items];
    itemBehavior.elasticity= 0.3;
    
    //[gravityBehavior addItem: self.bgView ];
   
    
    [self.animator addBehavior:gravityBehavior];
    [self.animator addBehavior:collisionBehavior];
    [self.animator addBehavior: itemBehavior];
}
@end
