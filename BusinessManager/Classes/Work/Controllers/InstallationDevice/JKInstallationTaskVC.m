//
//  JKInstallationTaskVC.m
//  BusinessManager
//
//  Created by  on 2018/6/26.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKInstallationTaskVC.h"
#import "JKInstallationTopView.h"
#import "JKInstallationMidView.h"
#import "JKInstallationBottomView.h"
#import "JKChooseFarmersVC.h"
#import "JKChooseOperationPeoplesVC.h"
#import "JKContractFarmersVC.h"
#import "JKContractView.h"
#import "JKContractModel.h"
#import "CoreLocation/CoreLocation.h"
#import "JKDeviceModel.h"
#import "JKSuccessVC.h"
#import "JKGeoCodeSearchVC.h"

@interface JKInstallationTaskVC () <JKInstallationTopViewDelegate, JKInstallationBottomViewDelegate, JKDateTimePickerViewDelegate, JKContractFarmersVCDelegate, JKContractViewDelegate, JKChooseOperationPeoplesVCDelegate,CLLocationManagerDelegate,JKGeoCodeSearchVCDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) JKInstallationTopView *topView;
@property (nonatomic, strong) JKInstallationMidView *midView;
@property (nonatomic, strong) JKInstallationBottomView *bottomView;
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lng;
@property (nonatomic, strong) UIButton *submitBtn;
@end

@implementation JKInstallationTaskVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"安装任务";
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = kBgColor;
    scrollView.scrollEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    self.scrollView = scrollView;
    
    JKInstallationTopView *topView = [[JKInstallationTopView alloc] init];
    topView.farmerId = self.farmerId;
    topView.farmerName = self.farmerName;
    topView.addr = self.farmerAdd;
    topView.tel = self.farmerTel;
    topView.delegate = self;
    [scrollView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView.mas_top);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(508);
    }];
    self.topView = topView;
    
    JKInstallationMidView *midView = [[JKInstallationMidView alloc] initWithFromSigningContractVC:NO];
    [self.scrollView addSubview:midView];
    [midView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(SCALE_SIZE(10));
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(48);
    }];
    self.midView = midView;
    
    JKInstallationBottomView *bottomView = [[JKInstallationBottomView alloc] init];
    bottomView.delegate = self;
    [self.scrollView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.midView.mas_bottom).offset(SCALE_SIZE(10));
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(288);
    }];
    self.bottomView = bottomView;
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"提 交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.layer.cornerRadius = 4;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
    [self.scrollView addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_bottom).offset(SCALE_SIZE(20));
        make.left.equalTo(self.view).offset(SCALE_SIZE(15));
        make.right.equalTo(self.view).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(48);
    }];
    self.submitBtn = submitBtn;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMidViewHeight:)name:@"reloadMidViewHeight" object:nil];
    
    [self startLocation];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 508 + 48 + SCALE_SIZE(10) + 288 + SCALE_SIZE(60) + 48);
    
    if (self.farmerId != nil) {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadAddrAndTel" object:nil userInfo:@{@"addr":self.farmerAdd, @"contractInfo":self.farmerTel, @"farmerName":self.farmerName, @"farmerId":self.farmerId}]];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.locationManager = nil;
}

#pragma mark -- 刷新行高
- (void)reloadMidViewHeight:(NSNotification *)noti {
    [self.midView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(SCALE_SIZE(10));
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo([noti.userInfo[@"height"] integerValue]);
    }];

    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.midView.mas_bottom).offset(SCALE_SIZE(10));
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(288);
    }];

    [self.submitBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_bottom).offset(SCALE_SIZE(20));
        make.left.equalTo(self.view).offset(SCALE_SIZE(15));
        make.right.equalTo(self.view).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(48);
    }];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 508 + [noti.userInfo[@"height"] integerValue] + SCALE_SIZE(10) + 288 + SCALE_SIZE(60) + 48);
}

