//
//  JKRepaireInfoMidCell.h
//  BusinessManager
//
//  Created by  on 2018/6/22.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKRepaireInfoModel;
@interface JKRepaireInfoMidCell : UITableViewCell
@property (nonatomic, assign) JKRepaire repaireType;
@property (nonatomic, assign) UILabel *pondNameLb;
@property (nonatomic, assign) UILabel *pondAddrValueLb;
@property (nonatomic, assign) UILabel *operationPeopleLb;
@property (nonatomic, assign) UILabel *deviceTypeLb;
@property (nonatomic, assign) UILabel *faultDescriptionValueLb;
@property (nonatomic, strong) UILabel *pictureLb;
@property (nonatomic, strong) NSString *repaireImg;
@property (nonatomic, strong) UIView *bgView;
- (void)createUI:(JKRepaireInfoModel *)model;

@end
