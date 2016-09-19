//
//  TutorialViewController.m
//  MyGame
//
//  Created by mac on 9/13/16.
//  Copyright © 2016 robert. All rights reserved.
//

#import "TutorialViewController.h"

@implementation TutorialViewController

-(void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"TUTOIALS";
    
    UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, 200, 30)];
    textLabel.center = self.view.center;
    textLabel.text = @"BUT THERE IS NOTHING";
    
    [self.view addSubview: textLabel];
}
@end
