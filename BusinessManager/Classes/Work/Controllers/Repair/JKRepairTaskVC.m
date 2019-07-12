//
//  JKRepairTaskVC.m
//  BusinessManager
//
//  Created by  on 2018/6/27.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKRepairTaskVC.h"
#import "JKRepairTopView.h"
#import "JKRepairBottomView.h"
#import "JKChooseFarmersVC.h"
#import "JKContractFarmersVC.h"
#import "JKChooseOperationPeoplesVC.h"
#import "JKPondDeviceView.h"
#import "JKPondModel.h"

@interface JKRepairTaskVC () <JKRepairTopViewDelegate, JKContractFarmersVCDelegate, JKRepairBottomViewDelegate, JKChooseOperationPeoplesVCDelegate,JKPondDeviceViewDelegate>
{
    NSInteger _forRepairCount;
}
@property (nonatomic, strong) NSString *farmerId;
@property (nonatomic, strong) NSString *pondId;
@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, strong) JKRepairTopView *rtV;
@property (nonatomic, strong) JKRepairBottomView *rbV;
@property (nonatomic, strong) NSMutableArray *imgArr;
@end

@implementation JKRepairTaskVC

- (NSMutableArray *)imgArr {
    if (!_imgArr) {
        _imgArr = [[NSMutableArray alloc] init];
    }
    return _imgArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"故障保修";
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = kBgColor;
    scrollView.scrollEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    JKRepairTopView *rtV = [[JKRepairTopView alloc] init];
    rtV.delegate = self;
    [scrollView addSubview:rtV];
    [rtV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView.mas_top);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(192);
    }];
    self.rtV = rtV;
    
    JKRepairBottomView *rbV = [[JKRepairBottomView alloc] init];
    rbV.delegate = self;
    [scrollView addSubview:rbV];
    [rbV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rtV.mas_bottom).offset(SCALE_SIZE(10));
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(566);
    }];
    self.rbV = rbV;
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"提 交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.layer.cornerRadius = 4;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
    [scrollView addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rbV.mas_bottom).offset(SCALE_SIZE(20));
        make.left.equalTo(self.view).offset(SCALE_SIZE(15));
        make.right.equalTo(self.view).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(48);
    }];
    
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 192 + 566 + 40 + 48);
}

#pragma mark -- 提交
- (void)submitBtnClick:(UIButton *)btn {
    if (self.farmerId == nil) {
        [YJProgressHUD showMessage:@"请选择养殖户" inView:self.view];
        return;
    }

    if (self.rbV.pondId == nil) {
        [YJProgressHUD showMessage:@"请选择鱼塘" inView:self.view];
        return;
    }

    if (self.rbV.deviceId == nil) {
        [YJProgressHUD showMessage:@"请选择设备" inView:self.view];
        return;
    }

    if (self.rbV.operationPeopleId == nil) {
        [YJProgressHUD showMessage:@"请选择运维管家" inView:self.view];
        return;
    }
    
    if (self.rbV.imageRepaireArr.count != 0) {
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:window];
        [self.imgArr removeAllObjects];
        _forRepairCount = 0;
        [self getImgArr:self.rbV.imageRepaireArr withIndex:_forRepairCount withType:@"repair"];
    } else {
        NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:loginId forKey:@"loginid"];
        [dict setObject:self.farmerId forKey:@"farmerId"];
        [dict setObject:self.rbV.pondId forKey:@"pondId"];
        [dict setObject:self.rbV.deviceId forKey:@"deviceId"];
        [dict setObject:self.rbV.operationPeopleId forKey:@"memId"];
        if (self.rbV.textV.text.length != 0) {
            [dict setObject:self.rbV.textV.text forKey:@"reason"];
        }
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:loginId forKey:@"loginid"];
        [params setObject:self.farmerId forKey:@"farmerId"];
        [params setObject:dict forKey:@"appData"];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/createTask/PRO00281532487186962", kUrl_Base];
        
        [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
        [[JKHttpTool shareInstance] PostReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
            [YJProgressHUD hide];
            if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"1"]) {
                [YJProgressHUD showMessage:@"提交成功" inView:self.view afterDelayTime:2];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } else {
                [YJProgressHUD showMsgWithImage:@"提交失败" imageName:iFailPath inview:self.view];
            }
        } withFailureBlock:^(NSError *error) {
            [YJProgressHUD hide];
        }];
    }
}

- (void)getImgArr:(NSArray *)imgArr withIndex:(NSInteger)tag withType:(NSString *)type {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:type forKey:@"type"];
    int x = arc4random() % 1000;
    [params setObject:[NSString stringWithFormat:@"%ld.jpg",[JKToolKit getNowTimestamp] + x] forKey:@"imageName"];
    [params setObject:[JKToolKit imageToString:imgArr[tag]] forKey:@"imageData"];
    NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/%@/uploadImage", kUrl_Base, loginId];
    [[JKHttpTool shareInstance] PostReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
        [self.imgArr addObject:responseObject[@"data"]];
        
        _forRepairCount++;
        if (_forRepairCount == self.rbV.imageRepaireArr.count) {
            [self submitInfo];
        } else {
            [self getImgArr:imgArr withIndex:_forRepairCount withType:@"repair"];
        }
    } withFailureBlock:^(NSError *error) {
        
    }];
}

