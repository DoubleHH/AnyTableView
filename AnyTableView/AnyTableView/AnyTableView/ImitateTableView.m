//
//  imitateTableView.m
//  AnyTableView
//
//  Created by DoubleHH on 16/7/21.
//  imitateright © 2016年 com.chiyue. All rights reserved.
//

#import "ImitateTableView.h"

#define NSLog(...)

static const CGFloat Interval = 0;

@interface ImitateTableView ()

@property (nonatomic, strong) NSMutableDictionary *reuseCells;
@property (nonatomic, strong) NSMutableArray *visibleCells;

@end

@implementation ImitateTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.reuseCells = [NSMutableDictionary dictionary];
        self.visibleCells = [NSMutableArray array];
        self.alwaysBounceVertical = YES;
    }
    return self;
}

- (void)setImitateDelegate:(id<ImitateTableViewDelegate>)imitateDelegate {
    _imitateDelegate = imitateDelegate;
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
    AnyTableViewCell *lastCell = nil;
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
            if (self.visibleCells.count == 1) {
                lastCell = cell;
            }
            [self reuseCell:cell];
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
        // 往上走的处理
        AnyTableViewCell *startCell = [self.visibleCells lastObject] ?: lastCell;
        if (!startCell) {
            // 所有的cell被用户暂时滑到屏幕下方
            if (self.contentOffset.y > -self.height && self.contentOffset.y < 0) { // 此时将要露出来的时候，需要查找第一个cell用于显示
                startCell = [self addFirstCell];
            }
        }
        if (!startCell || startCell.bottom >= endY) {
            return;
        }
        float height = startCell.bottom;
        NSUInteger sections = [self.imitateDelegate numberOfSectionsInImitateTableView:self];
        BOOL finished = NO;
        for (NSUInteger tempSection = startCell.indexPath.section; tempSection < sections; ++tempSection) {
            NSUInteger tempRow = tempSection == startCell.indexPath.section ? (startCell.indexPath.row + 1) : 0;
            NSUInteger rows = [self.imitateDelegate imitateTableView:self numberOfRowsInSection:tempSection];
            for (; tempRow < rows; ++tempRow) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tempRow inSection:tempSection];
                CGFloat cellHeight = [self.imitateDelegate imitateTableView:self heightForRowAtIndexPath:indexPath];
                
                if (height + cellHeight >= self.contentOffset.y) { // 异常处理，都划出去了
                    AnyTableViewCell *cell = [self cellWithIndexPath:indexPath];
                    cell.frame = CGRectMake(0, height, self.width, cellHeight);
                    [self addSubview:cell];
                    
                    [self.visibleCells addObject:cell];
                }
                
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
    else {
        // 往下走的处理
        AnyTableViewCell *startCell = [self.visibleCells firstObject] ?: lastCell;
        if (!startCell) {
            // 所有的cell被用户暂时滑到屏幕上方
            if (self.contentOffset.y > 0 &&
                self.contentOffset.y < self.contentSize.height) { // 此时将要露出来的时候，需要查找最后的cell用于显示
                startCell = [self addLastCell];
            }
        }
        if (!startCell || startCell.top <= self.contentOffset.y) {
            return;
        }
        float height = startCell.top;
        NSUInteger sections = [self.imitateDelegate numberOfSectionsInImitateTableView:self];
        BOOL finished = NO;
        for (NSUInteger tempSection = startCell.indexPath.section; tempSection < sections; --tempSection) {
            NSUInteger rows = [self.imitateDelegate imitateTableView:self numberOfRowsInSection:tempSection];
            NSUInteger tempRow = tempSection == startCell.indexPath.section ? (startCell.indexPath.row - 1) : rows - 1;
            for (; tempRow < rows; --tempRow) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tempRow inSection:tempSection];
                CGFloat cellHeight = [self.imitateDelegate imitateTableView:self heightForRowAtIndexPath:indexPath];
                
                if (height - cellHeight <= endY) {
                    AnyTableViewCell *cell = [self cellWithIndexPath:indexPath];
                    cell.frame = CGRectMake(0, height - cellHeight, self.width, cellHeight);
                    [self addSubview:cell];
                    
                    [self.visibleCells insertObject:cell atIndex:0];
                }
                
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

- (AnyTableViewCell *)addLastCell {
    AnyTableViewCell *cell = nil;
    NSUInteger sections = [self.imitateDelegate numberOfSectionsInImitateTableView:self];
    for (NSUInteger tempSection = sections - 1; tempSection < sections; --tempSection) {
        NSUInteger rows = [self.imitateDelegate imitateTableView:self numberOfRowsInSection:tempSection];
        if (rows) {
            cell = [self cellWithIndexPath:[NSIndexPath indexPathForRow:rows-1 inSection:tempSection]];
            CGFloat cellHeight = [self.imitateDelegate imitateTableView:self heightForRowAtIndexPath:cell.indexPath];
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
    NSUInteger sections = [self.imitateDelegate numberOfSectionsInImitateTableView:self];
    for (NSUInteger tempSection = 0; tempSection < sections; ++tempSection) {
        NSUInteger rows = [self.imitateDelegate imitateTableView:self numberOfRowsInSection:tempSection];
        if (rows) {
            cell = [self cellWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:tempSection]];
            CGFloat cellHeight = [self.imitateDelegate imitateTableView:self heightForRowAtIndexPath:cell.indexPath];
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
    AnyTableViewCell *cell = [self.imitateDelegate imitateTableView:self cellForRowAtIndexPath:indexPath];
    cell.indexPath = indexPath;
    return cell;
}

- (void)reloadData {
    NSUInteger sections = [self.imitateDelegate numberOfSectionsInImitateTableView:self];
    CGPoint visibleLine = CGPointMake(self.contentOffset.y, self.contentOffset.y + self.height);
    CGFloat height = 0;
    [self.visibleCells removeAllObjects];
    for (int tempSection = 0; tempSection < sections; ++tempSection) {
        NSUInteger rows = [self.imitateDelegate imitateTableView:self numberOfRowsInSection:tempSection];
        for (int tempRow = 0; tempRow < rows; ++tempRow) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tempRow inSection:tempSection];
            CGFloat preHeight = height;
            CGFloat cellHeight = [self.imitateDelegate imitateTableView:self heightForRowAtIndexPath:indexPath];
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

//! 两线段是否相交
- (BOOL)isIntersectWithLine:(CGPoint)line otherLine:(CGPoint)otherLine {
    return
    ((line.x - otherLine.x) >= Interval && (otherLine.y - line.x) >= Interval) ||
    ((line.y - otherLine.x) >= Interval && (otherLine.y - line.y) >= Interval) ||
    ((line.x - otherLine.x) < Interval && (line.y - otherLine.y) > Interval);
}

#pragma mark - 缓存机制
/**
 *  缓存cell
 *
 *  @param cell AnyTableViewCell
 */
- (void)reuseCell:(AnyTableViewCell *)cell {
    if (!cell.reuseIdentifier) {
        return;
    }
    NSMutableArray *reuseArray = self.reuseCells[cell.reuseIdentifier];
    if (!reuseArray) {
        reuseArray = [NSMutableArray array];
        self.reuseCells[cell.reuseIdentifier] = reuseArray;
    }
    if ([reuseArray containsObject:cell]) {
        return;
    }
    [reuseArray addObject:cell];
}

/**
 *  根据identifier取缓存内的cell
 *
 *  @param identifier 标识
 *
 *  @return AnyTableViewCell
 */
- (AnyTableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    if (!identifier) {
        return nil;
    }
    NSArray *reuseArray = self.reuseCells[identifier];
    for (AnyTableViewCell *cell in reuseArray) {
        if (![self.visibleCells containsObject:cell]) {
            NSLog(@"Shooted! %@", identifier);
            return cell;
        }
    }
    return nil;
}

@end
