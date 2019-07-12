//
//  JKRecyceCheckOrderCell.h
//  BusinessManager
//
//  Created by  on 2018/11/22.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKRecyceInfoModel;
@interface JKRecyceCheckOrderCell : UITableViewCell
@property (nonatomic, assign) JKRecyce recyceType;
- (void)createUI:(JKRecyceInfoModel *)model;
@end
