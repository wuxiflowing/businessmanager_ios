//
//  JKMaintainInfoVC.m
//  BusinessManager
//
//  Created by  on 2018/6/25.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKMaintainInfoVC.h"
#import "JKMaintainInfoTopCell.h"
#import "JKMaintainInfoMidCell.h"
#import "JKMaintainInfoBottomCell.h"
#import "JKWorkTopCell.h"
#import "JKMaintainInfoModel.h"
#import "JKMaintainOrderCell.h"
#import "JKMaintainResultCell.h"

@interface JKMaintainInfoVC () <UITableViewDelegate, UITableViewDataSource, JKMaintainInfoMidCellDelegate, JKWorkTopCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation JKMaintainInfoVC

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
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self getMaintainTaskInfoList];
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
- (void)getMaintainTaskInfoList {
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/mytask/%@/data",kUrl_Base,self.tskID];
    
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            JKMaintainInfoModel *model = [[JKMaintainInfoModel alloc] init];
            model.txtFarmerName = responseObject[@"data"][@"txtFarmerName"];
            model.txtPondAddr = responseObject[@"data"][@"txtPondAddr"];
            model.txtFarmerAddr = responseObject[@"data"][@"txtFarmerAddr"];
            model.txtIMMembID = responseObject[@"data"][@"txtIMMembID"];
            model.txtHKID = responseObject[@"data"][@"txtHKID"];
            model.txtFormNo = responseObject[@"data"][@"txtFormNo"];
            model.txtFarmerID = responseObject[@"data"][@"txtFarmerID"];
            model.txtFarmerPhone = responseObject[@"data"][@"txtFarmerPhone"];
            model.txtMatnerMembNo = responseObject[@"data"][@"txtMatnerMembNo"];
            model.txtEqpNo = responseObject[@"data"][@"txtEqpNo"];
            model.txtMatnerMembName = responseObject[@"data"][@"txtMatnerMembName"];
            model.txtPondsName = responseObject[@"data"][@"txtPondsName"];
            model.latitude = responseObject[@"data"][@"latitude"];
            model.longitude = responseObject[@"data"][@"longitude"];
            model.picture = responseObject[@"data"][@"picture"];
            NSArray *txtMaintainImgSrc = [responseObject[@"data"][@"txtMaintainImgSrc"] componentsSeparatedByString:@","];
            if (txtMaintainImgSrc.count != 0) {
                model.txtMaintainImgSrc = [txtMaintainImgSrc componentsJoinedByString:@","];
            }
            model.region = responseObject[@"data"][@"region"];
            model.tarMaintainCon = responseObject[@"data"][@"tarMaintainCon"];
            model.tarRemarks = responseObject[@"data"][@"tarRemarks"];
            model.txtRepairEqpKind = responseObject[@"data"][@"txtRepairEqpKind"];
            model.txtEndDate = responseObject[@"data"][@"txtEndDate"];
            [self.dataSource addObject:model];
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.maintainType == JKMaintainEd) {
        return 3;
    } else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.maintainType == JKMaintainEd) {
        if (indexPath.row == 0) {
            return 70;
        } else if (indexPath.row == 1) {
            return 250;
        } else {
            return 396;
        }
    } else {
        if (indexPath.row == 0) {
            return 70;
        } else {
            return 250;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.maintainType == JKMaintainEd) {
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
            
            JKMaintainInfoModel *model = self.dataSource[0];
            cell.headImgStr = model.picture;
            cell.nameLb.text = model.txtFarmerName;
            cell.addrLb.text = model.txtFarmerAddr;
            cell.telStr = model.txtFarmerPhone;
            cell.delegate = self;
            return cell;
        } else if (indexPath.row == 1) {
            static NSString *ID = @"JKMaintainOrderCell";
            JKMaintainOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if(!cell){
                cell = [[JKMaintainOrderCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if (self.dataSource.count == 0) {
                return cell;
            }
            cell.maintainType = self.maintainType;
            JKMaintainInfoModel *model = self.dataSource[0];
            [cell createUI:model];
            
            return cell;
        } else {
            static NSString *ID = @"JKMaintainResultCell";
            JKMaintainResultCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if(!cell){
                cell = [[JKMaintainResultCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if (self.dataSource.count == 0) {
                return cell;
            }
            cell.maintainType = self.maintainType;
            JKMaintainInfoModel *model = self.dataSource[0];
            [cell createUI:model];
            
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
            
            JKMaintainInfoModel *model = self.dataSource[0];
            cell.headImgStr = model.picture;
            cell.nameLb.text = model.txtFarmerName;
            cell.addrLb.text = model.txtFarmerAddr;
            cell.telStr = model.txtFarmerPhone;
            cell.delegate = self;
            return cell;
        } else {
            static NSString *ID = @"JKMaintainOrderCell";
            JKMaintainOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if(!cell){
                cell = [[JKMaintainOrderCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if (self.dataSource.count == 0) {
                return cell;
            }
            cell.maintainType = self.maintainType;
            JKMaintainInfoModel *model = self.dataSource[0];
            [cell createUI:model];
            
            return cell;
        }
    }
}


@end
