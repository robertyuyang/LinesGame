//
//  ShortestPath.h
//  MyGame
//
//  Created by mac on 9/9/16.
//  Copyright © 2016 robert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"



void SPSetSize(int rowCount, int columnCount);
void SPAddBall(Index index);
void SPRemoveBall(Index index);
Index SpGetIndexByMatrixIndex(int matrixIndex);
BOOL SPGetShortestPath(Index fromIndex, Index toIndex, NSMutableArray* path);


