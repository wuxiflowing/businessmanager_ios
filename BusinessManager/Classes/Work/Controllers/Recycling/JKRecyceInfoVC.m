//
//  JKRecyceInfoVC.m
//  BusinessManager
//
//  Created by  on 2018/6/22.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKRecyceInfoVC.h"
#import "JKRecyceInfoModel.h"
#import "JKWorkTopCell.h"
#import "JKRecyceDeviceCell.h"
#import "JKRecyceOrderCell.h"
#import "JKRecycePondCell.h"
#import "JKRecyceDevicesVC.h"
#import "JKRecyceInfoBottomCell.h"
#import "JKRecyceResultCell.h"

@interface JKRecyceInfoVC () <UITableViewDelegate, UITableViewDataSource, JKWorkTopCellDelegate, JKRecyceDeviceCellDelegate>
{
    NSInteger _count;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *pondArr;
@end

@implementation JKRecyceInfoVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kClearColor;
        _tableView.separatorColor = kClearColor;
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
    
    if (self.recyceType != JKRecycePending) {
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.safeAreaTopView.mas_bottom);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
    } else {
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.safeAreaTopView.mas_bottom);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-70);
        }];
        
        UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [orderBtn setTitle:@"待审核" forState:UIControlStateNormal];
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
            model.txtPondPhone = responseObject[@"data"][@"txtPondPhone"];
            model.txtPondName = responseObject[@"data"][@"txtPondName"];
            model.txtPondAddr = responseObject[@"data"][@"txtPondAddr"];
            model.txtFarmerName = responseObject[@"data"][@"txtFarmerName"];
            model.txtFarmerAddr = responseObject[@"data"][@"txtFarmerAddr"];
            model.txtHKID = responseObject[@"data"][@"txtHKID"];
            model.txtHKPhone = responseObject[@"data"][@"txtHKPhone"];
            model.txtFarmerPhone = responseObject[@"data"][@"txtFarmerPhone"];
            model.txtMatnerMembNo = responseObject[@"data"][@"txtMatnerMembNo"];
            model.txtMatnerMembName = responseObject[@"data"][@"txtMatnerMembName"];
            model.txtFormNo = responseObject[@"data"][@"txtFormNo"];
            model.txtFarmerID = responseObject[@"data"][@"txtFarmerID"];
            model.picture = responseObject[@"data"][@"picture"];
            model.region = responseObject[@"data"][@"region"];
            model.txtResMulti = responseObject[@"data"][@"txtResMulti"];
            model.tarRemarks = responseObject[@"data"][@"tarRemarks"];
            model.tarEqps = responseObject[@"data"][@"tarEqps"];
            model.tarExplain = responseObject[@"data"][@"tarExplain"];
            model.txtDamageImgSrc = responseObject[@"data"][@"txtDamageImgSrc"];
            model.txtFormImgSrc = responseObject[@"data"][@"txtFormImgSrc"];
            model.rdoYes = [responseObject[@"data"][@"rdoYes"] boolValue];
            model.tarReson = responseObject[@"data"][@"tarReson"];
            _count = model.tarEqps.count;
            NSArray *ponds = responseObject[@"data"][@"tabPonds"];
            if (ponds != nil && ![ponds isKindOfClass:[NSNull class]] && ponds.count != 0) {
                for (NSDictionary *dic in ponds) {
                    JKPondInfoModel *pModel = [[JKPondInfoModel alloc] init];
                    pModel.ITEM1 = dic[@"ITEM1"];
                    pModel.ITEM2 = dic[@"ITEM2"];
                    pModel.ITEM4 = dic[@"ITEM4"];
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

#pragma mark -- JKRecyceInfoMidCellDelegate
- (void)clickPendBtn:(UIButton *)btn {
    
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.recyceType == JKRecyceEd) {
        return 4;
    } else {
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.recyceType == JKRecyceEd) {
        if (indexPath.row == 0) {
            return 70;
        } else if (indexPath.row == 1) {
            return 270;
        } else if (indexPath.row == 2) {
            if (self.dataSource.count == 0) {
                return 48 + 15;
            }
            JKRecyceInfoModel *model = self.dataSource[0];
            return model.tarEqps.count * 48 + 48 + 15;
        } else {
            return 551;
        }
    } else {
        if (indexPath.row == 0) {
            return 70;
        } else if (indexPath.row == 1) {
            return 270;
        } else {
            if (self.dataSource.count == 0) {
                return 48 + 15;
            }
            
            JKRecyceInfoModel *model = self.dataSource[0];
            return model.tarEqps.count * 48 + 48 + 15;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.recyceType == JKRecyceEd) {
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
            cell.addrLb.text = [NSString stringWithFormat:@"%@",model.txtFarmerAddr];
            cell.telStr = model.txtFarmerPhone;
            cell.delegate = self;
            return cell;
        } else if (indexPath.row == 1) {
            static NSString *ID = @"JKRecyceOrderCell";
            JKRecyceOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if(!cell){
                cell = [[JKRecyceOrderCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if (self.dataSource.count == 0) {
                return cell;
            }
            
            cell.recyceType = self.recyceType;
            JKRecyceInfoModel *model = self.dataSource[0];
            [cell createUI:model];
            return cell;
        } else if (indexPath.row == 2) {
            static NSString *ID = @"JKRecyceDeviceCell";
            JKRecyceDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if(!cell){
                cell = [[JKRecyceDeviceCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if (self.dataSource.count == 0) {
                return cell;
            }
            
            cell.recyceType = self.recyceType;
            //        cell.delegate = self;
            JKRecyceInfoModel *model = self.dataSource[0];
            cell.dataSource = model.tarEqps;
            return cell;
        } else {
            static NSString *ID = @"JKRecyceResultCell";
            JKRecyceResultCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if(!cell){
                cell = [[JKRecyceResultCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }

            if (self.dataSource.count == 0) {
                return cell;
            }
            cell.recyceType = self.recyceType;
            JKRecyceInfoModel *model = self.dataSource[0];
            cell.model = model;
            return cell;
        }
    } else {
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
            cell.addrLb.text = [NSString stringWithFormat:@"%@%@",model.region, model.txtFarmerAddr];
            cell.telStr = model.txtFarmerPhone;
            cell.delegate = self;
            return cell;
        } else if (indexPath.row == 1) {
            static NSString *ID = @"JKRecyceOrderCell";
            JKRecyceOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if(!cell){
                cell = [[JKRecyceOrderCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
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
            static NSString *ID = @"JKRecyceDeviceCell";
            JKRecyceDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if(!cell){
                cell = [[JKRecyceDeviceCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if (self.dataSource.count == 0) {
                return cell;
            }
            
            cell.recyceType = self.recyceType;
            cell.delegate = self;
            JKRecyceInfoModel *model = self.dataSource[0];
            cell.dataSource = model.tarEqps;
            return cell;
        }
    }
}


@end
