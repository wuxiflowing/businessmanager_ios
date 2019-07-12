//
//  JKRecycePendInfoVC.m
//  BusinessManager
//
//  Created by  on 2018/11/11.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKRecycePendInfoVC.h"
#import "JKRecyceInfoModel.h"
#import "JKWorkTopCell.h"
#import "JKRecyceDeviceCell.h"
#import "JKRecycePendOrderCell.h"
#import "JKRecycePondCell.h"
#import "JKRecyceDevicesVC.h"
#import "JKRecyceCheckOrderCell.h"

@interface JKRecycePendInfoVC () <UITableViewDelegate, UITableViewDataSource, JKWorkTopCellDelegate>
{
    NSInteger _count;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *pondArr;
@end

@implementation JKRecycePendInfoVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kClearColor;
        _tableView.separatorColor = RGBHex(0xdddddd);
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.scrollEnabled = YES;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (NSMutableArray *)pondArr {
    if (!_pondArr) {
        _pondArr = [[NSMutableArray alloc] init];
    }
    return _pondArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"任务详情";
    
    if (self.recyceType == JKRecyceCheck) {
        
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.safeAreaTopView.mas_bottom);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-70);
        }];
        
        UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [orderBtn setTitle:@"审 核" forState:UIControlStateNormal];
        [orderBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [orderBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
        [orderBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
        [orderBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
        orderBtn.titleLabel.font = JKFont(16);
        orderBtn.layer.cornerRadius = 4;
        orderBtn.layer.masksToBounds = YES;
        [orderBtn addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:orderBtn];
        [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-XTopHeight);
            make.left.equalTo(self.view.mas_left).offset(SCALE_SIZE(15));
            make.right.equalTo(self.view.mas_right).offset(-SCALE_SIZE(15));
            make.height.mas_equalTo(48);
        }];
    } else {
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.safeAreaTopView.mas_bottom);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
    }

    [self getRecyceTaskInfoList];
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

#pragma mark -- 确认回收/接单
- (void)orderBtnClick:(UIButton *)btn {
    JKRecyceDevicesVC *rdVC = [[JKRecyceDevicesVC alloc] init];
    rdVC.tskID = self.tskID;
    [self.navigationController pushViewController:rdVC animated:YES];
}

#pragma mark -- 任务详情
- (void)getRecyceTaskInfoList {
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/mytask/%@/data",kUrl_Base,self.tskID];
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            JKRecyceInfoModel *model = [[JKRecyceInfoModel alloc] init];
            model.txtFarmerName = responseObject[@"data"][@"txtFarmerName"];
            model.txtFarmerAddr = responseObject[@"data"][@"txtFarmerAddr"];
            model.txtHKID = responseObject[@"data"][@"txtHKID"];
            model.txtHKPhone = responseObject[@"data"][@"txtHKPhone"];
            model.txtFarmerPhone = responseObject[@"data"][@"txtFarmerPhone"];
            model.txtFormNo = responseObject[@"data"][@"txtFormNo"];
            model.txtFarmerID = responseObject[@"data"][@"txtFarmerID"];
            model.picture = responseObject[@"data"][@"picture"];
            model.region = responseObject[@"data"][@"region"];
            model.txtResMulti = responseObject[@"data"][@"txtResMulti"];
            model.tarEqps = responseObject[@"data"][@"tarEqps"];
            model.txtStartDate = responseObject[@"data"][@"txtStartDate"];
            model.txtCenMagName = responseObject[@"data"][@"txtCenMagName"];
            model.txtHK = responseObject[@"data"][@"txtHK"];
            model.tarCustomerReson = responseObject[@"data"][@"tarCustomerReson"];
            model.txtCSMembName = responseObject[@"data"][@"txtCSMembName"];
            if ([[NSString stringWithFormat:@"%@", responseObject[@"data"][@"tarReson"]] isEqualToString:@"<null>"]) {
                model.tarReson = @"";
            } else {
                model.tarReson = responseObject[@"data"][@"tarReson"];
            }
            model.txtDamageImgSrc = responseObject[@"data"][@"txtDamageImgSrc"];
            model.txtFormImgSrc = responseObject[@"data"][@"txtFormImgSrc"];
            _count = model.tarEqps.count;
            NSArray *ponds = responseObject[@"data"][@"tabPonds"];
            if (ponds != nil && ![ponds isKindOfClass:[NSNull class]] && ponds.count != 0) {
                for (NSDictionary *dic in ponds) {
                    JKPondInfoModel *pModel = [[JKPondInfoModel alloc] init];
                    pModel.ITEM1 = dic[@"ITEM1"];
                    pModel.ITEM2 = dic[@"ITEM2"];
                    pModel.ITEM3 = dic[@"ITEM3"];
                    pModel.ITEM4 = dic[@"ITEM10"];
                    pModel.ITEM6 = dic[@"ITEM6"];
                    [self.pondArr addObject:pModel];
                }
                model.tabPonds = [self.pondArr copy];
            }
            [self.dataSource addObject:model];
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataSource.count != 0) {
//        JKRecyceInfoModel *model = self.dataSource[0];
//        return 2 + model.tabPonds.count;
        return 3;
    } else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 70;
    } else if (indexPath.row == 1) {
        if (self.recyceType == JKRecyceCheck) {
            return 210;
        } else {
            return 240;
        }
    } else {
        return (34 * 4 + 10) * self.pondArr.count + 40 + 15;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *ID = @"JKWorkTopCell";
        JKWorkTopCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKWorkTopCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.dataSource.count == 0) {
            return cell;
        }
        
        JKRecyceInfoModel *model = self.dataSource[0];
        cell.headImgStr = model.picture;
        cell.nameLb.text = model.txtFarmerName;
        cell.addrLb.text = [NSString stringWithFormat:@"%@", model.txtFarmerAddr];
        cell.telStr = model.txtFarmerPhone;
        cell.delegate = self;
        return cell;
    } else if (indexPath.row == 1) {
        if (self.recyceType == JKRecyceCheck || self.recyceType == JKRecyceAuditPass || self.recyceType == JKRecyceAuditReject) {
            static NSString *ID = @"JKRecyceCheckOrderCell";
            JKRecyceCheckOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if(!cell){
                cell = [[JKRecyceCheckOrderCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if (self.dataSource.count == 0) {
                return cell;
            }
            
            cell.recyceType = self.recyceType;
            JKRecyceInfoModel *model = self.dataSource[0];
            [cell createUI:model];
            return cell;
        } else {
            static NSString *ID = @"JKRecycePendOrderCell";
            JKRecycePendOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if(!cell){
                cell = [[JKRecycePendOrderCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if (self.dataSource.count == 0) {
                return cell;
            }
            
            cell.recyceType = self.recyceType;
            JKRecyceInfoModel *model = self.dataSource[0];
            [cell createUI:model];
            return cell;
        }
    } else {
        static NSString *ID = @"JKRecycePondCell";
        JKRecycePondCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKRecycePondCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (self.dataSource.count == 0) {
            return cell;
        }
        
        JKRecyceInfoModel *model = self.dataSource[0];
        [cell createUI:model];
        return cell;
    }
}


@end
