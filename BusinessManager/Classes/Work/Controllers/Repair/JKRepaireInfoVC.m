//
//  JKRepaireInfoVC.m
//  BusinessManager
//
//  Created by  on 2018/6/22.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKRepaireInfoVC.h"
#import "JKWorkTopCell.h"
#import "JKRepaireInfoMidCell.h"
#import "JKRepaireInfoBottomCell.h"
#import "JKRepaireInfoModel.h"

@interface JKRepaireInfoVC () <UITableViewDelegate, UITableViewDataSource, JKWorkTopCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation JKRepaireInfoVC

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
    
    [self getRepaireTaskInfoList];
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
- (void)getRepaireTaskInfoList {
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/mytask/%@/data",kUrl_Base,self.tskID];
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            [self.dataSource removeAllObjects];
            JKRepaireInfoModel *model = [[JKRepaireInfoModel alloc] init];
            model.txtFarmerID = responseObject[@"data"][@"txtFarmerID"];
            model.txtFarmerName = responseObject[@"data"][@"txtFarmerName"];
            model.txtFarmerAddr = responseObject[@"data"][@"txtFarmerAddr"];
            model.txtFarmerPhone = responseObject[@"data"][@"txtFarmerPhone"];
            model.txtPondsName = responseObject[@"data"][@"txtPondsName"];
            model.txtPondAddr = responseObject[@"data"][@"txtPondAddr"];
            model.txtRepairEqpKind = responseObject[@"data"][@"txtRepairEqpKind"];
            model.txtRepairEqpID = responseObject[@"data"][@"txtRepairEqpID"];
            model.txtNewID = responseObject[@"data"][@"txtNewID"];
            model.txtPondPhone = responseObject[@"data"][@"txtPondPhone"];
            model.txtMaintenDetail = responseObject[@"data"][@"txtMaintenDetail"];
            model.txtMatnerMembName = responseObject[@"data"][@"txtMatnerMembName"];
            model.rdoSelfYes = [responseObject[@"data"][@"rdoSelfYes"] boolValue];
            model.txtResMulti = responseObject[@"data"][@"txtResMulti"];
            model.tarResOth = responseObject[@"data"][@"tarResOth"];
            model.txtConMulti = responseObject[@"data"][@"txtConMulti"];
            model.tarConOth = responseObject[@"data"][@"tarConOth"];
            model.tarRemarks = responseObject[@"data"][@"tarRemarks"];
            model.txtRepairFormImg = responseObject[@"data"][@"txtRepairFormImg"];
            model.txtReceiptImg = responseObject[@"data"][@"txtReceiptImg"];
            model.txtEndDate = responseObject[@"data"][@"txtEndDate"];
            model.txtStartDate = responseObject[@"data"][@"txtStartDate"];
            model.region = responseObject[@"data"][@"region"];
            model.picture = responseObject[@"data"][@"picture"];
            model.txtAppRepairImg = responseObject[@"data"][@"txtAppRepairImg"];
            [self.dataSource addObject:model];
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.repaireType == JKRepaireEd) {
        return 3;
    } else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.repaireType == JKRepaireEd) {
        if (indexPath.row == 0) {
            return 70;
        } else if (indexPath.row == 1) {
            if (self.dataSource.count == 0) {
                return 0;
            }
            JKRepaireInfoModel *model = self.dataSource[0];
            if (model.txtAppRepairImg.length == 0) {
                return 240;
            } else {
                return 355;
            }
        } else {
            return 688;
        }
    } else {
        if (indexPath.row == 0) {
            return 70;
        } else {
            if (self.dataSource.count == 0) {
                return 0;
            }
            JKRepaireInfoModel *model = self.dataSource[0];
            if (model.txtAppRepairImg.length == 0) {
                return 240;
            } else {
                return 355;
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
        JKRepaireInfoModel *model = self.dataSource[0];
        cell.headImgStr = model.picture;
        cell.nameLb.text = model.txtFarmerName;
        cell.addrLb.text = [NSString stringWithFormat:@"%@", model.txtFarmerAddr];
        cell.telStr = model.txtFarmerPhone;
        cell.delegate = self;
        return cell;
    } else if (indexPath.row == 2) {
        static NSString *ID = @"JKRepaireInfoBottomCell";
        JKRepaireInfoBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKRepaireInfoBottomCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.dataSource.count == 0) {
            return cell;
        }
        
        JKRepaireInfoModel *model = self.dataSource[0];
        [cell createUI:model];
        
        return cell;
    } else {
        static NSString *ID = @"JKRepaireInfoMidCell";
        JKRepaireInfoMidCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKRepaireInfoMidCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.repaireType = self.repaireType;
        if (self.dataSource.count == 0) {
            return cell;
        }
        
        
        JKRepaireInfoModel *model = self.dataSource[0];
        [cell createUI:model];
        if (model.txtAppRepairImg.length != 0) {
            cell.repaireImg = model.txtAppRepairImg;
        }
        return cell;
        
    }
}

@end
