//
//  JKOpenAccountVC.m
//  BusinessManager
//
//  Created by  on 2018/6/20.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKOpenAccountVC.h"
#import "JKOpenAccountView.h"
#import "JKAdministrativeRegionsVC.h"
#import "JKSuccessVC.h"

@interface JKOpenAccountVC () <JKOpenAccountViewDelegate, LYSDatePickerDelegate, LYSDatePickerDataSource, JKAdministrativeRegionsVCDelegate>
{
    BOOL _isFarmerSign;
    NSInteger _forAccountCount;
    NSInteger _forFarmerCount;
    NSInteger _forPondCount;
}
@property (nonatomic, strong) LYSDatePicker *pickerView;
@property (nonatomic, strong) NSString *currentBirthdayStr;
@property (nonatomic, strong) NSString *chooseBirthdayStr;
@property (nonatomic, strong) NSString *farmerHeadImgStr;
@property (nonatomic, strong) JKOpenAccountView *oaView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSMutableArray *imgArr;
@end

@implementation JKOpenAccountVC

- (NSMutableArray *)imgArr {
    if (!_imgArr) {
        _imgArr = [[NSMutableArray alloc] init];
    }
    return _imgArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"开户申请";
    
    _isFarmerSign = YES;
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = kBgColor;
    scrollView.scrollEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    JKOpenAccountView *oaView = [[JKOpenAccountView alloc] init];
    oaView.farmerIdStr = self.farmerIdStr;
    oaView.farmerNameStr = self.farmerNameStr;
    oaView.contactStr = self.contactStr;
    oaView.birthdayStr = self.birthdayStr;
    oaView.regionStr = self.regionStr;
    oaView.sexStr = self.sexStr;
    oaView.homeAddrStr = self.homeAddrStr;
    oaView.idNumberStr = self.idNumberStr;
    oaView.idPicture = self.idPicture;
    if (![self.picture isKindOfClass:[NSNull class]]) {
        self.picture = [self.picture stringByReplacingOccurrencesOfString:@" " withString:@""];
    } else {
        self.picture = @"";
    }
    oaView.picture = self.picture;
    self.pondPicture = [self.pondPicture stringByReplacingOccurrencesOfString:@" " withString:@""];
    oaView.pondPicture = self.pondPicture;
    oaView.delegate = self;
    [scrollView addSubview:oaView];
    [oaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView.mas_top);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(940);
    }];
    self.oaView = oaView;
    
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
        make.top.equalTo(oaView.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(SCALE_SIZE(15));
        make.right.equalTo(self.view).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(48);
    }];
    
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 940 + 40 + 48);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

