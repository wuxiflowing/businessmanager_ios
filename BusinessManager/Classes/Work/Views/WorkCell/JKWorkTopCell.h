//
//  JKWorkTopCell.h
//  BusinessManager
//
//  Created by  on 2018/7/30.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKInstallInfoModel;

@protocol JKWorkTopCellDelegate <NSObject>
- (void)callFarmerPhone:(NSString *)phoneNumber;
@end

@interface JKWorkTopCell : UITableViewCell
@property (nonatomic, weak) id<JKWorkTopCellDelegate> delegate;
@property (nonatomic, strong) UIImageView *headImgV;
@property (nonatomic, strong) NSString *headImgStr;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *addrLb;
@property (nonatomic, strong) NSString *telStr;

@end