#pragma mark -- 提交
- (void)submitBtnClick:(UIButton *)btn {
    if (self.topView.farmerId == nil) {
        [YJProgressHUD showMessage:@"请选择养殖户" inView:self.view];
        return;
    }

    if (self.topView.contractId == nil) {
        [YJProgressHUD showMessage:@"请选择押金合同" inView:self.view];
        return;
    }

    if (self.midView.selectArray.count == 0) {
        [YJProgressHUD showMessage:@"请选择设备" inView:self.view];
        return;
    }

    if (self.midView.deviceCount == 0) {
        [YJProgressHUD showMessage:@"请选择设备数量" inView:self.view];
        return;
    }

    if (self.bottomView.addrTF.text.length == 0) {
        [YJProgressHUD showMessage:@"请选择安装地址" inView:self.view];
        return;
    }

    if (self.bottomView.operationPeopleStr == nil) {
        [YJProgressHUD showMessage:@"请选择运维管家" inView:self.view];
        return;
    }

    if (self.bottomView.installTimeStr == nil) {
        [YJProgressHUD showMessage:@"请选择安装时间" inView:self.view];
        return;
    }

    [YJProgressHUD showProgressCircleNoValue:@"提交中..." inView:self.view];
    NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
    NSMutableArray *deviceList = [[NSMutableArray alloc] init];
    for (NSString *deviceInfo in self.midView.selectArray) {
        NSArray *array = [deviceInfo componentsSeparatedByString:@"+"]; //从字符A中分隔成2个元素的数组
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:array[1] forKey:@"deviceCount"];
        [dict setObject:array[0] forKey:@"deviceTypeId"];
        [dict setObject:array[2] forKey:@"deviceTypeName"];
        [deviceList addObject:dict];
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:self.topView.farmerId forKey:@"farmerId"];
    [dict setObject:self.bottomView.addrStr forKey:@"installAddress"];
    [dict setObject:@(self.lat) forKey:@"latitude"];
    [dict setObject:@(self.lng) forKey:@"longitude"];
    [dict setObject:loginId forKey:@"loginid"];
    [dict setObject:self.topView.contractId forKey:@"contractId"];
    [dict setObject:self.bottomView.memIdStr forKey:@"memId"];
    [dict setObject:self.bottomView.installTimeStr forKey:@"reckonDate"];
    [dict setObject:deviceList forKey:@"deviceList"];
    if (self.bottomView.serviceSumStr != nil) {
       [dict setObject:self.bottomView.serviceSumStr forKey:@"serviceAmount"];
    } else {
        [dict setObject:@"0" forKey:@"serviceAmount"];
    }
    if (self.bottomView.depositSumStr != nil) {
        [dict setObject:self.bottomView.depositSumStr forKey:@"depositAmount"];
    } else {
        [dict setObject:@"0" forKey:@"depositAmount"];
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:loginId forKey:@"loginid"];
    [params setObject:self.topView.farmerId forKey:@"farmerId"];
    [params setObject:dict forKey:@"appData"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/createTask/PRO00011527662267836", kUrl_Base];
    [[JKHttpTool shareInstance] PostReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"1"]) {
            JKSuccessVC *sVC = [[JKSuccessVC alloc] init];
            sVC.farmerId = self.topView.farmerId;
            sVC.farmerName = self.topView.farmerName;
            sVC.farmerAdd = self.topView.addr;
            sVC.farmerTel = self.topView.tel;
            sVC.successType = JKSuccessInstallOrder;
            [self.navigationController pushViewController:sVC animated:YES];
        } else {
            [YJProgressHUD showMsgWithImage:@"安装失败" imageName:iFailPath inview:self.view];
        }
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- 选择养殖户
- (void)chooseFarmers {
    JKContractFarmersVC *cfVC = [[JKContractFarmersVC alloc] init];
    cfVC.contractType = JKContractTypeInstallation;
    cfVC.delegate = self;
    [self.navigationController pushViewController:cfVC animated:YES];
}

#pragma mark -- JKContractFarmersVCDelegate
- (void)popContractFarmerAddr:(NSString *)addr withContractInfo:(NSString *)contractInfo withFarmerName:(NSString *)farmerName withFarmerId:(NSString *)farmerId {
    self.farmerId = farmerId;
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadAddrAndTel" object:nil userInfo:@{@"addr":addr, @"contractInfo":contractInfo, @"farmerName":farmerName, @"farmerId":farmerId}]];
}

