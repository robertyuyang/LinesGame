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

-(BOOL)loadData {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* rankingsArrayInUserDefualts = [userDefaults objectForKey: @"rankingsArray"];
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:[rankingsArrayInUserDefualts count]];
    for(NSData* data in rankingsArrayInUserDefualts) {
        RankingsItem* item  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [mutableArray addObject: item];
    }
    
    super.rankingsArray = [mutableArray copy];
    return YES;
}
-(NSArray*) rankingsArray {
    if(self.dataLoaded) {
        return super.rankingsArray;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self loadData];
    });
    
    return super.rankingsArray;
}

-(void) setRankingsArray:(NSArray *)rankingsArray {
    super.rankingsArray = rankingsArray;
    
    NSMutableArray* rankingsArrayToWrite = [[NSMutableArray alloc] initWithCapacity: [super.rankingsArray count]];
    for(RankingsItem* item in super.rankingsArray){
        NSData* data = [NSKeyedArchiver archivedDataWithRootObject:item];
        [rankingsArrayToWrite addObject: data];
    }
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject: [rankingsArrayToWrite copy] forKey: @"rankingsArray"];
    [userDefaults synchronize];
    
}
@end

@interface OnlineRankings()


@end

@implementation OnlineRankings

-(BOOL) loadData {
   
    NSCondition *condition = [[NSCondition alloc] init];
    
    NSURL* url = [[NSURL alloc] initWithString: @"http://macdemacbook-pro.local:8000/ra123.json"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:3.0];
   // NSURLRequest *request = [[NSURLRequest alloc] initinitWithURL:url];
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration: sessionConfig];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"get request completed");
        if(!error){
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSArray *jsonRankingsArray = [dict objectForKey: @"rankings"];
            if(jsonRankingsArray && [jsonRankingsArray isKindOfClass: [NSArray class]]) {
                NSUInteger count = [jsonRankingsArray count];
                
                NSMutableArray* mutableArray = [[NSMutableArray alloc] initWithCapacity: count];
                for(NSDictionary *jsonItem in jsonRankingsArray) {
                    NSString* itemname;
                    NSUInteger itemscore;
                    NSString* name = [jsonItem objectForKey: @"name"];
                    if(name && [name isKindOfClass: [NSString class]]  ) {
                        itemname = name;
                    }
                    id score = [jsonItem objectForKey: @"score"];
                    if(score && [score respondsToSelector: @selector(intValue)]) {
                        itemscore = [score intValue];
                    }
                    
                    RankingsItem *item = [[RankingsItem alloc] initWithScore:itemscore andName: itemname];
                    [mutableArray addObject: item];
                }
                
                if([mutableArray count] > 0) {
                    super.rankingsArray = mutableArray;
                    self.dataLoaded = YES;
                }
                
                NSLog(@"%d records in online rankings", [mutableArray count]);
            }
            
            
        }
        [condition signal];
    }];
    [task resume];
    
    
    [condition wait];
    
    return self.dataLoaded;
    
}

-(NSArray*) rankingsArray {
    
    if(self.dataLoaded && super.rankingsArray) {
        return super.rankingsArray;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self loadData];
    });
    
    return super.rankingsArray;
}

-(void) setRankingsArray:(NSArray *)rankingsArray {
    super.rankingsArray = rankingsArray;
    //access internet service.
}
@end


