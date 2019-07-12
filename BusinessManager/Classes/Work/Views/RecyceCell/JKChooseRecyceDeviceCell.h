//
//  JKChooseRecyceDeviceCell.h
//  BusinessManager
//
//  Created by  on 2018/10/16.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKPondModel;
@class JKPondChildDeviceModel;
@protocol JKChooseRecyceDeviceCellDelegate <NSObject>
- (void)getMaintainKeeper:(NSInteger)tag;
- (void)getSelectDic:(NSMutableDictionary *)dict;
- (void)changeBtnState:(NSInteger)tag withIndex:(NSInteger)index withSelected:(BOOL)isSelected;
@end

@interface JKChooseRecyceDeviceCell : UITableViewCell
@property (nonatomic, weak) id<JKChooseRecyceDeviceCellDelegate> delegate;
@property (nonatomic, assign) NSInteger index;
- (void)sendPondModel:(JKPondModel *)pModel;
@end
