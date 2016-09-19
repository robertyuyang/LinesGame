//
//  ViewController.m
//  MyGame
//
//  Created by harmonyshoes on 16/9/5.
//  Copyright © 2016年 robert. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Location.h"

#import "GameConfig.h"
#import "BoardView.h"
#import "NextBallsBoardView.h"
#import "ResultView.h"
#import "PlayBoard.h"
#import "Common.h"

#import "RankingsViewController.h"
#import "TutorialViewController.h"

//static int rowCount = [GameConfig rowCount];
//static int columnCount = [GameConfig columnCount];

@interface ViewController ()

@property (nonatomic, strong) BoardView* boardView;
@property (nonatomic, strong) NextBallsBoardView* nextBallsBoardView;
@property (nonatomic, strong) PlayBoard* playBoard;
@property (nonatomic, strong) UILabel* scoreValueLabel;
@property (nonatomic, strong) UILabel* highScoreValueLabel;
@property (nonatomic, strong) ResultView* resultView;

@end

@implementation ViewController

-(ResultView*) resultView {
    if(!_resultView) {
        _resultView = [[ResultView alloc] initWithFrame:  self.view.frame];
        _resultView.hidden = YES;
        [self.view addSubview: _resultView];
    }
    return _resultView;
}

@synthesize boardView = _boardView;
-(BoardView*) boardView {
    return _boardView;
}

-(void) setBoardView:(BoardView *)boardView {
    _boardView = boardView;
}

-(PlayBoard*) playBoard {
    if(!_playBoard) {
        self.playBoard = [[PlayBoard alloc] initWithWidth:[GameConfig rowCount]
                                            andLength:[GameConfig columnCount]];
    }
    return _playBoard;
}

-(void) setUpSubviews {
    
    
    //boardview
    int ScreenWidth = [UIScreen mainScreen].bounds.size.width;
    
    
    self.boardView = [[BoardView alloc] initWithFrame:CGRectMake(10, 10,
                                                                 ScreenWidth * 0.9, ScreenWidth * 0.9)];
    NSAssert(self.boardView, @"boardView = nil");
    
    self.boardView.rowCount = [GameConfig rowCount];
    self.boardView.columnCount = [GameConfig columnCount];
    self.boardView.center = self.view.center;
    [self.view addSubview: self.boardView];
    
    [self.boardView initView];

    self.boardView.delegate = self;
    self.resultView.delegate = self;
    
    //next balls board
    self.nextBallsBoardView = [[NextBallsBoardView alloc] init];
    CGFloat viewWidth = self.boardView.cellWidth * [GameConfig ballsCountGenerated];
    self.nextBallsBoardView.frame = CGRectMake(self.view.center.x - viewWidth / 2,
                                               self.boardView.bottom + 15,
                                               viewWidth,
                                               self.boardView.cellWidth);
    //self.nextBallsBoardView.frame.origin.x = self.view.center.x - self.nextBallsBoardView.width;
    
    [self.view addSubview: self.nextBallsBoardView];
    [self.nextBallsBoardView initViewWithCellWidth:self.boardView.cellWidth
                                          andCount:[GameConfig ballsCountGenerated]];
    
    
    UILabel* nextBallsTextLabel = [[UILabel alloc] init];
    nextBallsTextLabel.text = @"NEXT:";
    
    nextBallsTextLabel.frame = CGRectMake(self.nextBallsBoardView.left - 60,
                                          self.nextBallsBoardView.top,
                                          60, self.nextBallsBoardView.height);
    [self.view addSubview: nextBallsTextLabel];
    
    
    //score labels
    UILabel* scoreTextLabel = [[UILabel alloc] init];
    UILabel* scoreValueLabel = [[UILabel alloc] init];
    UILabel* highScoreTextLabel = [[UILabel alloc] init];
    UILabel* highScoreValueLabel = [[UILabel alloc] init];
    scoreTextLabel.text = @"SCORE:";
    scoreValueLabel.text = @"0";
    highScoreTextLabel.text = @"HIGH SCORE:";
    highScoreValueLabel.text = [NSString stringWithFormat: @"%d", self.playBoard.highScore];
    
    int scoreLabelWidth = 70, scoreLabelHeigth = 20, interval = 20;
    int highScoreLabelWidth = 110, highScoreLabelHeigth = 20;
  
    int top = self.boardView.top - scoreLabelHeigth - interval;
    int left = self.boardView.left;
    scoreTextLabel.frame = CGRectMake(left, top,
                                      scoreLabelWidth, scoreLabelHeigth);
   
    left += scoreLabelWidth + interval;
    scoreValueLabel.frame = CGRectMake(left, top,
                                      30, scoreLabelHeigth);
   
    left = self.boardView.right - 30;
    highScoreValueLabel.frame = CGRectMake(left, top,
                                       30, scoreLabelHeigth);
    
    left -= highScoreLabelWidth + interval;
    highScoreTextLabel.frame = CGRectMake(left, top, highScoreLabelWidth, scoreLabelHeigth);
    
    self.scoreValueLabel = scoreValueLabel;
    self.highScoreValueLabel = highScoreValueLabel;
   
    highScoreValueLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHighScoreValueTap:)];
    //tapGesture.numberOfTapsRequired = 1;
    [highScoreValueLabel addGestureRecognizer:tapGesture];

    [self.view addSubview:scoreTextLabel];
    [self.view addSubview:scoreValueLabel];
    [self.view addSubview:highScoreTextLabel];
    [self.view addSubview:highScoreValueLabel];
    
    
    
    
}

