//
//  AnyTableView.m
//  AnyTableView
//
//  Created by DoubleHH on 16/7/21.
//  Copyright © 2016年 com.chiyue. All rights reserved.
//

#import "AnyTableView.h"

@interface AnyTableView ()

@property (nonatomic, strong) NSMutableArray *resuseCells;
@property (nonatomic, assign) NSUInteger totalItemCount;

@end

@implementation AnyTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //UITableView
    }
    return self;
}

- (void)reloadData {
    self.totalItemCount = [self numberOfItems];
    
    
}

#pragma mark - Delegate
- (NSUInteger)numberOfItems {
    return 0;
}

- (CGRect)frameOfItemWithIndex:(NSUInteger)index {
    return CGRectZero;
}

- (AnyTableViewCell *)cellForRowAtIndex:(NSUInteger)index {
    return nil;
}

@end
