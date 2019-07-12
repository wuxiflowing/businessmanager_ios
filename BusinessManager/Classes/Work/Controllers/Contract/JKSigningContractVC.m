//
//  JKSigningContractVC.m
//  BusinessManager
//
//  Created by  on 2018/6/27.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKSigningContractVC.h"
#import "JKWorkTopCell.h"
#import "JKOpenAccountOrderCell.h"
#import "JKContractModel.h"
#import "JKSuccessVC.h"

@interface JKSigningContractVC () <UITableViewDelegate, UITableViewDataSource, JKOpenAccountOrderCellDelegate, JKDateTimePickerViewDelegate, JKWorkTopCellDelegate>
{
    CGFloat _cellHeight;
    NSInteger _section;
    NSInteger _contractImgCount;
    NSInteger _payImgCount;
    NSInteger _contractCount;
    NSInteger _forCount; //for循环开关
    NSInteger _forcontractCount; //for循环开关
    NSInteger _forpayCount; //for循环开关
    CGFloat _deviceListCellHeight;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSMutableArray *contractInfoArr;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) NSMutableArray *imgArr;
@property (nonatomic, strong) NSMutableArray *contractArr;
@end

@implementation JKSigningContractVC

- (NSMutableArray *)imgArr {
    if (!_imgArr) {
        _imgArr = [[NSMutableArray alloc] init];
    }
    return _imgArr;
}

- (NSMutableArray *)contractArr {
    if (!_contractArr) {
        _contractArr = [[NSMutableArray alloc] init];
    }
    return _contractArr;
}

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

- (NSMutableArray *)contractInfoArr {
    if (!_contractInfoArr) {
        _contractInfoArr = [[NSMutableArray alloc] init];
    }
    return _contractInfoArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"签约资料";
    _payImgCount = 0;
    _contractImgCount = 0;
    _contractCount = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMidViewHeight:)name:@"reloadMidViewHeight" object:nil];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-10);
    }];
}

#pragma mark -- 提交
- (void)submitBtnClick:(UIButton *)btn {
    if (self.contractInfoArr.count == 0) {
        [YJProgressHUD showMessage:@"请新增合同类型" inView:self.view];
        return;
    }
    
    _contractCount = self.contractInfoArr.count;
    _forCount = 0;
    [self.contractArr removeAllObjects];
    [self submitInfoWithIndex:_forCount];
}

- (void)submitInfoWithIndex:(NSInteger)count {
    [self.imgArr removeAllObjects];
    JKContractModel *model = self.contractInfoArr[count];
    
    if (model.contractType == nil || model.contractDateStr == nil || model.contractName == nil || model.contractAmountStr == nil || model.contractDeviceList.count == 0) {
        [YJProgressHUD showMessage:@"请完善签约单资料" inView:self.view];
        return;
    }

    if (model.paymentMethod != nil) {
        if (model.actualAmountStr == nil) {
            [YJProgressHUD showMessage:@"请完善签约单资料" inView:self.view];
            return;
        }
    }
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    if (model.contractImgArr.count == 0) {
        [self getContractInfoNoImg];
    } else {
        _contractImgCount = model.contractImgArr.count;
        [self saveImage:model.contractImgArr withImageType:JKImageTypeContract];
        if (model.payImgArr.count != 0) {
            _payImgCount = model.payImgArr.count;
            [self saveImage:model.payImgArr withImageType:JKImageTypePay];
        }
    }
}

- (void)saveImage:(NSArray *)imgArr withImageType:(JKImageType)imageType{
    if (imageType == JKImageTypeContract) {
        _forcontractCount = 0;
        [self getImgArr:imgArr withIndex:_forcontractCount withType:@"contract"];
    }
    
    if (imageType == JKImageTypePay) {
        _forpayCount = 0;
        [self getImgArr:imgArr withIndex:_forpayCount withType:@"pay"];
    }
}

