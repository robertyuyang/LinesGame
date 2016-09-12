//
//  GameConfig.m
//  MyGame
//
//  Created by mac on 9/9/16.
//  Copyright © 2016 robert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameConfig.h"



@implementation GameConfig


+(int) rowCount {
    return 9;
}


+(int) columnCount {
    return 9;
}

+(int) minEliminateCount {
    return 5;
}

+(int) ballsCountGenerated {
    return 3;
}

+(UIColor* ) getColorByIndex: (BALLCOLOR) colorIndex {
    NSArray* colorArray = @[[UIColor cyanColor],
                            [UIColor magentaColor], [UIColor greenColor],
                            [UIColor orangeColor], [UIColor yellowColor]];
    return colorArray[colorIndex];
}



@end

