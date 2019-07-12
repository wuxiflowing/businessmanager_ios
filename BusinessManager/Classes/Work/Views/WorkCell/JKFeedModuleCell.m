//
//  JKFeedModuleCell.m
//  BusinessManager
//
//  Created by  on 2018/6/14.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKFeedModuleCell.h"

@interface JKFeedModuleCell()
@property (nonatomic, strong) NSArray *moduleArr;
@property (nonatomic, strong) NSArray *moduleImgArr;
@end

@implementation JKFeedModuleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.moduleArr = @[@"叫料", @"对账", @"打样", @"巡检"];
        self.moduleImgArr = @[@"ic_called", @"ic_reconciliation", @"ic_proofing", @"ic_inspection"];
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UILabel *titleLb = [[UILabel alloc] init];
    titleLb.text = @"饲料模块";
    titleLb.textColor = kBlackColor;
    titleLb.textAlignment = NSTextAlignmentLeft;
    titleLb.font = JKFont(16);
    [self addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(SCALE_SIZE(15));
        make.left.equalTo(self).offset(SCALE_SIZE(15));
        make.right.equalTo(self).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(30);
    }];
    
    CGFloat btnWidth = SCREEN_WIDTH / 4;
    for (int i = 0; i < self.moduleArr.count; i++) {
        NSInteger col = i / 4;
        NSInteger row = i % 4;
        // 遍历6个UIView用来存放数据和标题
        UIView *moduleView = [[UIView alloc] init];
        moduleView.backgroundColor = kWhiteColor;
        [self addSubview:moduleView];
        [moduleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(SCALE_SIZE(20) + 30 + btnWidth * col);
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
        
        UIImageView *unBtnImgV = [[UIImageView alloc] init];
        unBtnImgV.backgroundColor = [RGBHex(0x999999) colorWithAlphaComponent:0.5];
        unBtnImgV.layer.cornerRadius = 4;
        unBtnImgV.layer.masksToBounds = YES;
        [btnImgV addSubview:unBtnImgV];
        [unBtnImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(btnImgV);
        }];
        
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
        moduleBtn.tag = i;
        [moduleBtn addTarget:self action:@selector(moduleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [moduleView addSubview:moduleBtn];
        [moduleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(moduleView);
        }];
    }
}

- (void)moduleBtnClick:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(feedModuleBtnsClick:)]) {
        [_delegate feedModuleBtnsClick:btn];
    }
}

@end
