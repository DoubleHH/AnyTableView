//
//  ViewController.m
//  AnyTableView
//
//  Created by DoubleHH on 16/7/21.
//  Copyright © 2016年 com.chiyue. All rights reserved.
//

#import "ViewController.h"
#import "ImitateTableView.h"

@interface ViewController () <ImitateTableViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ImitateTableView *imitateTableView;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imitateTableView = [[ImitateTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    self.imitateTableView.imitateDelegate = self;
    [self.view addSubview:self.imitateTableView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.imitateTableView.bottom + 20, SCREEN_WIDTH, 300) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    [self.view addSubview:self.tableView];
}

#pragma mark - ImitateTableViewDelegate
- (NSInteger)imitateTableView:(ImitateTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)numberOfSectionsInImitateTableView:(ImitateTableView *)tableView {
    return 3;
}

- (CGFloat)imitateTableView:(ImitateTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (AnyTableViewCell *)imitateTableView:(ImitateTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"identifier%d", (int)indexPath.section];
    AnyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSLog(@"ImitateTableView alloc indexPath: %@", indexPath);
        cell = [[AnyTableViewCell alloc] initWithStyle:AnyTableViewCellStyleDefault reuseIdentifier:identifier];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 80)];
        label.font = [UIFont systemFontOfSize:20];
        label.textColor = [UIColor orangeColor];
        [cell addSubview:label];
        label.tag = 100;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, .5)];
        line.backgroundColor = [UIColor grayColor];
        [cell addSubview:line];
        line = [[UIView alloc] initWithFrame:CGRectMake(0, 79.5, SCREEN_WIDTH, .5)];
        line.backgroundColor = [UIColor grayColor];
        [cell addSubview:line];
        
    }
    UILabel *label = [cell viewWithTag:100];
    label.text = [NSString stringWithFormat:@"IndexPath( %d, %d )", (int)indexPath.section, (int)indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (10 - indexPath.row) * 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"identifier%d", (int)indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSLog(@"UITableView alloc indexPath: %@", indexPath);
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 80)];
        label.font = [UIFont systemFontOfSize:20];
        label.textColor = [UIColor redColor];
        [cell addSubview:label];
        label.tag = 100;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, .5)];
        line.backgroundColor = [UIColor grayColor];
        [cell addSubview:line];
        line = [[UIView alloc] initWithFrame:CGRectMake(0, 79.5, SCREEN_WIDTH, .5)];
        line.backgroundColor = [UIColor grayColor];
        [cell addSubview:line];
        
    }
    UILabel *label = [cell viewWithTag:100];
    label.height = (10 - indexPath.row) * 10;
    label.text = [NSString stringWithFormat:@"IndexPath( %d, %d )", (int)indexPath.section, (int)indexPath.row];
    return cell;
}

@end
