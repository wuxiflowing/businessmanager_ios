//
//  JKSuccessVC.m
//  BusinessManager
//
//  Created by  on 2018/6/21.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKSuccessVC.h"
#import "JKSigningContractVC.h"
#import "JKInstallationTaskVC.h"

@interface JKSuccessVC ()

@end

@implementation JKSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.successType == JKSuccessOpenAccount) {
        self.title = @"创建成功";
    } else if (self.successType == JKSuccessContract) {
        self.title = @"签约成功";
    } else if (self.successType == JKSuccessInstallOrder) {
        self.title = @"设备安装";
    }
    
    [self createUI];
}

- (void)createUI {
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.image = [UIImage imageNamed:@"ic_open_account_success"];
    imgV.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom).offset(SCALE_SIZE(60));
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCALE_SIZE(80), SCALE_SIZE(80)));
    }];
    
    UILabel *successLb = [[UILabel alloc] init];
    if (self.successType == JKSuccessOpenAccount) {
        successLb.text = @"创建成功";
    } else if (self.successType == JKSuccessContract) {
        successLb.text = @"签约成功";
    } else if (self.successType == JKSuccessInstallOrder) {
        successLb.text = @"安装工单成功";
    }
    successLb.textColor = kBlackColor;
    successLb.textAlignment = NSTextAlignmentCenter;
    successLb.font = JKFont(20);
    [self.view addSubview:successLb];
    [successLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgV.mas_bottom).offset(SCALE_SIZE(20));
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(35);
    }];
    
    UILabel *detailLb = [[UILabel alloc] init];
    if (self.successType == JKSuccessOpenAccount) {
        detailLb.text = @"恭喜您已经成功创建账号";
    } else if (self.successType == JKSuccessContract) {
        detailLb.text = @"恭喜您已经成功完成签约";
    } else if (self.successType == JKSuccessInstallOrder) {
        detailLb.text = @"恭喜您已经成功安装工单";
    }
    detailLb.textColor = RGBHex(0x666666);
    detailLb.textAlignment = NSTextAlignmentCenter;
    detailLb.font = JKFont(14);
    [self.view addSubview:detailLb];
    [detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(successLb.mas_bottom).offset(SCALE_SIZE(10));
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
    
    if (self.successType == JKSuccessOpenAccount) {
        if (self.isGeneral) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
            [button setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
            button.titleLabel.font = JKFont(18);
            [button setTitle:@"返 回" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(popBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(detailLb.mas_bottom).offset(SCALE_SIZE(30));
                make.left.equalTo(self.view).offset(SCALE_SIZE(15));
                make.right.equalTo(self.view).offset(-SCALE_SIZE(15));
                make.height.mas_equalTo(SCALE_SIZE(48));
            }];
        } else {
            UIButton *signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [signBtn setTitle:@"去签约" forState:UIControlStateNormal];
            [signBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
            signBtn.layer.cornerRadius = 6;
            signBtn.layer.masksToBounds = YES;
            signBtn.layer.borderColor = kThemeColor.CGColor;
            signBtn.layer.borderWidth = 1;
            signBtn.titleLabel.font = JKFont(18);
            [signBtn addTarget:self action:@selector(signBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:signBtn];
            [signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(detailLb.mas_bottom).offset(SCALE_SIZE(30));
                make.left.equalTo(self.view).offset(SCALE_SIZE(15));
                make.right.equalTo(self.view.mas_centerX).offset(-SCALE_SIZE(7.5));
                make.height.mas_equalTo(SCALE_SIZE(48));
            }];
            
            UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [backBtn setTitle:@"返 回" forState:UIControlStateNormal];
            [backBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
            backBtn.layer.cornerRadius = 6;
            backBtn.layer.masksToBounds = YES;
            [backBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
            [backBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
            [backBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
            backBtn.titleLabel.font = JKFont(18);
            [backBtn addTarget:self action:@selector(popBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:backBtn];
            [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(detailLb.mas_bottom).offset(SCALE_SIZE(30));
                make.right.equalTo(self.view).offset(-SCALE_SIZE(15));
                make.left.equalTo(self.view.mas_centerX).offset(SCALE_SIZE(7.5));
                make.height.mas_equalTo(SCALE_SIZE(48));
            }];
        }
    } else if (self.successType == JKSuccessInstallOrder) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
        button.titleLabel.font = JKFont(18);
        [button setTitle:@"继续发起安装" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(installOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(detailLb.mas_bottom).offset(SCALE_SIZE(30));
            make.left.equalTo(self.view).offset(SCALE_SIZE(15));
            make.right.equalTo(self.view).offset(-SCALE_SIZE(15));
            make.height.mas_equalTo(SCALE_SIZE(48));
        }];
    } else if (self.successType == JKSuccessContract) {
//        UIButton *callFeedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [callFeedBtn setTitle:@"叫 料" forState:UIControlStateNormal];
//        [callFeedBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
//        callFeedBtn.layer.cornerRadius = 6;
//        callFeedBtn.layer.masksToBounds = YES;
//        callFeedBtn.layer.borderColor = kThemeColor.CGColor;
//        callFeedBtn.layer.borderWidth = 1;
//        callFeedBtn.titleLabel.font = JKFont(18);
//        [callFeedBtn addTarget:self action:@selector(callFeedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:callFeedBtn];
//        [callFeedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(detailLb.mas_bottom).offset(SCALE_SIZE(30));
//            make.left.equalTo(self.view).offset(SCALE_SIZE(15));
//            make.right.equalTo(self.view.mas_centerX).offset(-SCALE_SIZE(7.5));
//            make.height.mas_equalTo(SCALE_SIZE(48));
//        }];
        
        UIButton *installEquipmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [installEquipmentBtn setTitle:@"设备安装" forState:UIControlStateNormal];
        [installEquipmentBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        installEquipmentBtn.layer.cornerRadius = 6;
        installEquipmentBtn.layer.masksToBounds = YES;
        [installEquipmentBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
        [installEquipmentBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
        [installEquipmentBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
        installEquipmentBtn.titleLabel.font = JKFont(18);
        [installEquipmentBtn addTarget:self action:@selector(installEquipmentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:installEquipmentBtn];
        [installEquipmentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(detailLb.mas_bottom).offset(SCALE_SIZE(30));
            make.right.equalTo(self.view).offset(-SCALE_SIZE(15));
            make.left.equalTo(self.view).offset(SCALE_SIZE(15));
            make.height.mas_equalTo(SCALE_SIZE(48));
        }];
    }
}

- (void)popBackBtnClick:(UIButton *)btn {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)installOrderBtnClick:(UIButton *)btn {
    JKInstallationTaskVC *itVC = [[JKInstallationTaskVC alloc] init];
    itVC.farmerId = self.farmerId;
    itVC.farmerName = self.farmerName;
    itVC.farmerAdd = self.farmerAdd;
    itVC.farmerTel = self.farmerTel;
    [self.navigationController pushViewController:itVC animated:YES];
}

- (void)callFeedBtnClick:(UIButton *)btn {
    
}

- (void)installEquipmentBtnClick:(UIButton *)btn {
    JKInstallationTaskVC *itVC = [[JKInstallationTaskVC alloc] init];
    itVC.farmerId = self.farmerId;
    itVC.farmerName = self.farmerName;
    itVC.farmerAdd = self.farmerAdd;
    itVC.farmerTel = self.farmerTel;
    [self.navigationController pushViewController:itVC animated:YES];
}

- (void)signBtnClick:(UIButton *)btn {
    JKSigningContractVC *scVC = [[JKSigningContractVC alloc] init];
    scVC.farmerId = self.farmerId;
    scVC.farmerName = self.farmerName;
    scVC.farmerAdd = self.farmerAdd;
    scVC.farmerTel = self.farmerTel;
    scVC.farmerPic = self.farmerPic;
    [self.navigationController pushViewController:scVC animated:YES];
}

@end
