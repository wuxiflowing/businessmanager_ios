//
//  JKRecyceDevicesInfoCell.h
//  BusinessManager
//
//  Created by  on 2018/10/17.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKRecyceDevicesInfoCellDelegate <NSObject>
- (void)addBtnClick:(UIButton *)btn;
@end

@interface JKRecyceDevicesInfoCell : UITableViewCell
@property (nonatomic, weak) id<JKRecyceDevicesInfoCellDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *fishPondList;
@end
