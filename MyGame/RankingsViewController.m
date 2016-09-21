//
//  RankingsViewController.m
//  MyGame
//
//  Created by mac on 9/12/16.
//  Copyright © 2016 robert. All rights reserved.
//

#import "RankingsViewController.h"

@interface RankingsViewController()

@property (nonatomic, strong) UITableView* tableView;

@end

@implementation RankingsViewController

-(void)viewWillAppear:(BOOL)animated {
    NSLog(@"will appear");
    [self.tableView reloadData];
}
-(void)viewDidLoad {
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0 ,0 ,120, 20)];
    lable.text = self.title;
    lable.center = self.view.center;
    [self.view addSubview: lable];
    
    
    [self setUpViews];
    
}

-(void) setUpViews {
    UITableView* tableView = [[UITableView alloc] initWithFrame: self.view.frame style: UITableViewStylePlain];
   
    tableView.dataSource = self;
    [self.view addSubview: tableView];
    self.tableView = tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.rankings) {
        return [self.rankings.rankingsArray count];
    }
    else {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifer = @"RankingsItemCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: identifer];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: identifer];
    }
    RankingsItem* item = self.rankings.rankingsArray[indexPath.row];
    if(item) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ -- %d", item.name, item.score];
    }
    return cell;
}


@end
