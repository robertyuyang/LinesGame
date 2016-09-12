//
//  Common.m
//  MyGame
//
//  Created by mac on 9/9/16.
//  Copyright © 2016 robert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "GameConfig.h"


int GetMatrixIndexByIndex(Index index) {
    return index.row * [GameConfig columnCount] + index.col;
}
Index GetIndexByMatrixIndex(int matrixIndex) {
    Index index;
    index.row = matrixIndex / [GameConfig columnCount];
    index.col = matrixIndex % [GameConfig columnCount];
    return index;
}
