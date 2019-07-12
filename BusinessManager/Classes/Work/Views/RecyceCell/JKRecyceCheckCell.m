//
//  JKRecyceCheckCell.m
//  BusinessManager
//
//  Created by  on 2018/11/22.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKRecyceCheckCell.h"
#import "JKTaskModel.h"

@implementation JKRecyceCheckCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kBgColor;
    }
    return self;
}

- (void)createUI:(JKTaskModel *)model {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = kThemeColor;
    bgView.layer.cornerRadius = 4;
    bgView.layer.masksToBounds = YES;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView);
    }];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = kWhiteColor;
    [bgView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(40);
        make.left.right.bottom.equalTo(bgView);
    }];
    
    UILabel *farmerNameLb = [[UILabel alloc] init];
    farmerNameLb.text = [NSString stringWithFormat:@"%@", model.txtFarmerName];
    farmerNameLb.textColor = kWhiteColor;
    farmerNameLb.textAlignment = NSTextAlignmentCenter;
    farmerNameLb.font = JKFont(17);
    farmerNameLb.numberOfLines = 1;
    [bgView addSubview:farmerNameLb];
    NSDictionary *attribute = @{NSFontAttributeName: JKFont(17)};
    CGSize textSize = [farmerNameLb.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 280, 40) options:NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    [farmerNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView);
        make.left.equalTo(bgView).offset(5);
        make.size.mas_equalTo(CGSizeMake(textSize.width + 20, 40));
    }];
    
    UIImageView *callImgV = [[UIImageView alloc] init];
    callImgV.image = [UIImage imageNamed:@"ic_installation_record_call"];
    callImgV.contentMode = UIViewContentModeCenter;
    [bgView addSubview:callImgV];
    [callImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(farmerNameLb.mas_centerY);
        make.left.equalTo(farmerNameLb.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(13, 14));
    }];
    
    UILabel *phoneLb = [[UILabel alloc] init];
    phoneLb.text = [NSString stringWithFormat:@"%@",model.txtFarmerPhone];
    phoneLb.textColor = kWhiteColor;
    phoneLb.textAlignment = NSTextAlignmentLeft;
    phoneLb.font = JKFont(17);
    [bgView addSubview:phoneLb];
    [phoneLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView);
        make.left.equalTo(callImgV.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(120, 40));
    }];
    self.telStr = model.farmerPhone;
    
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:phoneBtn];
    [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView);
        make.left.equalTo(callImgV.mas_left);
        make.right.equalTo(phoneLb.mas_right);
        make.height.mas_equalTo(40);
    }];
    
    UIImageView *arrowImgV = [[UIImageView alloc] init];
    arrowImgV.image = [UIImage imageNamed:@"ic_white_arrow"];
    arrowImgV.contentMode = UIViewContentModeCenter;
    [bgView addSubview:arrowImgV];
    [arrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(farmerNameLb.mas_centerY);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(7, 12));
    }];
    
    UILabel *stateLb = [[UILabel alloc] init];
    if (self.recyceType == JKRecyceCheck) {
        stateLb.text = @"待我审核";
    } else if (self.recyceType == JKRecycePending) {
        stateLb.text = @"待审核";
    }
    stateLb.textColor = kWhiteColor;
    stateLb.textAlignment = NSTextAlignmentRight;
    stateLb.font = JKFont(17);
    [bgView addSubview:stateLb];
    [stateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView);
        make.right.equalTo(arrowImgV.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
    
    UILabel *pondNameLb = [[UILabel alloc] init];
    if (self.recyceType == JKRecyceCheck) {
        pondNameLb.text = [NSString stringWithFormat:@"发起人：%@", model.txtCenMagName];
    } else {
        pondNameLb.text = [NSString stringWithFormat:@"发起人：%@", model.txtHK];
    }
    pondNameLb.textColor = RGBHex(0x333333);
    pondNameLb.textAlignment = NSTextAlignmentLeft;
    pondNameLb.font = JKFont(14);
    [contentView addSubview:pondNameLb];
    [pondNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stateLb.mas_bottom).offset(10);
        make.left.equalTo(contentView.mas_left).offset(10);
        make.right.equalTo(contentView.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *deviceRecyceLb = [[UILabel alloc] init];
    if (self.recyceType == JKRecyceCheck) {
        deviceRecyceLb.text = [NSString stringWithFormat:@"审核人：%@", model.txtHK];
    } else {
        deviceRecyceLb.text = [NSString stringWithFormat:@"审核人：%@", model.txtCSMembName];
    }
    deviceRecyceLb.textColor = RGBHex(0x333333);
    deviceRecyceLb.textAlignment = NSTextAlignmentLeft;
    deviceRecyceLb.font = JKFont(14);
    [contentView addSubview:deviceRecyceLb];
    [deviceRecyceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pondNameLb.mas_bottom).offset(5);
        make.left.equalTo(contentView.mas_left).offset(10);
        make.right.equalTo(contentView.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *operationPeopleLb = [[UILabel alloc] init];
    operationPeopleLb.text = [NSString stringWithFormat:@"发起时间：%@", model.txtStartDate];
    operationPeopleLb.textColor = RGBHex(0x333333);
    operationPeopleLb.textAlignment = NSTextAlignmentLeft;
    operationPeopleLb.font = JKFont(14);
    [contentView addSubview:operationPeopleLb];
    [operationPeopleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deviceRecyceLb.mas_bottom).offset(5);
        make.left.equalTo(contentView.mas_left).offset(10);
        make.right.equalTo(contentView.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *bottomLineLb = [[UILabel alloc] init];
    bottomLineLb.backgroundColor = RGBHex(0xdddddd);
    [contentView addSubview:bottomLineLb];
    [bottomLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(operationPeopleLb.mas_bottom).offset(10);
        make.left.right.equalTo(contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *detailLb = [[UILabel alloc] init];
    detailLb.text = @"查看详情";
    detailLb.textColor = RGBHex(0x666666);
    detailLb.textAlignment = NSTextAlignmentLeft;
    detailLb.font = JKFont(15);
    [contentView addSubview:detailLb];
    [detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomLineLb.mas_bottom);
        make.left.equalTo(contentView.mas_left).offset(10);
        make.right.equalTo(contentView.mas_right).offset(-10);
        make.bottom.equalTo(contentView.mas_bottom);
    }];
    
    UIImageView *infoArrowImgV = [[UIImageView alloc] init];
    infoArrowImgV.image = [UIImage imageNamed:@"ic_arrow"];
    [contentView addSubview:infoArrowImgV];
    [infoArrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(detailLb.mas_centerY);
        make.right.equalTo(contentView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(9, 16));
    }];
}

- (void)phoneBtnClick:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(callFarmerPhone:)]) {
        [_delegate callFarmerPhone:self.telStr];
    }
}


@end
