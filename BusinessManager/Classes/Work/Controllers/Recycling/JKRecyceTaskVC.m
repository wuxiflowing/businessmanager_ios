//
//  JKRecyceTaskVC.m
//  BusinessManager
//
//  Created by  on 2018/6/27.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKRecyceTaskVC.h"
#import "JKRecyceDeviceTopCell.h"
#import "JKRecyceDeviceBottomCell.h"
#import "JKRecyceDevicePendInfoCell.h"
#import "JKChooseFarmersVC.h"
#import "JKRecycePendInfoModel.h"
#import "JKContractFarmersVC.h"
#import "JKChooseOperationPeoplesVC.h"
#import "JKChooseRecyceDeviceVC.h"
#import "JKRecyceDevicesInfoCell.h"
#import "JKPondModel.h"

@interface JKRecyceTaskVC () <UITableViewDelegate, UITableViewDataSource, JKRecyceDeviceTopCellDelegate, JKRecyceDevicePendInfoCellDelegate, JKContractFarmersVCDelegate, JKRecyceDeviceBottomCellDelegate,JKChooseOperationPeoplesVCDelegate, JKChooseRecyceDeviceVCDelegate, JKRecyceDevicesInfoCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *recyceInfoArr;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) NSString *famerId;
@property (nonatomic, strong) NSMutableArray *fishPondList;
@property (nonatomic, strong) NSMutableArray *fishPondAllList;
@property (nonatomic, strong) JKRecyceDeviceBottomCell *rdvbCell;
@end

