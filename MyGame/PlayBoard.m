//
//  PlayBoard.m
//  MyGame
//
//  Created by harmonyshoes on 16/9/5.
//  Copyright © 2016年 robert. All rights reserved.
//


#import "PlayBoard.h"
#import "GameConfig.h"
#import "Ball.h"
#import "Common.h"
#import "RandomBallFactory.h"
#import "ConcreteRankings.h"

@import Foundation;


@interface PlayBoard()
{}

@property (nonatomic, strong, getter=getCurrentCells) NSMutableArray* cellArray;
@property (nonatomic, strong) id<BallFactory> ballFactory;
@property (nonatomic) NSUInteger score;
@property (nonatomic, strong) NSMutableArray* generatedBallsArray;
@end

@implementation PlayBoard



+(instancetype) sharedObject {
    static id _sharedObject;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedObject = [[PlayBoard alloc] initWithWidth: [ GameConfig columnCount] andLength:[ GameConfig rowCount]];
    });
    
    return _sharedObject;
}


-(Rankings*) localRankings {
    if(!_localRankings) {
        _localRankings = [[LocalRankings alloc] init];
    }
    return _localRankings;
}

-(Rankings*) onlineRankings {
    if(!_onlineRankings) {
        _onlineRankings = [[OnlineRankings alloc] init];
    }
    return _onlineRankings;
}


//-(Rankings*) onlineRankings {
//    if(!_onlineRankings) {
//        _onlineRankings = [[OnlineRankings alloc] init];
//    }
//    return _onlineRankings;
//}
-(NSMutableArray*) generatedBallsArray {
    if(!_generatedBallsArray) {
        _generatedBallsArray = [[NSMutableArray alloc] init];
    }
    return _generatedBallsArray;
}



//
//-(void) setHighScore:(NSUInteger)highScore {
//    _highScore = highScore;
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setInteger:_highScore forKey: @"highScore"];
//    [userDefaults synchronize];
//}
-(NSUInteger) highScore {
    NSUInteger score = self.onlineRankings.highestScore;
    return self.localRankings.highestScore;
}

-(id<BallFactory>) ballFactory {
    if(!_ballFactory) {
        _ballFactory = [[RandomBallFactory alloc] init];
    }
    
    return _ballFactory;
}


-(void)initCells {
    if(![self getCurrentCells]) {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        int rowIndex = 0, columnIndex = 0;
        for(rowIndex = 0; rowIndex < [self length]; rowIndex++) {
            NSMutableArray* newRow = [[NSMutableArray alloc] initWithCapacity: [self width]];
            for(columnIndex = 0; columnIndex < [self width]; columnIndex++) {
                [newRow addObject: [NSNull null]];
            }
            [array addObject: newRow];
        }
        [self setCellArray: array];
        
    }
    else {
        int rowIndex = 0, columnIndex = 0;
        for(rowIndex = 0; rowIndex < [self length]; rowIndex++) {
            for(columnIndex = 0; columnIndex < [self width]; columnIndex++) {
                Index index;
                index.col = columnIndex;
                index.row = rowIndex;
                [self makeBlankCellAt: index];
            }
        }
    }
}

-(void)init {
    [self initCells];
    [self.onlineRankings loadData];
    [self.localRankings loadData];
//    NSLog( @"start to sleep");
//    [NSThread sleepForTimeInterval: 3];
//    NSLog( @"end sleep");
}
-(instancetype) initWithWidth: (NSUInteger) width andLength: (NSUInteger) length  {
    _width = width;
    _length = length;
    
    return self;
}

//-(void) onBallMovedAt: (NSUInteger) newrow
//                  and: (NSUInteger) newcol {
//    //calc
//    
//    //remove ball
//    
//    //generate new ball;
//    [self generateNewBall];
//    
//}


