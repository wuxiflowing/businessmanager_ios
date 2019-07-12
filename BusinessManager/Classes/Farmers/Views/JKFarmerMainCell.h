//
//  JKFarmerMainCell.h
//  BusinessManager
//
//  Created by  on 2018/6/19.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKPondChildDeviceModel;
@class JKPondModel;
@protocol JKFarmerMainCellDelegate <NSObject>
- (void)pushPondInfoVC:(JKPondModel *)model;
- (void)pushDeviceInfoVC:(NSString *)deviceId;
@end

@interface JKFarmerMainCell : UITableViewCell
@property (nonatomic, weak) id<JKFarmerMainCellDelegate> delegate;
- (void)configCellWithModel:(JKPondChildDeviceModel *)model withPondModel:(JKPondModel *)pModel;

@end