- (void)getImgArr:(NSArray *)imgArr withIndex:(NSInteger)tag withType:(NSString *)type {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:type forKey:@"type"];
    int x = arc4random() % 1000;
    [params setObject:[NSString stringWithFormat:@"%ld.jpg",(long)[JKToolKit getNowTimestamp] + x] forKey:@"imageName"];
    [params setObject:[JKToolKit imageToString:imgArr[tag]] forKey:@"imageData"];
    NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/%@/uploadImage", kUrl_Base, loginId];
    [[JKHttpTool shareInstance] PostReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
        [self.imgArr addObject:responseObject[@"data"]];
        if ([type isEqualToString:@"contract"]) {
            _forcontractCount++;
            if (_forcontractCount == _contractImgCount) {
                [self getContractInfo];
            } else {
                [self getImgArr:imgArr withIndex:_forcontractCount withType:@"contract"];
            }
        } else if ([type isEqualToString:@"pay"]) {
            _forpayCount++;
            if (_forpayCount == _payImgCount) {
                [self getContractInfo];
            } else {
                [self getImgArr:imgArr withIndex:_forpayCount withType:@"pay"];
            }
        }
    } withFailureBlock:^(NSError *error) {
        
    }];
}

- (void)getContractInfo {
    NSInteger count = _payImgCount + _contractImgCount;
    if (count == self.imgArr.count) {
        NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
        JKContractModel *model = self.contractInfoArr[_forCount];
        for (NSString *url in self.imgArr) {
            [model.imgArr addObject:url];
        }
        
        NSMutableArray *deviceArr = [[NSMutableArray alloc] init];
        for (ContractDeviceList *dModel in model.contractDeviceList) {
            NSString *contractDeviceTypeId = dModel.contractDeviceTypeId;
            NSString *contractDeviceNum = dModel.contractDeviceNum;
            NSString *contractDeviceType = dModel.contractDeviceType;
            NSDictionary *dict = @{@"contractDeviceTypeId":contractDeviceTypeId, @"contractDeviceNum":contractDeviceNum, @"contractDeviceType":contractDeviceType};
            [deviceArr addObject:dict];
        }
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:loginId forKey:@"loginid"];
        [dict setObject:self.farmerId forKey:@"farmerId"];
        [dict setObject:model.contractType forKey:@"contractType"];
        [dict setObject:model.contractName forKey:@"contractName"];
        [dict setObject:model.contractAmountStr forKey:@"contractAmount"];
        [dict setObject:model.contractDateStr forKey:@"contractDate"];
        [dict setObject:deviceArr forKey:@"contractDeviceList"];
        if (![model.paymentMethod isEqualToString:@""]) {
            [dict setObject:model.paymentMethod forKey:@"paymentMethod"];
        }
        [dict setObject:model.actualAmountStr forKey:@"receivedAmount"];
        [dict setObject:model.imgArr forKey:@"url"];
    
        [self.contractArr addObject:dict];

        _forCount++;
        if (_contractCount == self.contractArr.count) {
            [self submitInfo];
        } else {
            [self submitInfoWithIndex:_forCount];
        }
    }
}

- (void)getContractInfoNoImg {
    NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
    JKContractModel *model = self.contractInfoArr[_forCount];
    for (NSString *url in self.imgArr) {
        [model.imgArr addObject:url];
    }
    
    NSMutableArray *deviceArr = [[NSMutableArray alloc] init];
    for (ContractDeviceList *dModel in model.contractDeviceList) {
        NSString *contractDeviceTypeId = dModel.contractDeviceTypeId;
        NSString *contractDeviceNum = dModel.contractDeviceNum;
        NSString *contractDeviceType = dModel.contractDeviceType;
        NSDictionary *dict = @{@"contractDeviceTypeId":contractDeviceTypeId, @"contractDeviceNum":contractDeviceNum, @"contractDeviceType":contractDeviceType};
        [deviceArr addObject:dict];
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:loginId forKey:@"loginid"];
    [dict setObject:self.farmerId forKey:@"farmerId"];
    [dict setObject:model.contractType forKey:@"contractType"];
    [dict setObject:model.contractName forKey:@"contractName"];
    [dict setObject:model.contractAmountStr forKey:@"contractAmount"];
    [dict setObject:model.contractDateStr forKey:@"contractDate"];
    [dict setObject:deviceArr forKey:@"contractDeviceList"];
    if (![model.paymentMethod isEqualToString:@""]) {
        [dict setObject:model.paymentMethod forKey:@"paymentMethod"];
    }
    [dict setObject:model.actualAmountStr forKey:@"receivedAmount"];
    
    [self.contractArr addObject:dict];
    
    [self submitInfo];
}


#pragma mark -- 刷新行高
- (void)reloadMidViewHeight:(NSNotification *)noti {
    _deviceListCellHeight = [noti.userInfo[@"height"] floatValue];
    [self.tableView reloadData];
}

