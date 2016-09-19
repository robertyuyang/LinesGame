//
//  Rankings.m
//  MyGame
//
//  Created by mac on 9/18/16.
//  Copyright © 2016 robert. All rights reserved.
//

#import "Rankings.h"
#import "GameConfig.h"


@implementation RankingsItem


-(instancetype) initWithScore: (NSUInteger) score andName: (NSString*) name {
    _score = score;
    _name = name;
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey: @"name"];
    [aCoder encodeObject:[NSNumber numberWithUnsignedInteger:self.score] forKey: @"score"];
}
-(nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]){
        _name = [aDecoder decodeObjectForKey: @"name"];
        _score = [[aDecoder decodeObjectForKey: @"score"] unsignedIntegerValue];
    }
    return self;
}
@end



//RankingsITem



@interface Rankings ()
{}

//@property (nonatomic, strong, readwrite) NSArray* rankingsArray;

@end


@implementation Rankings

@synthesize rankingsArray = _rankingsArray;

-(NSUInteger) highestScore {
    if([self.rankingsArray count] == 0) {
        return 0;
    }
    NSData *data = [self.rankingsArray firstObject];
    RankingsItem *item = [ NSKeyedUnarchiver unarchiveObjectWithData: data];
    if(![item isKindOfClass: [ RankingsItem class]]) {
        return 0;
    }
    
    return item.score;
}

-(BOOL) isScoreQuanlified: (NSUInteger) score {
    
    if(score == 0) {
        return NO;
    }
    
    if([self.rankingsArray count] == 0) {
        return YES;
    }
    
    NSData *data = [self.rankingsArray lastObject];
    
    RankingsItem *item = [ NSKeyedUnarchiver unarchiveObjectWithData: data];
    if(![item isKindOfClass: [ RankingsItem class]]) {
        return NO;
    }
    
    return score >= item.score;
    
}
-(BOOL) addNewScoreInRankings: (RankingsItem*) newItem {
    NSMutableArray* newRankingsArray = [[NSMutableArray alloc] initWithArray: self.rankingsArray];
    BOOL newScoreAddedInRankings = NO;
    
    NSData* newData = [NSKeyedArchiver archivedDataWithRootObject:newItem];
   
    NSData *curData = nil;
    for(NSUInteger i =0; i < [newRankingsArray count]; i++) {
        
        RankingsItem* curItem = [NSKeyedUnarchiver unarchiveObjectWithData: [newRankingsArray objectAtIndex: i ]];
        
        if(curItem && curItem.score <= newItem.score) {
            [newRankingsArray insertObject:newData atIndex:i];
            newScoreAddedInRankings = YES;
            break;
        }
    }
    
    if([newRankingsArray count] > [GameConfig rankingsCount]) {
        [newRankingsArray removeLastObject];
    }
    else if(([newRankingsArray count] < [GameConfig rankingsCount ] ) && !newScoreAddedInRankings) {
        [newRankingsArray addObject: newData];
        newScoreAddedInRankings = YES;
    }
    
    self.rankingsArray = [newRankingsArray copy];
    
    return newScoreAddedInRankings;
    
}

@end