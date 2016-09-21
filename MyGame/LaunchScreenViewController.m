//
//  LaunchScreenViewController.m
//  MyGame
//
//  Created by mac on 9/21/16.
//  Copyright © 2016 robert. All rights reserved.
//

#import "LaunchScreenViewController.h"
#import "PlayBoard.h"

@implementation LaunchScreenViewController


-(void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViews];
    [self initModels];
    
}

-(void)presentFirstViewController {
    [self presentViewController: self.firstViewController animated:YES completion: nil];
}

-(void) initModels {
    
    dispatch_queue_t queue = dispatch_queue_create("initModelsQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^(){
        [[PlayBoard sharedObject] init];
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self presentFirstViewController];
        });
    });
}

- (void)setUpViews {
    UIImage* image = [UIImage imageNamed: @"splash.jpeg"];
    UIImageView* imageView = [[UIImageView alloc]initWithImage: image];
    
    imageView.frame = self.view.frame;
    [self.view addSubview: imageView];
    
    
}
@end