-(void) onHighScoreValueTap: (UIGestureRecognizer*) tap {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    UIViewController* viewController = [storyboard instantiateViewControllerWithIdentifier: @"rankingsNav"];
    //RankingsViewController* viewController = [[RankingsViewController alloc] init];
    [viewController setModalPresentationStyle:UIModalPresentationCurrentContext];
    [viewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:viewController animated:YES completion:nil  ];
}

-(void) setUpModels {
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center addObserver: self selector: @selector(onBallRemoved:) name:@"BallRemoved" object:nil];
    [center addObserver: self selector: @selector(onBallsGenerated:) name:@"BallsGenerated" object:nil];
    [center addObserver: self selector: @selector(onBallsDeployed:) name:@"BallsDeployed" object:nil];
    [center addObserver: self selector: @selector(onScoreChanged:) name:@"scoreChanged" object:nil];
    [center addObserver: self selector: @selector(onHighScoreChanged:) name:@"highScoreChanged" object:nil];
    [center addObserver: self selector: @selector(onGameOver:) name:@"GameOver" object:nil];
    [center addObserver: self selector: @selector(onGameOverWithNewScoreInRankings:) name:@"GameOverWithNewScoreInRankings" object:nil];
    
    
    
    NSAssert(self.playBoard, @"playBoard = nil");
    
    
    [self.playBoard startGame];
     
}

-(void) onGameOverWithNewScoreInRankings: (NSNotification*) notification {
  
    self.resultView.hasNewScore = YES;
    self.resultView.newScore = self.playBoard.score;
    self.resultView.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    [self.resultView resetViews];
    [self.resultView popUp];
}


-(void) onGameOver: (NSNotification*) notification {
    self.resultView.hasNewScore = NO;
    self.resultView.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    [self.resultView resetViews];
    [self.resultView popUp];
}

-(void) setUpView {
    
    UIBarButtonItem* restartButton = [[UIBarButtonItem alloc] initWithTitle: @"RESTART"
                                                                    style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(onRestart:)];
    self.navigationItem.leftBarButtonItem = restartButton;
    UIBarButtonItem* howToPlayButton = [[UIBarButtonItem alloc] initWithTitle: @"TUTORIAL"
                                                                    style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(onTutorial:)];
    self.navigationItem.rightBarButtonItem = howToPlayButton;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];

    [self setUpSubviews];
    
    
    [self setUpModels];
    
    
}


-(void)onTutorial: (id)sender {
    [self.navigationController pushViewController:[[TutorialViewController alloc]init] animated:YES];
}
-(void)onRestart: (id)sender {
    [self.boardView reinitView];
    [self.playBoard restartGame];
    
    
    self.resultView.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
}