#pragma mark -- 电话重复验证
- (void)checkPhoneNumber:(NSString *)phoneNumber {
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/checkPhoneNumber/%@",kUrl_Base, phoneNumber];

    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            if (self.oaView.idNumberStr != nil) {
                [self checkIdCard:self.oaView.idNumberStr];
            } else {
                [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
                if (self.oaView.imageFrontArr.count == 0 && self.oaView.imageBackgroundArr.count == 0 &&
                    self.oaView.imageAccountArr.count == 0 && self.oaView.imageFarmerArr.count == 0 &&
                    self.oaView.imagePondArr.count == 0) {
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
                    [dict setObject:loginId forKey:@"loginid"];
                    [dict setObject:self.oaView.farmerNameStr forKey:@"farmerName"];
                    [dict setObject:self.oaView.contactStr forKey:@"contactInfo"];
                    [dict setObject:self.oaView.birthdayStr forKey:@"birthday"];
                    if (self.oaView.sexStr == nil) {
                        [dict setObject:@"男" forKey:@"sex"];
                    } else {
                        [dict setObject:self.oaView.sexStr forKey:@"sex"];
                    }
                    [dict setObject:self.oaView.regionStr forKey:@"region"];
                    [dict setObject:self.oaView.homeAddrStr forKey:@"homeAddress"];
                    if (self.oaView.farmerIdStr != nil) {
                        [dict setObject:self.oaView.farmerIdStr forKey:@"farmerId"];
                    }
                    if (self.oaView.townIdStr != nil) {
                        [dict setObject:self.oaView.townIdStr forKey:@"areaId"];
                    }
                    [dict setObject:@"意向用户" forKey:@"farmerType"];
                    if (self.oaView.idNumberStr == nil) {
                        [dict setObject:@"" forKey:@"idNumber"];
                    } else {
                        [dict setObject:self.oaView.idNumberStr forKey:@"idNumber"];
                    }
                    
                    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                    [params setObject:loginId forKey:@"loginid"];
                    [params setObject:dict forKey:@"appData"];
                    
                    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/createTask/PRO00001527661500018", kUrl_Base];
                    
                    
                    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
                    [[JKHttpTool shareInstance] PostReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
                        [YJProgressHUD hide];
                        if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"1"]) {
                            JKSuccessVC *sVC = [[JKSuccessVC alloc] init];
                            sVC.successType = JKSuccessOpenAccount;
                            sVC.isGeneral = YES;
                            [self.navigationController pushViewController:sVC animated:YES];
                        } else {
                            [YJProgressHUD showMsgWithImage:responseObject[@"message"] imageName:iFailPath inview:self.view];
                        }
                    } withFailureBlock:^(NSError *error) {
                        [YJProgressHUD hide];
                    }];
                } else {
                    [self getImgUrl];
                }
            }
        } else {
            [YJProgressHUD showMessage:responseObject[@"message"] inView:self.view];
        }
    } withFailureBlock:^(NSError *error) {

    }];
}

#pragma mark -- 身份证重复验证
- (void)checkIdCard:(NSString *)idCard {
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/checkIdCard/%@",kUrl_Base, idCard];

    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
            if (self.oaView.imageFrontArr.count == 0 && self.oaView.imageBackgroundArr.count == 0 &&
                self.oaView.imageAccountArr.count == 0 && self.oaView.imageFarmerArr.count == 0 &&
                self.oaView.imagePondArr.count == 0) {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
                [dict setObject:loginId forKey:@"loginid"];
                [dict setObject:self.oaView.farmerNameStr forKey:@"farmerName"];
                [dict setObject:self.oaView.contactStr forKey:@"contactInfo"];
                [dict setObject:self.oaView.birthdayStr forKey:@"birthday"];
                if (self.oaView.sexStr == nil) {
                    [dict setObject:@"男" forKey:@"sex"];
                } else {
                    [dict setObject:self.oaView.sexStr forKey:@"sex"];
                }
                [dict setObject:self.oaView.regionStr forKey:@"region"];
                [dict setObject:self.oaView.homeAddrStr forKey:@"homeAddress"];
                if (self.oaView.farmerIdStr != nil) {
                    [dict setObject:self.oaView.farmerIdStr forKey:@"farmerId"];
                }
                if (self.oaView.townIdStr != nil) {
                    [dict setObject:self.oaView.townIdStr forKey:@"areaId"];
                }
                [dict setObject:@"意向用户" forKey:@"farmerType"];
                if (self.oaView.idNumberStr == nil) {
                    [dict setObject:@"" forKey:@"idNumber"];
                } else {
                    [dict setObject:self.oaView.idNumberStr forKey:@"idNumber"];
                }
                //            [dict setObject:self.imgArr forKey:@"url"];
                
                NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                [params setObject:loginId forKey:@"loginid"];
                [params setObject:dict forKey:@"appData"];
                
                NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/createTask/PRO00001527661500018", kUrl_Base];
                
                [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
                [[JKHttpTool shareInstance] PostReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
                    [YJProgressHUD hide];
                    if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"1"]) {
                        JKSuccessVC *sVC = [[JKSuccessVC alloc] init];
                        sVC.successType = JKSuccessOpenAccount;
                        sVC.isGeneral = YES;
                        [self.navigationController pushViewController:sVC animated:YES];
                    } else {
                        [YJProgressHUD showMsgWithImage:responseObject[@"message"] imageName:iFailPath inview:self.view];
                    }
                } withFailureBlock:^(NSError *error) {
                    [YJProgressHUD hide];
                }];
            } else {
                [self getImgUrl];
            }
        } else {
            [YJProgressHUD showMessage:responseObject[@"message"] inView:self.view];
        }
    } withFailureBlock:^(NSError *error) {

    }];
}

