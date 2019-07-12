//
//  JKInstallInfoVC.m
//  BusinessManager
//
//  Created by  on 2018/6/25.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKInstallInfoVC.h"
#import "JKWorkTopCell.h"
#import "JKInstallInfoMidCell.h"
#import "JKInstallationDeviceCell.h"
#import "JKInstallInfoBottomCell.h"
#import "JKInstallInfoModel.h"
#import "JKEquipmentInfoVC.h"

@interface JKInstallInfoVC () <UITableViewDelegate, UITableViewDataSource, JKInstallationDeviceCellDelegate, JKWorkTopCellDelegate>
{
    BOOL _hasPayServiceFree;
    BOOL _hasPayDepositFree;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation JKInstallInfoVC

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

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"任务详情";
    
    _hasPayServiceFree = NO;
    _hasPayDepositFree = NO;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self getInstallTaskInfoList];
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

#pragma mark -- 任务详情
- (void)getInstallTaskInfoList {
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/mytask/%@/data",kUrl_Base,self.tskID];
    
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            [self.dataSource removeAllObjects];
            JKInstallInfoModel *model = [[JKInstallInfoModel alloc] init];
            model.txtFarmer = responseObject[@"data"][@"txtFarmer"];
            model.txtFarmerAddress = responseObject[@"data"][@"txtFarmerAddress"];
            model.txtPhone = responseObject[@"data"][@"txtPhone"];
            model.txtStatus = responseObject[@"data"][@"txtStatus"];
            model.txtInstallationPersonnel = responseObject[@"data"][@"txtInstallationPersonnel"];
            model.txtFishPondCount = responseObject[@"data"][@"txtFishPondCount"];
            model.txtInstallAddress = responseObject[@"data"][@"txtInstallAddress"];
            model.txtDepositAmount = responseObject[@"data"][@"txtDepositAmount"];
            model.txtServiceAmount = responseObject[@"data"][@"txtServiceAmount"];
            model.calExpectedTime = responseObject[@"data"][@"calExpectedTime"];
            model.tabEquipmentList = responseObject[@"data"][@"tabEquipmentList"];
            model.tabEquipmentBindPond = responseObject[@"data"][@"tabEquipmentBindPond"];
            model.txtRelaceAmoutS = responseObject[@"data"][@"txtRelaceAmoutS"];
            model.txtRelaceAmoutD = responseObject[@"data"][@"txtRelaceAmoutD"];
            model.calInstallationTime = responseObject[@"data"][@"calInstallationTime"];
            model.txtUrls = responseObject[@"data"][@"txtUrls"];
            model.txtPaymentMethodS = responseObject[@"data"][@"txtPaymentMethodS"];
            model.txtNoteS = responseObject[@"data"][@"txtNoteS"];
            model.txtPaymentUrlS = responseObject[@"data"][@"txtPaymentUrlS"];
            model.txtPaymentMethodD = responseObject[@"data"][@"txtPaymentMethodD"];
            model.txtNoteD = responseObject[@"data"][@"txtNoteD"];
            model.txtPaymentUrlD = responseObject[@"data"][@"txtPaymentUrlD"];
            model.calDispatchTime = responseObject[@"data"][@"calDispatchTime"];
            model.region = responseObject[@"data"][@"region"];
            model.picture = responseObject[@"data"][@"picture"];
            model.txtDeviceNum = responseObject[@"data"][@"txtDeviceNum"];
            model.txtDepositRemark = responseObject[@"data"][@"txtDepositRemark"];
            model.txtServiceRemark = responseObject[@"data"][@"txtServiceRemark"];
            model.txtReciptTime = responseObject[@"data"][@"txtReciptTime"];
            if ([model.txtRelaceAmoutS isEqualToString:@"0"]) {
                _hasPayServiceFree = NO;
            } else {
                _hasPayServiceFree = YES;
            }
            if ([model.txtRelaceAmoutD isEqualToString:@"0"]) {
                _hasPayDepositFree = NO;
            } else {
                _hasPayDepositFree = YES;
            }
            
            [self.dataSource addObject:model];
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- 查看设备详情
- (void)checkEquipmentInfo:(JKInstallInfoModel *)model withTag:(NSInteger)tag{
    JKEquipmentInfoVC *eiVC = [[JKEquipmentInfoVC alloc] init];
    eiVC.tskID = model.tabEquipmentBindPond[tag - 1][@"ITEM1"];
    [self.navigationController pushViewController:eiVC animated:YES];
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.installType == JKMaintainEd) {
        return 4;
    } else {
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.installType == JKMaintainEd) {
        if (indexPath.row == 0) {
            return 70;
        } else if (indexPath.row == 1) {
            return 290;
        } else if (indexPath.row == 2) {
            if (self.dataSource.count == 0) {
                return 48 + 10;
            }
            JKInstallInfoModel *model = self.dataSource[0];
            if (model.tabEquipmentBindPond.count == 0) {
                return 96 + 10;
            } else {
                return 48 * (model.tabEquipmentBindPond.count + 1) + 10;
            }
        } else {
            if (_hasPayServiceFree && _hasPayDepositFree) {
                return 666;
            } else if (!_hasPayServiceFree && !_hasPayDepositFree) {
                return 386;
            } else {
                return 526;
            }
        }
    } else {
        if (indexPath.row == 0) {
            return 70;
        } else if (indexPath.row == 1) {
            return 290;
        } else {
            if (self.dataSource.count == 0) {
                return 48 + 10;
            }
            JKInstallInfoModel *model = self.dataSource[0];
            if (model.tabEquipmentList.count == 0) {
                return 96 + 10;
            } else {
                return 48 * (model.tabEquipmentList.count + 1) + 10;
            }
        }
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
        JKInstallInfoModel *model = self.dataSource[0];
        cell.headImgStr = model.picture;
        cell.nameLb.text = model.txtFarmer;
        cell.addrLb.text = [NSString stringWithFormat:@"%@", model.txtFarmerAddress];
        cell.telStr = model.txtPhone;
        cell.delegate = self;
        return cell;
    } else if (indexPath.row == 2) {
        static NSString *ID = @"JKInstallationDeviceCell";
        JKInstallationDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKInstallationDeviceCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.dataSource.count == 0) {
            return cell;
        }
        JKInstallInfoModel *model = self.dataSource[0];
        cell.type = self.installType;
        cell.delegate = self;
        [cell createUI:model];
        return cell;
    } else if (indexPath.row == 3) {
        static NSString *ID = @"JKInstallInfoBottomCell";
        JKInstallInfoBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKInstallInfoBottomCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.hasPayDepositFree = _hasPayDepositFree;
        cell.hasPayServiceFree = _hasPayServiceFree;
        if (self.dataSource.count != 0) {
            JKInstallInfoModel *model = self.dataSource[0];
            [cell getModel:model];
        }
        
        return cell;
    } else {
        static NSString *ID = @"JKInstallInfoMidCell";
        JKInstallInfoMidCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKInstallInfoMidCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.installType = self.installType;
        if (self.dataSource.count == 0) {
            return cell;
        }
        
        JKInstallInfoModel *model = self.dataSource[0];
        [cell createUI:model];
        return cell;
    }
}


@end
