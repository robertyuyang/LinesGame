//
//  ShortestPath.m
//  MyGame
//
//  Created by mac on 9/9/16.
//  Copyright © 2016 robert. All rights reserved.
//

#import "ShortestPath.h"


#define MAX_WEIGHT 0X7FFFFFFF
int dijkstra(int n, int adjMatrix[][n], int startV, int endV, int prev[n])
{
    int dist[n]; //dist[i]表示从源到顶点i的最短特殊路径长度
    int mask[n]; //mask[i]标记顶点i是否加入集合 -1表示已加入集合
    //int shortestPath = 0;
    int minWeight = MAX_WEIGHT;
    int minID = 0;
    int i;
    int j;
    int tmp = 0;
    for (i=0; i<n; i++)
    {
        mask[i] = 0; //初始化集合为空集，即没有元素加入
        dist[i] = adjMatrix[startV][i]; //初始化dist[j]
        prev[i] = -1;
        prev[i] = (adjMatrix[startV][i] != MAX_WEIGHT) ? startV : -1;
    }
    //prev[0] = startV;
    // dist[startV] = -1; //起点标记为-1 不被更新
    mask[startV] = -1; //标记源点已加入
    for (i=1; i<n; i++) //最多再加入n-1个顶点
    {
        minWeight = MAX_WEIGHT;
        //寻找下一个待加入的顶点
        for (j=0; j<n; j++)
        {
            if (mask[j]!=-1 && dist[j]<minWeight)
            {
                minWeight = dist[j];
                minID = j;
            }
        }
        
        mask[minID] = -1; //加入顶点
        if (minID == endV) //最后一个节点已加入
        {
            return dist[endV];
        }
        //更新dist[i]
        for (j=0; j<n; j++)
        {
            if (minWeight==MAX_WEIGHT || adjMatrix[minID][j]==MAX_WEIGHT)
                continue;
            tmp = minWeight + adjMatrix[minID][j];
            if(j!=startV && tmp<dist[j]) //起点无须更新
            {
                dist[j] = tmp;
                prev[j] = minID;
            }
        }
    }
    
    return 0;
    
}


static const int MAX_ROWCOUNT = 9;
int gConnectMatrix[MAX_ROWCOUNT * MAX_ROWCOUNT][MAX_ROWCOUNT * MAX_ROWCOUNT];
int gBallMatrix[MAX_ROWCOUNT][MAX_ROWCOUNT];
int gRowCount = 0;
int gColumnCount = 0;
void SPSetSize(int rowCount, int columnCount) {
    
    
    
    
    
    //gConnectMatrix = (int (*)[rowCount]) malloc(rowCount * columnCount * rowCount * columnCount * sizeof(int));
//    gConnectMatrix = (int**)malloc(sizeof(int*) * rowCount * columnCount);
//    for(int i = 0; i < rowCount * columnCount; i++) {
//        gConnectMatrix[i] = (int*)malloc(sizeof(int) * rowCount * columnCount);
//    }
    
    //gBallMatrix = (int (*)[rowCount]) malloc(rowCount * columnCount * sizeof(int));
    
//    gBallMatrix = (int**)malloc(sizeof(int*) * columnCount);
//    for(int i = 0; i < rowCount; i++) {
//        gBallMatrix[i] = (int*)malloc(sizeof(int) * columnCount);
//    }
    
  
    
    
    
    for(int i = 0; i< rowCount; i++){
        for(int j = 0; j < columnCount; j++){
            int selfimtx = i * rowCount + j;
            for(int imtx = 0; imtx < rowCount * columnCount; imtx ++) {
                int weight = MAX_WEIGHT;
                if(imtx == selfimtx) weight = 0;
                else if((j != columnCount - 1) && (imtx - selfimtx == 1)) weight = 1;
                else if((j != 0) && (imtx - selfimtx == -1)) weight = 1;
                else if((i != rowCount - 1) && (imtx - selfimtx == columnCount)) weight = 1;
                else if((i != 0) && (imtx - selfimtx == -1 * columnCount)) weight = 1;
                
                gConnectMatrix[imtx][selfimtx] = gConnectMatrix[selfimtx][imtx] = weight;
                
            }
        }
    }
    
    gRowCount = rowCount;
    gColumnCount = columnCount;
}