- (void)submitBtnClick:(UIButton *)btn {
    if (self.oaView.farmerNameStr == nil) {
        [YJProgressHUD showMessage:@"请输入姓名" inView:self.view];
        return;
    }

    if (self.oaView.contactStr == nil) {
        [YJProgressHUD showMessage:@"请输入联系方式" inView:self.view];
        return;
    }

    if (self.oaView.birthdayStr == nil) {
        [YJProgressHUD showMessage:@"请输入出生日期" inView:self.view];
        return;
    }

    if (self.oaView.regionStr == nil) {
        [YJProgressHUD showMessage:@"请选择行政区域" inView:self.view];
        return;
    }

    if (self.oaView.homeAddrStr == nil) {
        [YJProgressHUD showMessage:@"请输入家庭详细地址" inView:self.view];
        return;
    }
    
    if (self.oaView.contactStr.length != 11) {
        [YJProgressHUD showMessage:@"请输入合法联系方式" inView:self.view];
        return;
    }
    
    if (![self.oaView.idNumberStr isKindOfClass:[NSNull class]]) {
        if (self.oaView.idNumberStr.length != 0) {
            if (self.oaView.idNumberStr.length != 18) {
                [YJProgressHUD showMessage:@"请输入合法身份证号" inView:self.view];
                return;
            }
        }
    }
    
    if (!self.isGeneral) {
        [self checkPhoneNumber:self.oaView.contactStr];
    } else {
        [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
        if (self.oaView.imageFrontArr.count == 0 && self.oaView.imageBackgroundArr.count == 0 &&
            self.oaView.imageAccountArr.count == 0 && self.oaView.imageFarmerArr.count == 0 &&
            self.oaView.imagePondArr.count == 0) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
            [dict setObject:loginId forKey:@"loginid"];
            [dict setObject:self.oaView.farmerNameStr forKey:@"farmerName"];
            [dict setObject:self.oaView.contactStr forKey:@"contactInfo"];
            [dict setObject:self.oaView.birthdayStr forKey:@"birthday"];
            if (self.oaView.sexStr == nil) {
                [dict setObject:@"男" forKey:@"sex"];
            } else {
                [dict setObject:self.oaView.sexStr forKey:@"sex"];
            }
            [dict setObject:self.oaView.regionStr forKey:@"region"];
            [dict setObject:self.oaView.homeAddrStr forKey:@"homeAddress"];
            if (self.oaView.farmerIdStr != nil) {
                [dict setObject:self.oaView.farmerIdStr forKey:@"farmerId"];
            }
            if (self.oaView.townIdStr != nil) {
                [dict setObject:self.oaView.townIdStr forKey:@"areaId"];
            }
            [dict setObject:@"意向用户" forKey:@"farmerType"];
            if (self.oaView.idNumberStr == nil) {
                [dict setObject:@"" forKey:@"idNumber"];
            } else {
                [dict setObject:self.oaView.idNumberStr forKey:@"idNumber"];
            }
            //            [dict setObject:self.imgArr forKey:@"url"];

            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            [params setObject:loginId forKey:@"loginid"];
            [params setObject:dict forKey:@"appData"];
            NSLog(@"%@",params);

            NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/createTask/PRO00001527661500018", kUrl_Base];

            [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
            [[JKHttpTool shareInstance] PostReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
                [YJProgressHUD hide];
                if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"1"]) {
                    JKSuccessVC *sVC = [[JKSuccessVC alloc] init];
                    sVC.successType = JKSuccessOpenAccount;
                    sVC.isGeneral = YES;
                    [self.navigationController pushViewController:sVC animated:YES];
                } else {
                    [YJProgressHUD showMsgWithImage:responseObject[@"message"] imageName:iFailPath inview:self.view];
                }
            } withFailureBlock:^(NSError *error) {
                [YJProgressHUD hide];
            }];
        } else {
            [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self getImgUrl];
            });
        }
    }
}

