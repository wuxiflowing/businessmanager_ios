//
//  JKMaintainOrderCell.h
//  OperationsManager
//
//  Created by  on 2018/7/4.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKMaintainInfoModel;
@interface JKMaintainOrderCell : UITableViewCell
@property (nonatomic, assign) JKMaintain maintainType;
- (void)createUI:(JKMaintainInfoModel *)model;
@end