-(void) deployGeneratedBalls {
   
   
    if([self.generatedBallsArray count] == 0){
        return;
    }
    NSMutableArray *blankCellList = [[NSMutableArray alloc] initWithCapacity: _width * _length];
    int curRow = 0, curCol = 0;
    for(NSMutableArray* rowList in _cellArray) {
        for(id cell in rowList) {
            if([cell isKindOfClass: [Ball class]] == NO) {
                Index index = {curRow,curCol};
                
                [blankCellList addObject: [NSNumber numberWithInt:GetMatrixIndexByIndex(index)]];
            }
            curCol++;
        }
        curRow++;
        curCol = 0;
    }
   
    NSMutableArray *deployMatrixIndexArray
    = [[NSMutableArray alloc] initWithCapacity:[ self.generatedBallsArray count]];
    
    NSArray* posArray = [self.ballFactory generateNewPositionWithRange: [blankCellList count]
                                                             withCount: [GameConfig ballsCountGenerated]];
   
    if(!posArray) {
        return;
    }
   
    int i = 0;
    for(id pos in posArray) {
        if([pos respondsToSelector:@selector(intValue)]){
            int indexInList = [pos intValue];
            int matrixIndex = [blankCellList[indexInList] intValue];
            Index newBallPos = GetIndexByMatrixIndex(matrixIndex);
            
            [[[self getCurrentCells] objectAtIndex: newBallPos.row]
                replaceObjectAtIndex: newBallPos.col
                withObject: self.generatedBallsArray[i++]];
            [deployMatrixIndexArray addObject:[NSNumber numberWithInt: matrixIndex]];
        }
    }
    
    
    //TODO verify the ball cannot in line
    
    
    NSMutableDictionary* userinfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     [self.generatedBallsArray copy],@"generatedBallsArray",
                                     [deployMatrixIndexArray copy],@"deployMatrixIndexArray",
                                      nil];
    NSNotification* notification =  [NSNotification notificationWithName: @"BallsDeployed"
                                                                  object: nil
                                                                userInfo: userinfo];
    
    
    [[NSNotificationCenter defaultCenter] postNotification: notification];

    if([posArray count] == [blankCellList count]) {
        [self gameOver];
    }


}
-(void) generateNewBall {
    NSArray *newBallsArray =
    [self.ballFactory generateNewBallsWithCount: [GameConfig ballsCountGenerated]];
   
    if(!newBallsArray) {
        return;
    }
    
    NSMutableDictionary* userinfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     newBallsArray,@"newBallsArray",
                                      nil];
    NSNotification* notification =  [NSNotification notificationWithName: @"BallsGenerated"
                                                                   object: nil
                                                                 userInfo: userinfo];

    
    [[NSNotificationCenter defaultCenter] postNotification: notification];
    
    [self.generatedBallsArray removeAllObjects];
    [self.generatedBallsArray addObjectsFromArray:newBallsArray];
}



-(void) generateNewBall0 {
    //generate new ball in blank cell
    

    
    NSMutableArray *blankCellList = [[NSMutableArray alloc] initWithCapacity: _width * _length];
    int curRow = 0, curCol = 0;
    for(NSMutableArray* rowList in _cellArray) {
        for(id cell in rowList) {
            if([cell isKindOfClass: [Ball class]] == NO) {
                Pos curPos = {curRow,curCol};
                [blankCellList addObject: [NSData dataWithBytes:&curPos length:sizeof(curPos)]];
            }
            curCol++;
        }
        curRow++;
        curCol = 0;
    }
    Ball* newBall = nil;
    NSUInteger newPosIndex;
    //newBall = [self.ballFactory generateNewBall: [blankCellList count] output: &newPosIndex];
    if(!newBall) {
        return;
    }
    
    //TODO verify the ball cannot in line
    NSData* data = blankCellList[newPosIndex];
    Pos newBallPos;
    [data getBytes:&newBallPos length: sizeof(newBallPos)];
    
    [[[self getCurrentCells] objectAtIndex: newBallPos.row] replaceObjectAtIndex: newBallPos.col withObject: newBall];
    
    
    
    NSMutableDictionary* userinfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     [NSNumber numberWithInt:newBallPos.col],@"x",
                                     [NSNumber numberWithInt:newBallPos.row],@"y",
                                     [NSNumber numberWithInt:newBall.color],@"color",  nil];
    NSNotification* notification =  [NSNotification notificationWithName: @"BallGenerated"
                                                                   object: nil
                                                                 userInfo: userinfo];

    
    [[NSNotificationCenter defaultCenter] postNotification: notification];
    //notification;
}

