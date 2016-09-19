//
//  ConcreteRankings.m
//  MyGame
//
//  Created by mac on 9/18/16.
//  Copyright © 2016 robert. All rights reserved.
//

#import "ConcreteRankings.h"


@interface LocalRankings()

//@property (nonatomic, strong, readwrite) NSArray* rankingsArray;
@end


@implementation LocalRankings
//@synthesize rankingsArray = _rankingsArray;

-(NSArray*) rankingsArray {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        super.rankingsArray = [userDefaults objectForKey: @"rankingsArray"];
        if(!super.rankingsArray) {
            super.rankingsArray = [[NSArray alloc]init];
        }
    });
    
    return super.rankingsArray;
}

-(void) setRankingsArray:(NSArray *)rankingsArray {
    super.rankingsArray = rankingsArray;
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject: rankingsArray forKey: @"rankingsArray"];
    [userDefaults synchronize];
    
}
@end
