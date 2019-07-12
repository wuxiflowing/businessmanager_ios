//
//  JKRecyceOrderCell.h
//  OperationsManager
//
//  Created by  on 2018/7/9.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKRecyceInfoModel;
@interface JKRecycePendOrderCell : UITableViewCell
@property (nonatomic, assign) JKRecyce recyceType;
- (void)createUI:(JKRecyceInfoModel *)model;
@end