-(void)onScoreChanged: (NSNotification*) notification {
    NSNumber* num = [notification.userInfo objectForKey: @"score"];
    if(!num){
        return;
    }
    
    self.scoreValueLabel.text = [NSString stringWithFormat: @"%d", [num intValue]];
    
}
-(void)onHighScoreChanged: (NSNotification*) notification {
    NSNumber* num = [notification.userInfo objectForKey: @"highScore"];
    if(!num){
        return;
    }
    
    self.highScoreValueLabel.text = [NSString stringWithFormat: @"%d", [num intValue]];
}

-(void)onBallRemoved: (NSNotification*) notification {
    NSMutableArray* array = [notification.userInfo  objectForKey: @"sameColorMatrixIndexArray"];
    for(NSNumber* num in array){
        Index index = GetIndexByMatrixIndex([num intValue]);
        [self.boardView removeBallViewAtIndex:index];
    }
}

-(void)onBallsDeployed: (NSNotification*) notification {
    
    NSArray* generatedBallsArray  = [notification.userInfo  objectForKey: @"generatedBallsArray"];
    NSArray* deployMatrixIndexArray  = [notification.userInfo  objectForKey: @"deployMatrixIndexArray"];
   
    if(!generatedBallsArray || !deployMatrixIndexArray) {
        return;
    }
    if([generatedBallsArray count] < [deployMatrixIndexArray count]){
        return;
    }
    
    NSEnumerator *ballEnum = [generatedBallsArray objectEnumerator];
    NSEnumerator *indexEnum = [deployMatrixIndexArray objectEnumerator];
    id ballobj = nil, indexobj = nil;
    while((ballobj = [ballEnum nextObject]) && (indexobj = [indexEnum nextObject])) {
        Ball* ball = (Ball*)ballobj;
        if(![ball isKindOfClass: [Ball class]]){
            break;
        }
        if(![indexobj respondsToSelector:@selector(intValue)]){
            break;
        }
        int matrixIndex = [indexobj intValue];
        Index index = GetIndexByMatrixIndex(matrixIndex);
        [self.boardView addBallViewWithColor: [GameConfig getColorByIndex:ball.color]
                                         atX:index.col
                                        andY:index.row];
    }
    
   
}
-(void)onBallsGenerated: (NSNotification*) notification {
    NSArray* newBallsArray =[notification.userInfo objectForKey: @"newBallsArray"];
    if(![newBallsArray isKindOfClass:[NSArray class]]) {
        return;
    }
   
    int i = 0;
    for(Ball* ball in newBallsArray) {
        if(![ball isKindOfClass: [Ball class]]){
            break;
        }
        
        [self.nextBallsBoardView addBallViewWithColor:[GameConfig getColorByIndex: ball.color]
                                                  atX:i++
                                                 andY:0];
    }
    
    
    
    
}

//delegate
-(void)onBoardTapByIndexAtRow: (NSUInteger) row andColumn: (NSUInteger) col {
    Ball* ball = [self.playBoard ballRowIndext:row columnIndex:col];
    if(![ball isKindOfClass: [Ball class]]) {
        return;
    }
    
    
}


-(void) onRestart {
    [self onRestart:nil];
}
-(void) onNewScoreUserNameInputed: (NSString*) name {
    
    [self.playBoard addNewScoreInRankings: self.playBoard.score withName:name];

    
    self.navigationController.navigationBar.hidden = NO;

    RankingsViewController *newvc = [[RankingsViewController alloc]init];
    [newvc setModalPresentationStyle:  UIModalPresentationCurrentContext];
    [self presentViewController:newvc animated:YES completion:nil];
}

-(void)onBoardMoveFrom: (Index) fromIndex to:(Index) toIndex {
    [self.playBoard moveBallFromOldRow:fromIndex.row
                             oldColumn:fromIndex.col
                                newRow:toIndex.row
                             newColumn:toIndex.col];

    //[self onNewScoreInRankings: nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end