#pragma mark -- 获取图片URL
- (void)getImgUrl {
    [self.imgArr removeAllObjects];
    if (self.oaView.imageFrontArr.count != 0) {
        [self saveImage:self.oaView.imageFrontArr withImageType:JKImageTypeIDFront];
    }
    
    if (self.oaView.imageBackgroundArr.count != 0) {
        [self saveImage:self.oaView.imageBackgroundArr withImageType:JKImageTypeIDBackground];
    }
    
    if (self.oaView.imageAccountArr.count != 0) {
        [self saveImage:self.oaView.imageAccountArr withImageType:JKImageTypeAccount];
    }
    
    if (self.oaView.imageFarmerArr.count != 0) {
        [self saveImage:self.oaView.imageFarmerArr withImageType:JKImageTypeFarmer];
    }
    
    if (self.oaView.imagePondArr.count != 0) {
        [self saveImage:self.oaView.imagePondArr withImageType:JKImageTypePond];
    }
}

- (void)saveImage:(NSArray *)imgArr withImageType:(JKImageType)imageType {
    if (imageType == JKImageTypeIDFront || imageType == JKImageTypeIDBackground) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"ID" forKey:@"type"];
        if (imageType == JKImageTypeIDBackground) {
            [params setObject:[NSString stringWithFormat:@"%ld.jpg",(long)[JKToolKit getNowTimestamp] - 5] forKey:@"imageName"];
        } else {
            [params setObject:[NSString stringWithFormat:@"%ld.jpg",(long)[JKToolKit getNowTimestamp]] forKey:@"imageName"];
        }
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        if ([[NSString stringWithFormat:@"%@",imgArr[0]] hasPrefix:@"http"]) {
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgArr[0]]];
            UIImage * result = [UIImage imageWithData:data];
            [arr addObject:result];
        } else {
            [arr addObject:imgArr[0]];
        }
        [params setObject:[JKToolKit imageToString:arr[0]] forKey:@"imageData"];
        NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
        NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/%@/uploadImage", kUrl_Base, loginId];
        [[JKHttpTool shareInstance] PostReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
            [self.imgArr addObject:responseObject[@"data"]];
            [self submitInfo];
        } withFailureBlock:^(NSError *error) {
            
        }];
    }
    
    if (imageType == JKImageTypeAccount) {
        _forAccountCount = 0;
        [self getImgArr:imgArr withIndex:_forAccountCount withType:@"account"];
    }
    
    if (imageType == JKImageTypeFarmer) {
        _forFarmerCount = 0;
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (NSString *imgUrl in imgArr) {
            if ([[NSString stringWithFormat:@"%@",imgUrl] hasPrefix:@"http"]) {
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
                UIImage * result = [UIImage imageWithData:data];
                [arr addObject:result];
            } else {
                [arr addObject:imgUrl];
            }
        }
        [self getImgArr:arr withIndex:_forFarmerCount withType:@"farmer"];
    }
    
    if (imageType == JKImageTypePond) {
        _forPondCount = 0;
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (NSString *imgUrl in imgArr) {
            if ([[NSString stringWithFormat:@"%@",imgUrl] hasPrefix:@"http"]) {
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
                UIImage * result = [UIImage imageWithData:data];
                [arr addObject:result];
            } else {
                [arr addObject:imgUrl];
            }
        }
        [self getImgArr:arr withIndex:_forPondCount withType:@"pond"];
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
        
        if ([type isEqualToString:@"account"]) {
            _forAccountCount++;
            if (_forAccountCount == self.oaView.imageAccountArr.count) {
                [self submitInfo];
            } else {
                [self getImgArr:imgArr withIndex:_forAccountCount withType:@"account"];
            }
        } else if ([type isEqualToString:@"farmer"]) {
            _forFarmerCount++;
            if (_forFarmerCount == self.oaView.imageFarmerArr.count) {
                self.farmerHeadImgStr = responseObject[@"data"];
                [self submitInfo];
            } else {
                [self getImgArr:imgArr withIndex:_forFarmerCount withType:@"farmer"];
            }
        } else if ([type isEqualToString:@"pond"]) {
            _forPondCount++;
            if (_forPondCount == self.oaView.imagePondArr.count) {
                [self submitInfo];
            } else {
                [self getImgArr:imgArr withIndex:_forPondCount withType:@"pond"];
            }
        }
    } withFailureBlock:^(NSError *error) {
        
    }];
}

