//
//  JKOperationRecordVC.m
//  BusinessManager
//
//  Created by  on 2018/6/25.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKOperationRecordVC.h"
#import "JKInstallationRecordVC.h"
#import "JKRepairRecordVC.h"
#import "JKRecyceRecordVC.h"
#import "JKMaintainRecordVC.h"
#import "JKMyOrderVC.h"
#import "JKMyContractVC.h"


@interface JKOperationRecordVC ()
@property (nonatomic, strong) UIView *operationView;
@property (nonatomic, strong) UIView *recordView;
@property (nonatomic, strong) UILabel *lineLb;
@end

@implementation JKOperationRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"操作记录";
    self.view.backgroundColor = kWhiteColor;
    
    [self createOperationUI];

    UILabel *lineLb = [[UILabel alloc] init];
    lineLb.backgroundColor = kBgColor;
    [self.view addSubview:lineLb];
    [lineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.operationView.mas_bottom);
        make.left.equalTo(self.view).offset(SCALE_SIZE(15));
        make.right.equalTo(self.view).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(1);
    }];
    self.lineLb = lineLb;

    [self createRecordUI];
}

#pragma mark -- 操作
- (void)createOperationUI {
    UIView *operationView = [[UIView alloc] init];
    operationView.backgroundColor = kWhiteColor;
    [self.view addSubview:operationView];
    [operationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        if (IS_IPHONE_X) {
            make.height.mas_equalTo(SCALE_SIZE(210));
        } else {
            make.height.mas_equalTo(SCALE_SIZE(250));
        }
        
    }];
    self.operationView = operationView;
    
    UILabel *operationTitleLb = [[UILabel alloc] init];
    operationTitleLb.text = @"操作";
    operationTitleLb.textColor = kBlackColor;
    operationTitleLb.textAlignment = NSTextAlignmentLeft;
    operationTitleLb.font = JKFont(16);
    [operationView addSubview:operationTitleLb];
    [operationTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(operationView).offset(SCALE_SIZE(15));
        make.left.equalTo(self.view).offset(SCALE_SIZE(15));
        make.right.equalTo(self.view).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(30);
    }];

    NSArray *operationTitleArr = @[@"设备安装", @"报修任务", @"回收任务", @"签/续约", @"叫料",@"收款", @"对账", @"巡检"];
    NSArray *operationImgArr = @[@"ic_installation", @"ic_repair", @"ic_recycling", @"ic_contract", @"ic_called", @"ic_receipt", @"ic_reconciliation", @"ic_inspection"];

    CGFloat btnWidth = SCREEN_WIDTH / 4;
    for (int i = 0; i < operationTitleArr.count; i++) {
        NSInteger col = i / 4;
        NSInteger row = i % 4;
        // 遍历6个UIView用来存放数据和标题
        UIView *operateView = [[UIView alloc] init];
        operateView.backgroundColor = kWhiteColor;
        [operationView addSubview:operateView];
        [operateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(operationTitleLb.mas_bottom).offset(btnWidth * col);
            make.width.mas_equalTo(btnWidth);
            make.height.mas_equalTo(btnWidth);
            make.left.mas_equalTo(btnWidth * row);
        }];

        UIImageView *btnImgV = [[UIImageView alloc] init];
        btnImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",operationImgArr[i]]];
        [operateView addSubview:btnImgV];
        [btnImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(operateView.mas_centerX);
            make.centerY.equalTo(operateView.mas_centerY).offset(-10);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 8, SCREEN_WIDTH / 8));
        }];

        UILabel *titleLb = [[UILabel alloc] init];
        titleLb.text = operationTitleArr[i];
        titleLb.textColor = RGBHex(0x666666);
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.font = JKFont(12);
        [operateView addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(operateView.mas_centerX);
            make.bottom.equalTo(operateView.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 4, 30));
        }];

        UIButton *operateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        operateBtn.backgroundColor = kClearColor;
        operateBtn.tag = i;
        [operateBtn addTarget:self action:@selector(operateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [operateView addSubview:operateBtn];
        [operateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(operateView);
        }];
    }
}

