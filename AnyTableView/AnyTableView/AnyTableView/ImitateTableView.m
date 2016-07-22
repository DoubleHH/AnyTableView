//
//  imitateTableView.m
//  AnyTableView
//
//  Created by DoubleHH on 16/7/21.
//  imitateright © 2016年 com.chiyue. All rights reserved.
//

#import "ImitateTableView.h"

static const CGFloat Interval = 0;

@interface ImitateTableView ()

@property (nonatomic, strong) NSMutableArray *reuseCells;
@property (nonatomic, strong) NSMutableArray *visibleCells;

@end

@implementation ImitateTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.reuseCells = [NSMutableArray array];
        self.visibleCells = [NSMutableArray array];
        self.alwaysBounceVertical = YES;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self reloadData];
}

- (void)setContentOffset:(CGPoint)contentOffset {
    
    CGFloat preOffsetY = self.contentOffset.y;
    [super setContentOffset:contentOffset];
//    NSLog(@"%s, offset:%@", __FUNCTION__, NSStringFromCGPoint(contentOffset));
    
    if (self.contentOffset.y - preOffsetY > 0) {
        // 上划
        [self viewMovedIsUpDirection:YES];
    } else if (self.contentOffset.y - preOffsetY < 0) {
        // 下拉
        [self viewMovedIsUpDirection:NO];
    }
}

- (void)viewMovedIsUpDirection:(BOOL)isUpDirection {
    CGFloat endY = self.contentOffset.y + self.height;
    // 循环减掉划出去的cell
    while (self.visibleCells.count) {
        BOOL isMovedOut = NO;
        AnyTableViewCell *cell = nil;
        if (isUpDirection) {
            cell = [self.visibleCells firstObject];
            isMovedOut = cell.bottom < self.contentOffset.y;
        } else {
            cell = [self.visibleCells lastObject];
            isMovedOut = cell.top > endY;
        }
        if (isMovedOut) {
            // 已经划出去了
            if (![self.reuseCells containsObject:cell]) {
                if (isUpDirection) {
                    self.reuseCells[0] = cell;
                } else {
                    self.reuseCells[1] = cell;
                }
            }
            [cell removeFromSuperview];
            [self.visibleCells removeObject:cell];
            NSLog(@"%@ moved out!!", cell.indexPath);
            NSLog(@"reuseCell Count : %d, visible Count : %d", (int)self.reuseCells.count, (int)self.visibleCells.count);
        } else {
            break;
        }
    }
    // 双循环添加需要显示的Cell
    NSLog(@"contentOffset.y : %f", self.contentOffset.y);
    if (isUpDirection) {
        AnyTableViewCell *lastCell = [self.visibleCells lastObject];
        if (!lastCell) {
            if (self.contentOffset.y > -self.height) {
                lastCell = [self addFirstCell];
            }
        }
        if (lastCell && lastCell.bottom < endY) {
            float height = lastCell.bottom;
            NSUInteger sections = [self.imitateDelegate numberOfSectionsInTableView:self];
            BOOL finished = NO;
            for (NSUInteger tempSection = lastCell.indexPath.section; tempSection < sections; ++tempSection) {
                NSUInteger tempRow = tempSection == lastCell.indexPath.section ? (lastCell.indexPath.row + 1) : 0;
                NSUInteger rows = [self.imitateDelegate tableView:self numberOfRowsInSection:tempSection];
                for (; tempRow < rows; ++tempRow) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tempRow inSection:tempSection];
                    CGFloat cellHeight = [self.imitateDelegate tableView:self heightForRowAtIndexPath:indexPath];
                    AnyTableViewCell *cell = [self cellWithIndexPath:indexPath];
                    cell.frame = CGRectMake(0, height, self.width, cellHeight);
                    [self addSubview:cell];
                    
                    [self.visibleCells addObject:cell];
                    
                    height += cellHeight;
                    
                    if (height >= endY) {
                        finished = YES;
                        break;
                    }
                }
                if (finished) {
                    break;
                }
            }
        }
    }
    else {
        AnyTableViewCell *firstCell = [self.visibleCells firstObject];
        if (!firstCell) {
            if (self.contentOffset.y > 0 && self.contentOffset.y < self.contentSize.height) {
                firstCell = [self addLastCell];
            }
        }
        if (firstCell && firstCell.top > self.contentOffset.y) {
            float height = firstCell.top;
            NSUInteger sections = [self.imitateDelegate numberOfSectionsInTableView:self];
            BOOL finished = NO;
            for (NSUInteger tempSection = firstCell.indexPath.section; tempSection < sections; --tempSection) {
                NSUInteger rows = [self.imitateDelegate tableView:self numberOfRowsInSection:tempSection];
                NSUInteger tempRow = tempSection == firstCell.indexPath.section ? (firstCell.indexPath.row - 1) : rows - 1;
                for (; tempRow < rows; --tempRow) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tempRow inSection:tempSection];
                    CGFloat cellHeight = [self.imitateDelegate tableView:self heightForRowAtIndexPath:indexPath];
                    AnyTableViewCell *cell = [self cellWithIndexPath:indexPath];
                    cell.frame = CGRectMake(0, height - cellHeight, self.width, cellHeight);
                    [self addSubview:cell];
                    
                    [self.visibleCells insertObject:cell atIndex:0];
                    
                    height -= cellHeight;
                    
                    if (height <= self.contentOffset.y) {
                        finished = YES;
                        break;
                    }
                }
                if (finished) {
                    break;
                }
            }
        }
    }
}