@implementation JKRecyceTaskVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kClearColor;
        _tableView.separatorColor = kBgColor;
        _tableView.tableFooterView = [[UIView alloc] init];
        if (@available(iOS 11, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}

- (NSMutableArray *)recyceInfoArr {
    if (!_recyceInfoArr) {
        _recyceInfoArr = [[NSMutableArray alloc] init];
    }
    return _recyceInfoArr;
}

- (NSMutableArray *)fishPondList {
    if (!_fishPondList) {
        _fishPondList = [[NSMutableArray alloc] init];
    }
    return _fishPondList;
}

- (NSMutableArray *)fishPondAllList {
    if (!_fishPondAllList) {
        _fishPondAllList = [[NSMutableArray alloc] init];
    }
    return _fishPondAllList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设备回收";
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark -- 提交
- (void)submitBtnClick:(UIButton *)btn {
    if (self.famerId == nil) {
        [YJProgressHUD showMessage:@"请选择养殖户" inView:self.view];
        return;
    }

    if (self.fishPondAllList.count == 0) {
        [YJProgressHUD showMessage:@"请选择设备" inView:self.view];
        return;
    }

    if (self.rdvbCell.bankName == nil) {
        [YJProgressHUD showMessage:@"请填写退款银行" inView:self.view];
        return;
    }

    if (self.rdvbCell.bankPerson == nil) {
        [YJProgressHUD showMessage:@"请填写退款户名" inView:self.view];
        return;
    }

    if (self.rdvbCell.bankAccount == nil) {
        [YJProgressHUD showMessage:@"请填写退款账号" inView:self.view];
        return;
    }
    
    NSMutableArray *fishPondList = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in self.fishPondAllList) {
        NSMutableDictionary *pondDic = [[NSMutableDictionary alloc] init];
        NSMutableArray *childArr = [[NSMutableArray alloc] init];
        NSArray *childDeviceArr = dict[@"childDeviceList"];
        for (NSDictionary *dic in childDeviceArr) {
            NSMutableDictionary *childDic = [[NSMutableDictionary alloc] init];
            [childDic setObject:dic[@"id"] forKey:@"deviceId"];
            [childDic setObject:dic[@"identifier"] forKey:@"identifier"];
            [childArr addObject:childDic];
        }
        [pondDic setObject:childArr forKey:@"deviceList"];
        [pondDic setObject:dict[@"pondId"] forKey:@"pondId"];
        [pondDic setObject:dict[@"maintainKeeperID"] forKey:@"maintainKeeperID"];
        [fishPondList addObject:pondDic];
    }
    
    NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:self.rdvbCell.bankAccount forKey:@"bankAccount"];
    [dict setObject:self.rdvbCell.bankName forKey:@"bankName"];
    [dict setObject:self.rdvbCell.bankPerson forKey:@"bankPerson"];
    [dict setObject:fishPondList forKey:@"fishPondList"];
    
    [dict setObject:self.rdvbCell.textV.text forKey:@"tarReson"];
    [dict setObject:self.famerId forKey:@"txtFarmerID"];
    [dict setObject:loginId forKey:@"txtHKID"];
    [dict setObject:[self.rdvbCell.selectArr componentsJoinedByString:@","] forKey:@"txtResMulti"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:loginId forKey:@"loginid"];
    [params setObject:self.famerId forKey:@"farmerId"];
    [params setObject:dict forKey:@"appData"];

    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/createTask/PRO00031527817388054", kUrl_Base];
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] PostReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"1"]) {
            [YJProgressHUD showMessage:@"提交成功" inView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [YJProgressHUD showMsgWithImage:responseObject[@"message"] imageName:iFailPath inview:self.view];
        }
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

- (void)saveSelectArr:(NSMutableArray *)arr {
    self.fishPondAllList = arr;

    NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:1];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark -- 选择养殖户
- (void)chooseFarmers {
    JKContractFarmersVC *cfVC = [[JKContractFarmersVC alloc] init];
    cfVC.contractType = JKContractTypeRecyce;
    cfVC.delegate = self;
    [self.navigationController pushViewController:cfVC animated:YES];
}

- (void)popContractFarmerId:(NSString *)farmerId withFarmerName:(NSString *)farmerName withFarmerAddr:(NSString *)addr withContractInfo:(NSString *)contractInfo {
    self.famerId = farmerId;
    
    [self getFishRawDatawithFarmerId:farmerId withFarmerName:farmerName withFarmerAddr:addr withContractInfo:contractInfo];
}

#pragma mark -- 鱼塘设备状态列表
- (void)getFishRawDatawithFarmerId:(NSString *)farmerId withFarmerName:(NSString *)farmerName withFarmerAddr:(NSString *)addr withContractInfo:(NSString *)contractInfo {
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/%@/pondData",kUrl_Base, farmerId];
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            
            NSArray *arr = responseObject[@"data"];
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadRecyceBaseInfo" object:nil userInfo:@{@"addr":addr, @"contractInfo":contractInfo, @"farmerName":farmerName, @"farmerId":farmerId, @"pondCount":[NSString stringWithFormat:@"%ld",arr.count]}]];
        }
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

//#pragma mark -- 选择运维人员
//- (void)chooseOperationPeople {
//    JKChooseOperationPeoplesVC *copVC = [[JKChooseOperationPeoplesVC alloc] init];
//    copVC.delegate = self;
//    [self.navigationController pushViewController:copVC animated:YES];
//}
//
//- (void)popMemId:(NSString *)memId withMemName:(NSString *)memName {
//    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadRecyceOperationPeople" object:nil userInfo:@{@"memId":memId,@"memName":memName}]];
//}

#pragma mark -- 编辑
- (void)addBtnClick:(UIButton *)btn {
    if (self.famerId == nil) {
        [YJProgressHUD showMessage:@"请选择养殖户" inView:self.view];
        return;
    }
    
    JKChooseRecyceDeviceVC *crdVC = [[JKChooseRecyceDeviceVC alloc] init];
    crdVC.delegate = self;
    crdVC.famerId = self.famerId;
    [self.navigationController pushViewController:crdVC animated:YES];
    
//    JKRecycePendInfoModel *model = [[JKRecycePendInfoModel alloc] init];
//    model.addrStr = @"";
//    [self.recyceInfoArr addObject:model];
    
//    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:btn.tag] withRowAnimation:UITableViewRowAnimationLeft];
//    [self.tableView reloadData];
}

//#pragma mark -- 删除
//- (void)deleteOrderWithNumber:(NSInteger)number {
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否删除当前的签约单?" preferredStyle:UIAlertControllerStyleAlert];
//
//    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//    }]];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        [self.recyceInfoArr removeObjectAtIndex:(number - 1)];
//        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:number] withRowAnimation:UITableViewRowAnimationLeft];
//        [self.tableView reloadData];
//    }]];
//
//    [self presentViewController:alertController animated:YES completion:nil];
//}

//#pragma mark -- 添加弹起
//- (void)keyboardWillShow:(NSNotification *)aNotification {
//    NSDictionary *userInfo = aNotification.userInfo;
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = aValue.CGRectValue;
//
//    [UIView animateWithDuration:1 animations:^ {
//        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.safeAreaTopView.mas_bottom);
//            make.left.right.equalTo(self.view);
//            make.bottom.equalTo(self.view).offset(- keyboardRect.size.height);
//        }];
//
//        [self.tableView setContentOffset:CGPointMake(0, self.tableView.bounds.size.height + keyboardRect.size.height) animated:NO];
//    }];
//}
//
//#pragma mark -- 键盘收回
//- (void)keyboardWillHide:(NSNotification *)aNotification {
//    [UIView animateWithDuration:1 animations:^ {
//        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.safeAreaTopView.mas_bottom);
//            make.left.right.equalTo(self.view);
//            make.bottom.equalTo(self.view).offset(10);
//        }];
//    }];
//}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerV = [[UIView alloc] init];
    footerV.backgroundColor = kBgColor;
    return footerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return 0;
    } else {
        return SCALE_SIZE(10);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 240;
    } else if (indexPath.section == 2) {
        return 438;
    } else if (indexPath.section == 3) {
        return 75;
    } else {
        if (self.fishPondAllList.count == 0) {
            return 48;
        } else {
            NSInteger rowCount = 0;
            for (NSDictionary * dict in self.fishPondAllList) {
                NSArray *arr = dict[@"childDeviceList"];
                rowCount += arr.count + 2;
            }
            return 48 + 48 + (self.fishPondAllList.count - 1) * 10 + rowCount * 48;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *ID = @"JKRecyceDeviceTopCell";
        JKRecyceDeviceTopCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKRecyceDeviceTopCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        return cell;
    } else if (indexPath.section == 2) {
        static NSString *ID = @"JKRecyceDeviceBottomCell";
        JKRecyceDeviceBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKRecyceDeviceBottomCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        self.rdvbCell = cell;
        return cell;
    } else if (indexPath.section == 3) {
        static NSString *ID = @"SubmitCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [self.submitBtn removeFromSuperview];
        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [submitBtn setTitle:@"提 交" forState:UIControlStateNormal];
        [submitBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        submitBtn.layer.cornerRadius = 4;
        submitBtn.layer.masksToBounds = YES;
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
        submitBtn.titleLabel.font = JKFont(14);
        [cell addSubview:submitBtn];
        [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.left.equalTo(cell).offset(SCALE_SIZE(15));
            make.right.equalTo(cell).offset(-SCALE_SIZE(15));
            make.height.mas_equalTo(40);
        }];
        self.submitBtn = submitBtn;
        
        return cell;
    } else {
        static NSString *ID = @"JKRecyceDevicesInfoCell";
        JKRecyceDevicesInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKRecyceDevicesInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.fishPondList = self.fishPondAllList;
        cell.delegate = self;
        return cell;
    }
}

#pragma mark -- 取消粘性效果
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        UITableView *tableview = (UITableView *)scrollView;
        CGFloat sectionHeaderHeight = 10;
        CGFloat sectionFooterHeight = 10;
        CGFloat offsetY = tableview.contentOffset.y;
        if (offsetY >= 0 && offsetY <= sectionHeaderHeight) {
            tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0);
        } else if (offsetY >= sectionHeaderHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight) {
            tableview.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0);
        } else if (offsetY >= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height) {
            tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight), 0);
        }
    }
}

@end
