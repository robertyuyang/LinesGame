//
//  Rankings.h
//  MyGame
//
//  Created by mac on 9/18/16.
//  Copyright © 2016 robert. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface RankingsItem : NSObject<NSCoding>
{}

-(instancetype) initWithScore: (NSUInteger) score andName: (NSString*) name;
@property (nonatomic, readonly) NSUInteger score;
@property (nonatomic, strong, readonly) NSString* name;

//NSCoding
-(void)encodeWithCoder:(NSCoder *)aCoder;
-(nullable instancetype)initWithCoder:(NSCoder *)aDecoder;

@end



@interface Rankings : NSObject

@property (atomic, strong, readwrite) NSArray* rankingsArray;//atomic

@property (nonatomic, readonly) NSUInteger highestScore;

@property (nonatomic) BOOL dataLoaded;

-(BOOL) loadData;
-(BOOL) isScoreQuanlified: (NSUInteger) score;
-(BOOL) addNewScoreInRankings: (RankingsItem*) newItem;

@end
