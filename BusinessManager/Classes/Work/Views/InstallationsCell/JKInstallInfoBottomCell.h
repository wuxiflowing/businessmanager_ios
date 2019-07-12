//
//  JKInstallInfoBottomCell.h
//  BusinessManager
//
//  Created by  on 2018/6/25.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKInstallInfoModel;

@interface JKInstallInfoBottomCell : UITableViewCell
@property (nonatomic, assign) BOOL hasPayServiceFree;
@property (nonatomic, assign) BOOL hasPayDepositFree;

- (void)getModel:(JKInstallInfoModel *)model;

@end
