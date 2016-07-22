//
//  AnyTableViewCell.m
//  AnyTableView
//
//  Created by DoubleHH on 16/7/21.
//  Copyright © 2016年 com.chiyue. All rights reserved.
//

#import "AnyTableViewCell.h"

@implementation AnyTableViewCell

- (instancetype)initWithStyle:(AnyTableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super init]) {
        _reuseIdentifier = reuseIdentifier;
    }
    return self;
}

@end