#pragma mark -- 选择合同
- (void)chooseContracts {
    JKContractView *cV = [[JKContractView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withContractType:JKContractTypeDeposit];
    cV.farmerId = self.farmerId;
    cV.delegate = self;
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: cV];
}

- (void)chooseContractServices {
    JKContractView *cV = [[JKContractView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withContractType:JKContractTypeService];
    cV.farmerId = self.farmerId;
    cV.delegate = self;
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: cV];
}

- (void)popContractModel:(JKContractModel *)model {
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadContractCell" object:nil userInfo:@{@"collectState":model.collectState,@"contractAmount":model.contractAmount,@"contractId":model.contractId,@"contractImage":model.contractImage,@"contractName":model.contractName,@"contractType":model.contractType}]];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadDeviceCell" object:nil userInfo:@{@"contractDeviceList":model.contractDeviceList}]];
}

- (void)popContractServiceModel:(JKContractModel *)model {
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadContractServiceCell" object:nil userInfo:@{@"collectState":model.collectState,@"contractAmount":model.contractAmount,@"contractId":model.contractId,@"contractImage":model.contractImage,@"contractName":model.contractName,@"contractType":model.contractType}]];
}

#pragma mark -- 选择运维人员
- (void)chooseOperationPeoples {
    JKChooseOperationPeoplesVC *copVC = [[JKChooseOperationPeoplesVC alloc] init];
    copVC.tag = 999;
    copVC.delegate = self;
    [self.navigationController pushViewController:copVC animated:YES];
}

- (void)popMemId:(NSString *)memId withMemName:(NSString *)memName {
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadOperationPeopleCell" object:nil userInfo:@{@"memId":memId,@"memName":memName}]];
}

#pragma mark -- 选择安装时间
- (void)chooseInstallationTime {
    JKDateTimePickerView *dtpV = [[JKDateTimePickerView alloc] init];
    dtpV.delegate = self;
    [self.view addSubview:dtpV];
    [dtpV showDateTimePickerView];
}

#pragma mark -- JKDateTimePickerViewDelegate
- (void)didClickFinishDateTimePickerView:(NSString *)date{
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadInstallTimeCell" object:nil userInfo:@{@"date":date}]];
}

#pragma mark -- 开始定位
- (void)startLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        //控制定位精度,越高耗电量越
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        // 总是授权
        [self.locationManager requestAlwaysAuthorization];
        self.locationManager.distanceFilter = 10.0f;
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
    }
}

//定位代理经纬度回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations[0];
    self.lat = newLocation.coordinate.latitude;
    self.lng = newLocation.coordinate.longitude;
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            //获取城市
            NSString *province = placemark.administrativeArea;
            NSString *city = placemark.locality;
            NSString *district = placemark.subLocality;
            NSString *town = placemark.thoroughfare;
            NSString *name = placemark.name;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            
            if (!district) {
                district = placemark.subAdministrativeArea;
            }
            
            if (!town) {
                town = placemark.subThoroughfare;
            }
            
            NSString *addr;
            if ([province isEqualToString:city]) {
                addr = [NSString stringWithFormat:@"%@%@%@",city,district,name];
            } else {
                addr = [NSString stringWithFormat:@"%@%@%@%@",province,city,district,name];
            }
            
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadLocationCell" object:nil userInfo:@{@"addr":addr}]];
            
            
        } else if (error == nil && [array count] == 0) {
            NSLog(@"No results were returned.");
        } else if (error != nil) {
            NSLog(@"An error occurred = %@", error);
        }
    }];
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}

#pragma mark -- 选择安装地点
- (void)locationAddr {
    JKGeoCodeSearchVC *gcsVC = [[JKGeoCodeSearchVC alloc] init];
    gcsVC.delegate = self;
    gcsVC.lat = self.lat + 0.006;
    gcsVC.lng = self.lng + 0.0065;
    [self.navigationController pushViewController:gcsVC animated:YES];
}

#pragma mark -- 返回安装地点
- (void)chooseAdddrInfo:(NSString *)info {
    NSArray *arr = [info componentsSeparatedByString:@","];
    self.lat = [arr[1] floatValue];
    self.lng = [arr[2] floatValue];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadLocationCell" object:nil userInfo:@{@"addr":arr[0]}]];
}

@end
