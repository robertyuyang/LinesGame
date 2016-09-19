//
//  Config.h
//  MyGame
//
//  Created by mac on 9/8/16.
//  Copyright © 2016 robert. All rights reserved.
//

#ifndef Config_h
#define Config_h


#import <UIKit/UIColor.h>

typedef enum{
    BLUE = 0,
    RED,
    GREEN,
    ORANGE,
    YELLOW,
    MAXCOLOR
} BALLCOLOR;

@interface GameConfig :NSObject
{
    
}

+(int) rowCount;


+(int) columnCount;

+(int) minEliminateCount;

+(int) ballsCountGenerated;

+(int) rankingsCount;

+(UIColor* ) getColorByIndex: (BALLCOLOR) colorIndex ;
@end




#endif /* Config_h */
