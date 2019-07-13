//
//  JKFarmerMainVC.m
//  BusinessManager
//
//  Created by  on 2018/6/19.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKFarmerMainVC.h"
#import "JKFarmerMainView.h"
#import "UIBarButtonItem+XYMenu.h"
#import "JKBasicFileVC.h"
#import "JKPondFileVC.h"
#import "JKOperationRecordVC.h"
#import "JKOpenAccountVC.h"
#import "JKEquipmentInfoVC.h"
#import "JKNewEquipmentInfoVC.h"
#import "JKPondModel.h"
@interface JKFarmerMainVC () <JKFarmerMainViewDelegate>
{
    CGFloat _lat;
    CGFloat _lng;
}
@property (nonatomic, strong) JKFarmerMainView *fmView;
@end

@implementation JKFarmerMainVC

- (JKFarmerMainView *)fmView {
    if (!_fmView) {
        _fmView = [[JKFarmerMainView alloc] init];
        _fmView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _fmView.customerIdStr = self.customerIdStr;
        _fmView.isGeneral = self.isGeneral;
        _fmView.delegate = self;
    }
    return _fmView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置初始导航栏透明度
    [self wr_setNavBarBackgroundAlpha:0];
    
//    if (!self.isGeneral) {
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_operation_record"]
//                                                                                  style:UIBarButtonItemStyleDone
//                                                                                 target:self
//                                                                                 action:@selector(more:)];
//    }
    
    [JKNotificationCenter addObserver:self selector:@selector(currentLatAndLngNotification:)name:@"CurrentLatAndLngNotification" object:nil];
    
    _lat = 0;
    _lng = 0;
    
    [self startLocation];
    
    [self.view addSubview:self.fmView];
//    [self.fmView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.bottom.equalTo(self.view);
//    }];
}

#pragma mark -- JKFarmerMainViewDelegate
- (void)scrollNavigationBarWithTitle:(NSString *)title withIsClear:(BOOL)isClear{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.6 animations:^
     {
         __strong typeof(self) pThis = weakSelf;
         if (isClear == YES) {
             [pThis wr_setNavBarBackgroundAlpha:0];
             self.navigationItem.title = @"";
         } else {
             [pThis wr_setNavBarBackgroundAlpha:1.0];
             self.navigationItem.title = title;
         }
     }];
}

- (void)callFarmerPhone:(NSString *)phoneNumber {
    NSString *dialSring=[NSString stringWithFormat:@"tel://%@",phoneNumber];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dialSring] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dialSring]];
    }
}

#pragma mark -- 获取当前经纬度
- (void)currentLatAndLngNotification:(NSNotification *)noti {
    _lat = [noti.userInfo[@"lat"] floatValue];
    _lng = [noti.userInfo[@"lng"] floatValue];
}

- (void)farmerAddr:(NSString *)addr {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"选择地图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]) {
        UIAlertAction *baiduMapAction = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *baiduParameterFormat = @"baidumap://map/direction?origin={{我的位置}}&destination=%@&mode=driving&coord_type=gcj02&src=%@";
            NSString *urlString = [[NSString stringWithFormat:
                                    baiduParameterFormat,
                                    addr,
                                    @"养殖管家"
                                    ]
                                   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }];
        [actionSheet addAction:baiduMapAction];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        UIAlertAction *gaodeMapAction = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //            CLLocationCoordinate2D coor = [self GCJ02FromBD09:model.coordinate];
            NSString *gaodeParameterFormat = @"iosamap://path?sourceApplication=%@&sid=BGVIS1&did=BGVIS2&dname=%@&dev=0&t=2";
            NSString *urlString = [[NSString stringWithFormat:
                                    gaodeParameterFormat,
                                    @"养殖管家",
                                    addr]
                                   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }];
        [actionSheet addAction:gaodeMapAction];
    }
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark -- 基础信息
- (void)clickFileBtn:(UIButton *)btn {
//    JKBasicFileVC *bfVC = [[JKBasicFileVC alloc] init];
//    bfVC.customerIdStr = self.customerIdStr;
//    [self.navigationController pushViewController:bfVC animated:YES];
}

#pragma mark -- 更多
- (void)more:(UIButton *)btn {
//    JKOperationRecordVC *orVC = [[JKOperationRecordVC alloc] init];
//    [self.navigationController pushViewController:orVC animated:YES];
}

#pragma mark -- 设备详情
- (void)pushDevicesInfoVC:(JKPondChildDeviceModel *)dModel {
    if ([dModel.type isEqualToString:@"KD326"]) {
        JKEquipmentInfoVC *eiVC = [[JKEquipmentInfoVC alloc] init];
        eiVC.tskID = dModel.ident;
        [self.navigationController pushViewController:eiVC animated:YES];
    }
    
    if ([dModel.type isEqualToString:@"QY601"]) {
        JKNewEquipmentInfoVC *eiVC = [[JKNewEquipmentInfoVC alloc] init];
        eiVC.tskID = dModel.ident;
        [self.navigationController pushViewController:eiVC animated:YES];
    }
}

#pragma mark -- 鱼塘详情
- (void)pushPondsInfoVC:(JKPondModel *)model {
    JKPondFileVC *pfVC = [[JKPondFileVC alloc] init];
    pfVC.model = model;
    [self.navigationController pushViewController:pfVC animated:YES];
}

#pragma mark -- 成为签约用户
- (void)clickSignBtnWithFarmerId:(NSString *)farmerId withFarmerName:(NSString *)farmerName withContractInfo:(NSString *)contractInfo withBirthday:(NSString *)birthday withSex:(NSString *)sex withRegion:(NSString *)region withHomeAddress:(NSString *)homeAddress withIDNumber:(NSString *)idNumber withIdPicture:(NSString *)idPicture withPicture:(NSString *)picture withPondPicture:(NSString *)pondPicture {
    JKOpenAccountVC *opVC = [[JKOpenAccountVC alloc] init];
    opVC.farmerIdStr = farmerId;
    opVC.farmerNameStr = farmerName;
    opVC.contactStr = contractInfo;
    opVC.birthdayStr = birthday;
    opVC.regionStr = region;
    opVC.sexStr = sex;
    opVC.homeAddrStr = homeAddress;
    opVC.idNumberStr = idNumber;
    opVC.idPicture = idPicture;
    opVC.picture = picture;
    opVC.pondPicture = pondPicture;
    opVC.isGeneral = YES;
    [self.navigationController pushViewController:opVC animated:YES];
}

@end
