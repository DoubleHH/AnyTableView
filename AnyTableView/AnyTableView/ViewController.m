//
//  ViewController.m
//  AnyTableView
//
//  Created by DoubleHH on 16/7/21.
//  Copyright © 2016年 com.chiyue. All rights reserved.
//

#import "ViewController.h"
#import "ImitateTableView.h"

@interface ViewController () <ImitateTableViewDelegate>

@property (nonatomic, strong) ImitateTableView *imitateTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imitateTableView = [[ImitateTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    self.imitateTableView.imitateDelegate = self;
    [self.view addSubview:self.imitateTableView];
}

#pragma mark - ImitateTableViewDelegate
- (NSInteger)tableView:(ImitateTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(ImitateTableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(ImitateTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (AnyTableViewCell *)tableView:(ImitateTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"identifier%d", (int)indexPath.section];
    AnyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSLog(@"alloc indexPath: %@", indexPath);
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

@end