- (AnyTableViewCell *)addLastCell {
    AnyTableViewCell *cell = nil;
    NSUInteger sections = [self.imitateDelegate numberOfSectionsInTableView:self];
    for (NSUInteger tempSection = sections - 1; tempSection < sections; --tempSection) {
        NSUInteger rows = [self.imitateDelegate tableView:self numberOfRowsInSection:tempSection];
        if (rows) {
            cell = [self cellWithIndexPath:[NSIndexPath indexPathForRow:rows-1 inSection:tempSection]];
            CGFloat cellHeight = [self.imitateDelegate tableView:self heightForRowAtIndexPath:cell.indexPath];
            cell.frame = CGRectMake(0, self.contentSize.height - cellHeight, self.width, cellHeight);
            if (![self.visibleCells containsObject:cell]) {
                [self addSubview:cell];
                [self.visibleCells addObject:cell];
            }
            break;
        }
    }
    NSLog(@"%s, find cell : %@", __FUNCTION__, cell);
    return nil;
}

- (AnyTableViewCell *)addFirstCell {
    AnyTableViewCell *cell = nil;
    NSUInteger sections = [self.imitateDelegate numberOfSectionsInTableView:self];
    for (NSUInteger tempSection = 0; tempSection < sections; ++tempSection) {
        NSUInteger rows = [self.imitateDelegate tableView:self numberOfRowsInSection:tempSection];
        if (rows) {
            cell = [self cellWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:tempSection]];
            CGFloat cellHeight = [self.imitateDelegate tableView:self heightForRowAtIndexPath:cell.indexPath];
            cell.frame = CGRectMake(0, 0, self.width, cellHeight);
            if (![self.visibleCells containsObject:cell]) {
                [self addSubview:cell];
                [self.visibleCells insertObject:cell atIndex:0];
            }
            break;
        }
    }
    NSLog(@"%s, find cell : %@", __FUNCTION__, cell);
    return cell;
}

- (AnyTableViewCell *)cellWithIndexPath:(NSIndexPath *)indexPath {
    AnyTableViewCell *cell = [self.imitateDelegate tableView:self cellForRowAtIndexPath:indexPath];
    cell.indexPath = indexPath;
    return cell;
}

- (void)reloadData {
    NSUInteger sections = [self.imitateDelegate numberOfSectionsInTableView:self];
    CGPoint visibleLine = CGPointMake(self.contentOffset.y, self.contentOffset.y + self.height);
    CGFloat height = 0;
    [self.visibleCells removeAllObjects];
    for (int tempSection = 0; tempSection < sections; ++tempSection) {
        NSUInteger rows = [self.imitateDelegate tableView:self numberOfRowsInSection:tempSection];
        for (int tempRow = 0; tempRow < rows; ++tempRow) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tempRow inSection:tempSection];
            CGFloat preHeight = height;
            CGFloat cellHeight = [self.imitateDelegate tableView:self heightForRowAtIndexPath:indexPath];
            height += cellHeight;
            if ([self isIntersectWithLine:CGPointMake(preHeight, height) otherLine:visibleLine]) {
                AnyTableViewCell *cell = [self cellWithIndexPath:indexPath];
                cell.frame = CGRectMake(0, preHeight, self.width, cellHeight);
                [self addSubview:cell];
                [self.visibleCells addObject:cell];
            }
        }
    }
    self.contentSize = CGSizeMake(self.width, height);
}

- (AnyTableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    for (AnyTableViewCell *cell in self.reuseCells) {
        if ([cell.reuseIdentifier isEqualToString:identifier] && ![self.visibleCells containsObject:cell]) {
            NSLog(@"Shooted! %@", identifier);
            return cell;
        }
    }
    return nil;
}

//! 两线段是否相交
- (BOOL)isIntersectWithLine:(CGPoint)line otherLine:(CGPoint)otherLine {
    return
    ((line.x - otherLine.x) > Interval && (otherLine.y - line.x) > Interval) ||
    ((line.y - otherLine.x) > Interval && (otherLine.y - line.y) > Interval) ||
    ((line.x - otherLine.x) < Interval && (line.y - otherLine.y) > Interval);
}

@end
