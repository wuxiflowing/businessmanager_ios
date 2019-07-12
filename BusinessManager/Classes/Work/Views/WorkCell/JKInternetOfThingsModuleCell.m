//
//  JKInternetOfThingsModuleCell.m
//  BusinessManager
//
//  Created by  on 2018/6/14.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKInternetOfThingsModuleCell.h"

@interface JKInternetOfThingsModuleCell()
@property (nonatomic, strong) NSArray *moduleArr;
@property (nonatomic, strong) NSArray *moduleImgArr;
@end

@implementation JKInternetOfThingsModuleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.moduleArr = @[@"开户申请", @"设备安装", @"故障报修", @"收款", @"设备回收", @"签/续约"];
//        self.moduleImgArr = @[@"ic_openAccount", @"ic_installation", @"ic_repair", @"ic_receipt", @"ic_recycling", @"ic_contract"];
        self.moduleArr = @[@"开户申请", @"签/续约", @"设备安装", @"故障报修", @"设备回收"];
        self.moduleImgArr = @[@"ic_openAccount", @"ic_contract", @"ic_installation", @"ic_repair", @"ic_recycling"];
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UILabel *titleLb = [[UILabel alloc] init];
    titleLb.text = @"传感器业务";
    titleLb.textColor = kBlackColor;
    titleLb.textAlignment = NSTextAlignmentLeft;
    titleLb.font = JKFont(16);
    [self.contentView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(SCALE_SIZE(15));
        make.left.equalTo(self.contentView).offset(SCALE_SIZE(15));
        make.right.equalTo(self.contentView).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(30);
    }];
    
    CGFloat btnWidth = SCREEN_WIDTH / 4;
    for (int i = 0; i < self.moduleArr.count; i++) {
        NSInteger col = i / 4;
        NSInteger row = i % 4;
        // 遍历6个UIView用来存放数据和标题
        UIView *moduleView = [[UIView alloc] init];
        moduleView.backgroundColor = kWhiteColor;
        [self.contentView addSubview:moduleView];
        [moduleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(SCALE_SIZE(20) + 30 + btnWidth * col);
            make.width.mas_equalTo(btnWidth);
            make.height.mas_equalTo(btnWidth);
            make.left.mas_equalTo(btnWidth * row);
        }];
        
        UIImageView *btnImgV = [[UIImageView alloc] init];
        btnImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.moduleImgArr[i]]];
        [moduleView addSubview:btnImgV];
        [btnImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(moduleView.mas_centerX);
            make.centerY.equalTo(moduleView.mas_centerY).offset(-10);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 8, SCREEN_WIDTH / 8));
        }];
        
//        if (i == 3) {
//            UIImageView *unBtnImgV = [[UIImageView alloc] init];
//            unBtnImgV.backgroundColor = [RGBHex(0x999999) colorWithAlphaComponent:0.5];
//            unBtnImgV.layer.cornerRadius = 4;
//            unBtnImgV.layer.masksToBounds = YES;
//            [btnImgV addSubview:unBtnImgV];
//            [unBtnImgV mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.left.right.bottom.equalTo(btnImgV);
//            }];
//        }
        
        UILabel *titleLb = [[UILabel alloc] init];
        titleLb.text = self.moduleArr[i];
        titleLb.textColor = RGBHex(0x666666);
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.font = JKFont(12);
        [moduleView addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(moduleView.mas_centerX);
            make.bottom.equalTo(moduleView.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(btnWidth, 30));
        }];
        
        UIButton *moduleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        moduleBtn.backgroundColor = kClearColor;
        moduleBtn.tag = i;
        [moduleBtn addTarget:self action:@selector(moduleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [moduleView addSubview:moduleBtn];
        [moduleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(moduleView);
        }];
    }
    
//    UILabel *lineLb = [[UILabel alloc] init];
//    lineLb.backgroundColor = RGBHex(0xdddddd);
//    [self.contentView addSubview:lineLb];
//    [lineLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.contentView);
//        make.left.equalTo(self.contentView).offset(SCALE_SIZE(15));
//        make.right.equalTo(self.contentView).offset(-SCALE_SIZE(15));
//        make.height.mas_equalTo(1);
//    }];
}

- (void)moduleBtnClick:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(moduleBtnsClick:)]) {
        [_delegate moduleBtnsClick:btn];
    }
}

@end