- (void)createRecordUI {
    UIView *recordView = [[UIView alloc] init];
    recordView.backgroundColor = kWhiteColor;
    [self.view addSubview:recordView];
    [recordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineLb.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(280);
    }];
    self.recordView = recordView;
    
    UILabel *recordTitleLb = [[UILabel alloc] init];
    recordTitleLb.text = @"记录";
    recordTitleLb.textColor = kBlackColor;
    recordTitleLb.textAlignment = NSTextAlignmentLeft;
    recordTitleLb.font = JKFont(16);
    [recordView addSubview:recordTitleLb];
    [recordTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(recordView.mas_top).offset(SCALE_SIZE(15));
        make.left.equalTo(self.view).offset(SCALE_SIZE(15));
        make.right.equalTo(self.view).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(30);
    }];

    NSArray *recordTitleArr = @[@"安装记录", @"收款记录", @"对账记录", @"结算记录", @"故障记录", @"回收记录", @"维护记录", @"巡检记录" ,@"我的订单" ,@"合同管理"];
    NSArray *recordImgArr = @[@"ic_installation", @"ic_receipt", @"ic_reconciliation", @"ic_clearing", @"ic_repair", @"ic_recycling", @"ic_maintenanceRecord", @"ic_inspection" ,@"ic_order", @"ic_contract_manager"];
    
    CGFloat btnWidth = SCREEN_WIDTH / 4;
    for (int i = 0; i < recordTitleArr.count; i++) {
        NSInteger col = i / 4;
        NSInteger row = i % 4;
        // 遍历6个UIView用来存放数据和标题
        UIView *recordV = [[UIView alloc] init];
        recordV.backgroundColor = kWhiteColor;
        [recordView addSubview:recordV];
        [recordV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(recordTitleLb.mas_bottom).offset(btnWidth * col);
            make.width.mas_equalTo(btnWidth);
            make.height.mas_equalTo(btnWidth);
            make.left.mas_equalTo(btnWidth * row);
        }];

        UIImageView *btnImgV = [[UIImageView alloc] init];
        btnImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",recordImgArr[i]]];
        [recordV addSubview:btnImgV];
        [btnImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(recordV.mas_centerX);
            make.centerY.equalTo(recordV.mas_centerY).offset(-10);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 8, SCREEN_WIDTH / 8));
        }];

        UILabel *titleLb = [[UILabel alloc] init];
        titleLb.text = recordTitleArr[i];
        titleLb.textColor = RGBHex(0x666666);
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.font = JKFont(12);
        [recordV addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(recordV.mas_centerX);
            make.bottom.equalTo(recordV.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 4, 30));
        }];

        UIButton *recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        recordBtn.backgroundColor = kClearColor;
        recordBtn.tag = i;
        [recordBtn addTarget:self action:@selector(recordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [recordV addSubview:recordBtn];
        [recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(recordV);
        }];
    }
}

- (void)operateBtnClick:(UIButton *)btn {
    switch (btn.tag) {
        case 0:
            
            break;
            
        case 1:
            
            break;
            
        case 2:
            
            break;
            
        case 3:
            
            break;
            
        case 4:
            
            break;
            
        case 5:
            
            break;
            
        case 6:
            
            break;
            
        case 7:
            
            break;
            
        default:
            break;
    }
}

- (void)recordBtnClick:(UIButton *)btn {
    switch (btn.tag) {
        case 0:
        {

        }
            break;
            
        case 1:
            
            break;
            
        case 2:
            
            break;
            
        case 3:
            
            break;
            
        case 4:
        {

        }
            break;
            
        case 5:
        {

        }
            break;
            
        case 6:
        {

        }
            break;
            
        case 7:
            
            break;
            
        case 8:
        {
            JKMyOrderVC *moVC = [[JKMyOrderVC alloc] init];
            [self.navigationController pushViewController:moVC animated:YES];
        }
            break;
            
        case 9:
        {
            JKMyContractVC *mcVC = [[JKMyContractVC alloc] init];
            [self.navigationController pushViewController:mcVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