- (void)submitInfo {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:self.contractArr forKey:@"contractList"];
    
    NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:loginId forKey:@"loginid"];
    [params setObject:dict forKey:@"appData"];
    [params setObject:self.farmerId forKey:@"farmerId"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/createTask/PRO00221527906936118", kUrl_Base];
    
    [[JKHttpTool shareInstance] PostReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"1"]) {
            [YJProgressHUD showMessage:responseObject[@"message"] inView:self.view];
            [self getFarmerId:responseObject[@"data"]];
        } else {
            [YJProgressHUD showMsgWithImage:responseObject[@"message"] imageName:iFailPath inview:self.view];
        }
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- 任务详情
- (void)getFarmerId:(NSString *)tskID {
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/mytask/%@/data",kUrl_Base,tskID];
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            JKSuccessVC *sVC = [[JKSuccessVC alloc] init];
            sVC.successType = JKSuccessContract;
            sVC.farmerId = self.farmerId;
            sVC.farmerName = self.farmerName;
            sVC.farmerAdd = self.farmerAdd;
            sVC.farmerTel = self.farmerTel;
            [self.navigationController pushViewController:sVC animated:YES];
        }
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- 添加
- (void)addBtnClick:(UIButton *)btn {
    JKContractModel *model = [[JKContractModel alloc] init];
    model.contractAmountStr = @"0";
    model.actualAmountStr = @"0";
    model.contractName = @"";
    model.contractType = @"押金合同";
    model.paymentMethod = @"";
    model.contractDateStr = @"";
    [self.contractInfoArr addObject:model];
    _section = btn.tag;
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:btn.tag] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView reloadData];
}

#pragma mark -- 删除
- (void)deleteOrderWithNumber:(NSInteger)number {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否删除当前的签约单?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

        [self.contractInfoArr removeObjectAtIndex:(number - 1)];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:number] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView reloadData];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -- 签约合同
- (void)alertContractTimeWithCellTag:(NSInteger)cellTag {
    JKDateTimePickerView *dtpV = [[JKDateTimePickerView alloc] init];
    dtpV.contractCellTag = cellTag;
    dtpV.delegate = self;
    [self.view addSubview:dtpV];
    [dtpV showDateTimePickerView];
}

#pragma mark -- JKDateTimePickerViewDelegate
- (void)didClickFinishDateTimePickerView:(NSString *)date withTag:(NSInteger)tag{
    JKContractModel *model = self.contractInfoArr[tag - 1];
    model.contractDateStr = date;

    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadSignData" object:nil userInfo:@{@"contractDate":model.contractDateStr,@"farmerName":self.farmerName, @"tag":@(tag)}]];
}

#pragma mark -- 拨打电话
- (void)callFarmerPhone:(NSString *)phoneNumber {
    NSString *dialSring=[NSString stringWithFormat:@"tel://%@",phoneNumber];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dialSring] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dialSring]];
    }
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.contractInfoArr.count + 3;
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
    if (section == ((self.contractInfoArr.count + 3) - 1)) {
        return 0;
    } else {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 70;
    } else if (indexPath.section == ((self.contractInfoArr.count + 3)  - 2)) {
        return 48;
    } else if (indexPath.section == ((self.contractInfoArr.count + 3)  - 1)) {
        return 75;
    } else {
        return 808 - 144 + _deviceListCellHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *ID = @"JKWorkTopCell";
        JKWorkTopCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKWorkTopCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        cell.headImgStr = self.farmerPic;
        cell.nameLb.text = self.farmerName;
        cell.addrLb.text = self.farmerAdd;
        cell.telStr = self.farmerTel;
        cell.delegate = self;
        return cell;
        
    } else if (indexPath.section == ((self.contractInfoArr.count + 3) - 2)) {
        NSString *ID = [NSString stringWithFormat:@"AddCell%ld",(long)indexPath.section];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [self.addBtn removeFromSuperview];
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setTitle:@"+ 新增合同类型" forState:UIControlStateNormal];
        [addBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
        addBtn.tag = indexPath.section;
        [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        addBtn.titleLabel.font = JKFont(14);
        [cell addSubview:addBtn];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.left.right.equalTo(cell);
            make.height.mas_equalTo(40);
        }];
        self.addBtn = addBtn;
        
        return cell;
    } else if (indexPath.section == ((self.contractInfoArr.count + 3) - 1)) {
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
        NSString *ID = [NSString stringWithFormat:@"cell%ld",(long)indexPath.section];
        JKOpenAccountOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKOpenAccountOrderCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.tag = indexPath.section;
        cell.delegate = self;
        cell.contractInfoArr = self.contractInfoArr;
        return cell;
    }
}

@end