- (void)submitInfo {
    NSInteger count = self.oaView.imageFrontArr.count +
    self.oaView.imageBackgroundArr.count +
    self.oaView.imageAccountArr.count +
    self.oaView.imageFarmerArr.count +
    self.oaView.imagePondArr.count;
    if (count == self.imgArr.count) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
        [dict setObject:loginId forKey:@"loginid"];
        [dict setObject:self.oaView.farmerNameStr forKey:@"farmerName"];
        [dict setObject:self.oaView.contactStr forKey:@"contactInfo"];
        [dict setObject:self.oaView.birthdayStr forKey:@"birthday"];
        if (self.oaView.sexStr == nil) {
            [dict setObject:@"男" forKey:@"sex"];
        } else {
            [dict setObject:self.oaView.sexStr forKey:@"sex"];
        }
        [dict setObject:self.oaView.regionStr forKey:@"region"];
        [dict setObject:self.oaView.homeAddrStr forKey:@"homeAddress"];
        if (self.oaView.farmerIdStr != nil) {
           [dict setObject:self.oaView.farmerIdStr forKey:@"farmerId"];
        }
        if (self.oaView.townIdStr != nil) {
           [dict setObject:self.oaView.townIdStr forKey:@"areaId"];
        }
        if (self.oaView.imageAccountArr.count == 0) {
            [dict setObject:@"意向用户" forKey:@"farmerType"];
        } else {
            [dict setObject:@"签约用户" forKey:@"farmerType"];
        }
        if (self.oaView.imageAccountArr.count != 0) {
            if (self.oaView.idNumberStr == nil) {
                [YJProgressHUD showMessage:@"请输入身份证号" inView:self.view];
                return;
            }
            
            if (self.oaView.imageFrontArr.count == 0) {
                [YJProgressHUD showMessage:@"请上传身份证正面" inView:self.view];
                return;
            }
            
            if (self.oaView.imageBackgroundArr.count == 0) {
                [YJProgressHUD showMessage:@"请上传身份证背面" inView:self.view];
                return;
            }
        }
        [dict setObject:self.oaView.idNumberStr forKey:@"idNumber"];
        [dict setObject:self.imgArr forKey:@"url"];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:loginId forKey:@"loginid"];
        [params setObject:dict forKey:@"appData"];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/createTask/PRO00001527661500018", kUrl_Base];

        [[JKHttpTool shareInstance] PostReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
            [YJProgressHUD hide];
            if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"1"]) {
                if (self.oaView.imageAccountArr.count == 0) {
                    JKSuccessVC *sVC = [[JKSuccessVC alloc] init];
                    sVC.successType = JKSuccessOpenAccount;
                    sVC.isGeneral = YES;
                    [self.navigationController pushViewController:sVC animated:YES];
                } else {
                    [self getFarmerId:[NSString stringWithFormat:@"%@",responseObject[@"data"]]];
                }
            } else {
                [YJProgressHUD showMsgWithImage:responseObject[@"message"] imageName:iFailPath inview:self.view];
            }
        } withFailureBlock:^(NSError *error) {
            [YJProgressHUD hide];
        }];
    }
}

