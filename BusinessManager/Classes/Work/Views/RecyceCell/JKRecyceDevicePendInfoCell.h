//
//  JKRecyceDevicePendInfoCell.h
//  BusinessManager
//
//  Created by  on 2018/7/2.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKRecyceDevicePendInfoCellDelegate <NSObject>
- (void)deleteOrderWithNumber:(NSInteger)number;
@end

@interface JKRecyceDevicePendInfoCell : UITableViewCell
@property (nonatomic, weak) id<JKRecyceDevicePendInfoCellDelegate> delegate;

@end