-(BOOL) isBall:(id) ball{
    return [ball isKindOfClass: [Ball class]];
}

-(void) makeBlankCellAt: (Index) index {
    [[[self getCurrentCells] objectAtIndex: index.row] replaceObjectAtIndex: index.col
                                                              withObject: [NSNull null]];
}

-(void) changeScore: (NSUInteger) score {
    NSDictionary* userInfo = [[NSDictionary alloc]
                              initWithObjectsAndKeys: [NSNumber numberWithUnsignedInteger:self.score] , @"score", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"scoreChanged"
                                                         object:nil
                                                       userInfo:userInfo];
    
    if(self.score > self.highScore) {
//        self.highScore = self.score;
    NSDictionary* userInfo = [[NSDictionary alloc]
                              initWithObjectsAndKeys: [NSNumber numberWithUnsignedInteger:self.score] , @"highScore", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"highScoreChanged"
                                                         object:nil
                                                       userInfo:userInfo];
    
    } 
}
-(void) calcScore: (int) sameColorBallCount {
    self.score += sameColorBallCount * (sameColorBallCount - 3);
    [self changeScore: self.score];
}
-(void) calcAtBallMovedToRowIndex: (NSUInteger) newrow
                      ColumnIndex: (NSUInteger) newcol {
    Ball* ball = [[[self getCurrentCells] objectAtIndex: newrow] objectAtIndex: newcol];
   
    
    NSMutableArray *curDirSameColorBallArray = [[NSMutableArray alloc] init];
    NSMutableArray *sameColorBallArray = [[NSMutableArray alloc] init];
    
    BOOL (^check)(int row, int col);
    check =  ^(int rowIndex, int columnIndex){
        Ball* curBall = [self ballRowIndext: rowIndex columnIndex: columnIndex];
        if([self isBall:curBall] && curBall.color == ball.color) {
            Index index = {rowIndex, columnIndex};
            int matrixIndex = GetMatrixIndexByIndex(index);
            [curDirSameColorBallArray addObject:[NSNumber numberWithInt:matrixIndex]];
            return YES;
        }
        else {
            return NO;
        }
        
    };
    
    for(int rowIndex = newrow,  columnIndex = newcol - 1; columnIndex >= 0; columnIndex--){
        if(!check(rowIndex, columnIndex)) {
            break;
        }
    }
    for(int rowIndex = newrow, columnIndex = newcol + 1; columnIndex < self.width ; columnIndex++){
        if(!check(rowIndex, columnIndex)) {
            break;
        }
    }
    if([curDirSameColorBallArray count] >= ([GameConfig minEliminateCount] - 1)) {
        [sameColorBallArray addObjectsFromArray:curDirSameColorBallArray];
    }
    [curDirSameColorBallArray removeAllObjects];

    for(int columnIndex = newcol, rowIndex = newrow - 1; rowIndex >= 0; rowIndex--){
        if(!check(rowIndex, columnIndex)) {
            break;
        }
    }
    for(int columnIndex = newcol, rowIndex = newrow + 1; rowIndex < self.length ; rowIndex++){
        if(!check(rowIndex, columnIndex)) {
            break;
        }
    }
    if([curDirSameColorBallArray count] >= ([GameConfig minEliminateCount] - 1)) {
        [sameColorBallArray addObjectsFromArray:curDirSameColorBallArray];
    }
    [curDirSameColorBallArray removeAllObjects];
    
    for(int columnIndex = newcol - 1, rowIndex = newrow - 1;
        rowIndex >= 0 && columnIndex >= 0;
        rowIndex--, columnIndex--){
        if(!check(rowIndex, columnIndex)) {
            break;
        }
    }
    for(int columnIndex = newcol + 1, rowIndex = newrow + 1;
        rowIndex < self.length && columnIndex < self.width;
        rowIndex++, columnIndex++){
        if(!check(rowIndex, columnIndex)) {
            break;
        }
    }
    if([curDirSameColorBallArray count] >= ([GameConfig minEliminateCount] - 1)) {
        [sameColorBallArray addObjectsFromArray:curDirSameColorBallArray];
    }
    [curDirSameColorBallArray removeAllObjects];
   
    for(int columnIndex = newcol + 1, rowIndex = newrow - 1;
        rowIndex >= 0 && columnIndex < self.width;
        rowIndex--, columnIndex++){
        if(!check(rowIndex, columnIndex)) {
            break;
        }
    }
    for(int columnIndex = newcol - 1, rowIndex = newrow + 1;
        rowIndex < self.length && columnIndex >= 0;
        rowIndex++, columnIndex--){
        if(!check(rowIndex, columnIndex)) {
            break;
        }
    }
    if([curDirSameColorBallArray count] >= ([GameConfig minEliminateCount] - 1)) {
        [sameColorBallArray addObjectsFromArray:curDirSameColorBallArray];
    }
    [curDirSameColorBallArray removeAllObjects];
   
    
    
    //NSLog(@"same colr ball count: %d", [sameColorBallArray count]);
    if([sameColorBallArray count] > 0) {
        
        Index curIndex = {newrow, newcol};
        int matrixIndex = GetMatrixIndexByIndex(curIndex);
        [sameColorBallArray addObject:[NSNumber numberWithInt:matrixIndex]];
        
        for(NSNumber* num in sameColorBallArray) {
            Index index = GetIndexByMatrixIndex([num intValue]);
            [self makeBlankCellAt:index];
        }
        
        
        NSMutableDictionary* userinfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         sameColorBallArray, @"sameColorMatrixIndexArray",
                                         nil];
        NSNotification* notification =  [NSNotification notificationWithName: @"BallRemoved"
                                                                      object: nil
                                                                    userInfo: userinfo];
        
        
        [[NSNotificationCenter defaultCenter] postNotification: notification];
        
        [self calcScore:[sameColorBallArray count]];
    }
    
}

