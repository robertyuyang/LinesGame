//
//  Common.h
//  MyGame
//
//  Created by mac on 9/8/16.
//  Copyright © 2016 robert. All rights reserved.
//

#ifndef Common_h
#define Common_h

typedef struct _Pos {
    int row;
    int col;
}Pos, Index;

int GetMatrixIndexByIndex(Index index) ;
Index GetIndexByMatrixIndex(int matrixIndex) ;
#endif /* Common_h */