#pragma mark -- 任务详情
- (void)getFarmerId:(NSString *)tskID {
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/mytask/%@/data",kUrl_Base,tskID];
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            JKSuccessVC *sVC = [[JKSuccessVC alloc] init];
            sVC.successType = JKSuccessOpenAccount;
            sVC.isGeneral = NO;
            sVC.farmerId = responseObject[@"data"][@"txtFarmerID"];
            sVC.farmerName = self.oaView.farmerNameStr;
            sVC.farmerAdd = [NSString stringWithFormat:@"%@%@",self.oaView.regionStr,self.oaView.homeAddrStr];
            sVC.farmerTel = self.oaView.contactStr;
            if (self.farmerHeadImgStr != nil || self.farmerHeadImgStr.length != 0) {
                sVC.farmerPic = self.farmerHeadImgStr;
            }
            [self.navigationController pushViewController:sVC animated:YES];
        }
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- JKOpenAccountViewDelegate
- (void)chooseRegions {
    JKAdministrativeRegionsVC *arVC = [[JKAdministrativeRegionsVC alloc] init];
    arVC.delegate = self;
    [self.navigationController pushViewController:arVC animated:YES];
}

#pragma mark -- JKAdministrativeRegionsVCDelegate
- (void)popRegion:(NSString *)region withTownId:(NSString *)townIdStr {
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadRegion" object:nil userInfo:@{@"regionStr":region, @"townId":townIdStr}]];
}

#pragma mark -- JKOpenAccountViewDelegate
- (void)chooseBirthday {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = kBlackColor;
    bgView.alpha = 0.3;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    self.bgView = bgView;
    
    LYSDatePicker *pickerView = [[LYSDatePicker alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 256, SCREEN_WIDTH, 256) type:(LYSDatePickerTypeCustom)];
    pickerView.datePickerMode = LYSDatePickerModeYearAndDate;
    
    LYSDateHeaderBarItem *cancelItem = [[LYSDateHeaderBarItem alloc] initWithTitle:@"取消" target:self action:@selector(cancelAction:)];
    cancelItem.tintColor = kGrayColor;
    cancelItem.font = JKFont(15);
    
    LYSDateHeaderBarItem *commitItem = [[LYSDateHeaderBarItem alloc] initWithTitle:@"确定" target:self action:@selector(commitAction:)];
    commitItem.tintColor = kThemeColor;
    commitItem.font = JKFont(15);
    
    LYSDateHeaderBar *headerBar = [[LYSDateHeaderBar alloc] init];
    headerBar.leftBarItem = cancelItem;
    headerBar.rightBarItem = commitItem;
    headerBar.title = @"";
    headerBar.titleColor = RGBHex(0x333333);
    headerBar.titleFont = JKFont(16);
    
    pickerView.headerView.headerBar = headerBar;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [self.view addSubview:pickerView];
    self.pickerView = pickerView;
}

#pragma mark -- LYSDatePickerDataSource
- (void)datePicker:(LYSDatePicker *)pickerView didSelectDate:(NSDate *)date {
    self.currentBirthdayStr = [NSString stringWithFormat:@"%@",date];
}

#pragma mark -- 选择出生日期
- (void)commitAction:(UIButton *)btn {
    if (self.currentBirthdayStr != nil) {
        self.chooseBirthdayStr = [self.currentBirthdayStr substringToIndex:10];
    } else {
        self.chooseBirthdayStr = [[NSString stringWithFormat:@"%@",[NSDate date]] substringToIndex:10];
    }
    
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadBirthday" object:nil userInfo:@{@"birthdayStr":self.chooseBirthdayStr}]];
    
    [self.pickerView removeFromSuperview];
    [self.bgView removeFromSuperview];
}

#pragma mark -- 移除LYSDatePicker
- (void)cancelAction:(UIButton *)btn {
    [self.pickerView removeFromSuperview];
    [self.bgView removeFromSuperview];
}

@end