-(void) moveBallFromOldRow: (NSUInteger) oldrow
                 oldColumn: (NSUInteger) oldcol
                    newRow: (NSUInteger) newrow
                 newColumn: (NSUInteger) newcol {
    
    //change ball postion
    Ball* ball = [[[self getCurrentCells] objectAtIndex: oldrow] objectAtIndex: oldcol];
    Ball* newPlace = [[[self getCurrentCells] objectAtIndex: newrow] objectAtIndex: newcol];
    if(![self isBall:ball] || [self isBall:newPlace]) {
        return;
    }
    
    [[[self getCurrentCells] objectAtIndex: newrow] replaceObjectAtIndex: newcol
                                                              withObject: ball];
    [[[self getCurrentCells] objectAtIndex: oldrow] replaceObjectAtIndex: oldcol
                                                              withObject: [NSNull null]];
    
    //calc
    [self calcAtBallMovedToRowIndex:newrow ColumnIndex:newcol];
    
    //add new ball;
    [self nextStep];
    
}

-(void)nextStep {
    [self deployGeneratedBalls];
    [self generateNewBall];
}



-(void) restartGame {

    self.score = 0;
    [self changeScore: self.score];
    
    
    [self initCells];
   
    self.generatedBallsArray = nil;
    [self startGame];
    
}

-(void) startGame  {
    [self nextStep];
    [self nextStep];
//    for(int i = 0; i< 15; i++) {
//        [self nextStep];
//    }
}

-(void) gameOver {
    if([self.localRankings isScoreQuanlified:self.score]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName: @"GameOverWithNewScoreInRankings" object: nil];
        //[self.localRankings addNewScoreInRankings:self.score];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName: @"GameOver" object: nil];
    }
}

-(void)addNewScoreInRankings: (NSUInteger) score withName: (NSString*) name {
    RankingsItem* item = [[RankingsItem alloc]initWithScore: score andName: name];
    [self.localRankings addNewScoreInRankings: item];
    
}

-(Ball*) ballRowIndext: (NSUInteger) row
               columnIndex: (NSUInteger) col {
    Ball* ball = [[[self getCurrentCells] objectAtIndex: row] objectAtIndex: col];
    return ball;
}



-(BOOL) isCellEmptyAtRowIndex:(NSUInteger) row
                  columnIndex: (NSUInteger) col {
    return [[self ballRowIndext: row columnIndex: col] isKindOfClass: [Ball class]];
}

@end