- (void)submitInfo {
    NSInteger count = self.rbV.imageRepaireArr.count;
    if (count == self.imgArr.count)  {
        NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:loginId forKey:@"loginid"];
        [dict setObject:self.farmerId forKey:@"farmerId"];
        [dict setObject:self.rbV.pondId forKey:@"pondId"];
        [dict setObject:self.rbV.deviceId forKey:@"deviceId"];
        [dict setObject:self.rbV.operationPeopleId forKey:@"memId"];
        if (self.rbV.textV.text.length != 0) {
            [dict setObject:self.rbV.textV.text forKey:@"reason"];
        }
        [dict setObject:self.imgArr forKey:@"url"];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:loginId forKey:@"loginid"];
        [params setObject:self.farmerId forKey:@"farmerId"];
        [params setObject:dict forKey:@"appData"];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/createTask/PRO00281532487186962", kUrl_Base];
        
        [[JKHttpTool shareInstance] PostReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
            [YJProgressHUD hide];
            if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"1"]) {
                [YJProgressHUD showMessage:@"提交成功" inView:self.view afterDelayTime:2];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } else {
                [YJProgressHUD showMsgWithImage:@"提交失败" imageName:iFailPath inview:self.view];
            }
        } withFailureBlock:^(NSError *error) {
            [YJProgressHUD hide];
        }];
    }
}

#pragma mark -- 选择养殖户
- (void)chooseFarmers {
    JKContractFarmersVC *cfVC = [[JKContractFarmersVC alloc] init];
    cfVC.contractType = JKContractTypeRepaire;
    cfVC.delegate = self;
    [self.navigationController pushViewController:cfVC animated:YES];
}

#pragma mark -- 选择鱼塘
- (void)choosePond {
    if (self.farmerId == nil) {
        [YJProgressHUD showMessage:@"请选择养殖户" inView:self.view];
        return;
    }
    JKPondDeviceView *pdV = [[JKPondDeviceView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    pdV.farmerId = self.farmerId;
    pdV.isPond = YES;
    pdV.delegate = self;
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: pdV];
}

- (void)popPondModel:(JKPondModel *)model withTag:(NSInteger)tag{
    self.pondId = model.pondId;
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadPondCell" object:nil userInfo:@{@"pondId":model.pondId,@"pondName":model.name, @"pondAddr":model.pondAddress, @"phone":model.phoneNumber, @"tag":[NSString stringWithFormat:@"%ld",tag]}]];
}

#pragma mark -- 选择设备ID
- (void)chooseDeviceId:(NSInteger)tag {
    if (self.pondId == nil) {
        [YJProgressHUD showMessage:@"请选择鱼塘" inView:self.view];
        return;
    }
    JKPondDeviceView *pdV = [[JKPondDeviceView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    pdV.farmerId = self.farmerId;
    pdV.isPond = NO;
    pdV.deviceTag = tag;
    pdV.delegate = self;
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: pdV];
}

- (void)popDeviceModel:(JKPondChildDeviceModel *)model {
    self.deviceId = model.ident;
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadDeviceCell" object:nil userInfo:@{@"deviceId":model.ident,@"deviceName":model.name, @"deviceType":model.type}]];
}

#pragma mark -- 选择运维人员
-(void)chooseOperationPeople {
    if (self.deviceId == nil) {
        [YJProgressHUD showMessage:@"请选择设备ID" inView:self.view];
        return;
    }
    JKChooseOperationPeoplesVC *copVC = [[JKChooseOperationPeoplesVC alloc] init];
    copVC.tag = 999;
    copVC.delegate = self;
    [self.navigationController pushViewController:copVC animated:YES];
}

- (void)popMemId:(NSString *)memId withMemName:(NSString *)memName {
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadRepaireOperationPeopleCell" object:nil userInfo:@{@"memId":memId,@"memName":memName}]];
}

#pragma mark -- JKContractFarmersVCDelegate
- (void)popContractFarmerAddr:(NSString *)addr withContractInfo:(NSString *)contractInfo withFarmerName:(NSString *)farmerName withFarmerId:(NSString *)farmerId {
    self.farmerId = farmerId;
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadRepaireAddrAndTel" object:nil userInfo:@{@"addr":addr, @"contractInfo":contractInfo, @"farmerName":farmerName, @"farmerId":farmerId}]];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadRepaireBottomView" object:nil userInfo:nil]];
}

@end
