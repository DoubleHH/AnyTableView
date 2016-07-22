//
//  AnyTableViewCell.h
//  AnyTableView
//
//  Created by DoubleHH on 16/7/21.
//  Copyright © 2016年 com.chiyue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AnyTableViewCellStyle) {
    AnyTableViewCellStyleDefault,
};

@interface AnyTableViewCell : UIView

- (instancetype)initWithStyle:(AnyTableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, readonly, copy) NSString *reuseIdentifier;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
