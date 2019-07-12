//
//  JKInstallationDeviceCell.h
//  BusinessManager
//
//  Created by  on 2018/6/26.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKInstallInfoModel;

@protocol JKInstallationDeviceCellDelegate <NSObject>
- (void)checkEquipmentInfo:(JKInstallInfoModel *)model withTag:(NSInteger)tag;
@end

@interface JKInstallationDeviceCell : UITableViewCell
@property (nonatomic, weak) id<JKInstallationDeviceCellDelegate> delegate;
@property (nonatomic, assign) JKInstallation type;
 
- (void)createUI:(JKInstallInfoModel *)model;
@end