int SPGetMatrixIndexByIndex(Index index) {
    return GetMatrixIndexByIndex(index);
}
Index SpGetIndexByMatrixIndex(int matrixIndex) {
    return GetIndexByMatrixIndex(matrixIndex);
}
void SPAddBall(Index index) {
    int imtx = SPGetMatrixIndexByIndex(index);
    for(int i = 0; i< gRowCount * gColumnCount; i++){
        gConnectMatrix[imtx][i] = gConnectMatrix[i][imtx] = MAX_WEIGHT;
    }
    
    gBallMatrix[index.row][index.col] = 1;
    
    
}


void SPRemoveBall(Index index) {
    gBallMatrix[index.row][index.col] = 0;
    
    int selfimtx = SPGetMatrixIndexByIndex(index);
    for(int imtx = 0; imtx < gRowCount * gColumnCount; imtx ++) {
        Index targetballIndex = SpGetIndexByMatrixIndex(imtx);
        if(gBallMatrix[targetballIndex.row][targetballIndex.col] == 1) {
            continue;
        }
        
        int weight = MAX_WEIGHT;
        if(imtx == selfimtx) weight = 0;
        else if((index.col != gColumnCount - 1) && (imtx - selfimtx == 1)) weight = 1;
        else if((index.col != 0) && (imtx - selfimtx == -1)) weight = 1;
        else if((index.row != gRowCount - 1) && (imtx - selfimtx == gColumnCount)) weight = 1;
        else if((index.row != 0) && (imtx - selfimtx == -1 * gColumnCount)) weight = 1;
        
        gConnectMatrix[imtx][selfimtx] = gConnectMatrix[selfimtx][imtx] = weight;
        
    }
}



BOOL SPGetShortestPath(Index fromIndex, Index toIndex,  NSMutableArray* path) {

    int ppp[81];
    int matrix[81][81];
    int rowCount =9, columnCount = 9;
    for(int i = 0; i< rowCount; i++){
        for(int j = 0; j < columnCount; j++){
            int selfimtx = i * rowCount + j;
            for(int imtx = 0; imtx < rowCount * columnCount; imtx ++) {
                int weight = MAX_WEIGHT;
                if(imtx == selfimtx) weight = 0;
                else if((j != columnCount - 1) && (imtx - selfimtx == 1)) weight = 1;
                else if((j != 0) && (imtx - selfimtx == -1)) weight = 1;
                else if((i != rowCount - 1) && (imtx - selfimtx == columnCount)) weight = 1;
                else if((i != 0) && (imtx - selfimtx == -1 * columnCount)) weight = 1;
                
                matrix[imtx][selfimtx] = matrix[selfimtx][imtx] = weight;
                
            }
        }
    }

    
    int shortestPath1 = dijkstra(gRowCount * gColumnCount, matrix, 10, 0, ppp);
    int shortestPath2 = dijkstra(gRowCount * gColumnCount, gConnectMatrix, 10, 0, ppp);
    
    
    
    if(!path) {
        return NO;
    }
    
    
    int* prev = (int*) malloc(sizeof(int) * gRowCount * gColumnCount);
    int startv = SPGetMatrixIndexByIndex(fromIndex);
    int endv = SPGetMatrixIndexByIndex(toIndex);
    int shortestPath = dijkstra(gRowCount * gColumnCount, gConnectMatrix, startv, endv, prev);
    //printf("the shortest path is: %d= ", shortestPath);
    
    if(shortestPath == 0) {
        return 0;
    }
    int tmp = endv;
    do
    {
        [path insertObject:[NSNumber numberWithInt:tmp] atIndex:0];
        //printf("%d <--- ", tmp);
        tmp = prev[tmp];
    }while(tmp != startv);
    [path insertObject:[NSNumber numberWithInt:startv] atIndex:0];
    //printf("%d", startv);
    
    free(prev);
    return shortestPath != 0;
}


