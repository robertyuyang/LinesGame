//
//  PlayBoard.h
//  MyGame
//
//  Created by harmonyshoes on 16/9/5.
//  Copyright © 2016年 robert. All rights reserved.
//

#ifndef PlayBoard_h
#define PlayBoard_h



#import <Foundation/Foundation.h>

#import "Ball.h"

//@PlayBoard

@interface PlayBoard : NSObject
{
    NSUInteger _width;
    NSUInteger _length;
    NSMutableArray* _cellArray;
}

@property (nonatomic, readonly) NSUInteger width;
@property (nonatomic, readonly) NSUInteger length;

@property (nonatomic, readonly) NSUInteger highScore;
@property (nonatomic, readonly) NSUInteger score;


-(instancetype) initWithWidth: (NSUInteger) width andLength: (NSUInteger) length;


-(void) moveBallFromOldRow: (NSUInteger) row
                 oldColumn: (NSUInteger) col
                    newRow: (NSUInteger) row
                 newColumn: (NSUInteger) col;
-(Ball*) ballRowIndext: (NSUInteger) row
               columnIndex: (NSUInteger) col;
-(BOOL) isCellEmptyAtRowIndex:(NSUInteger) row
                columnIndex: (NSUInteger) col;


-(void)addNewScoreInRankings: (NSUInteger) score withName: (NSString*) name;
-(void) startGame;
-(void) restartGame;

@end


#endif /* PlayBoard

_h */
