//
//  ImitateTableView.h
//  AnyTableView
//
//  Created by DoubleHH on 16/7/21.
//  Imitateright © 2016年 com.chiyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnyTableView.h"

@class ImitateTableView;

@protocol ImitateTableViewDelegate <NSObject>

- (NSInteger)imitateTableView:(ImitateTableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (NSInteger)numberOfSectionsInImitateTableView:(ImitateTableView *)tableView;
- (CGFloat)imitateTableView:(ImitateTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (AnyTableViewCell *)imitateTableView:(ImitateTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ImitateTableView : UIScrollView

@property (nonatomic, weak) id<ImitateTableViewDelegate> imitateDelegate;

- (void)reloadData;
- (AnyTableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

@end
