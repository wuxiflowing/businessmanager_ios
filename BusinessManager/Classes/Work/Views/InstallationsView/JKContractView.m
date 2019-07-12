//
//  JKContractView.m
//  BusinessManager
//
//  Created by  on 2018/8/11.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKContractView.h"
#import "JKContractModel.h"


@interface JKContractView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *depositArr;
@property (nonatomic, strong) NSMutableArray *serviceArr;
@property (nonatomic, assign) JKContractType type;
@end

@implementation JKContractView

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kWhiteColor;
        _tableView.separatorColor = RGBHex(0xdddddd);
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.scrollEnabled = NO;
        _tableView.layer.cornerRadius = 4;
        _tableView.layer.masksToBounds = YES;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (NSMutableArray *)depositArr {
    if (!_depositArr) {
        _depositArr = [[NSMutableArray alloc] init];
    }
    return _depositArr;
}

- (NSMutableArray *)serviceArr {
    if (!_serviceArr) {
        _serviceArr = [[NSMutableArray alloc] init];
    }
    return _serviceArr;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.alpha = 0.5;
    }
    return _coverView;
}

- (instancetype)initWithFrame:(CGRect)frame withContractType:(JKContractType)type{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.type = type;
        
        [self addSubview:self.coverView]; //蒙版
        
//        [self addSubview:self.tableView];
//        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.mas_centerX);
//            make.centerY.equalTo(self.mas_centerY);
//            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.8, SCREEN_HEIGHT * 0.5));
//        }];
    }
    return self;
}

- (void)setFarmerId:(NSString *)farmerId {
    [self getContract:farmerId];
}

#pragma mark -- 获取合同
- (void)getContract:(NSString *)farmerId {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/contractList/farmerId/%@",kUrl_Base,farmerId];
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            [self.dataSource removeAllObjects];
            for (NSDictionary *dic in responseObject[@"data"]) {
                for (NSDictionary *dict in dic[@"contractData"]) {
                    JKContractModel *model = [[JKContractModel alloc] init];
                    model.collectState = dict[@"collectState"];
                    model.contractAmount = dict[@"contractAmount"];
                    NSString *image = [dict[@"contractImage"] stringByReplacingOccurrencesOfString:@" " withString:@""];
                    model.contractImage = image;
                    model.contractName = dict[@"contractName"];
                    model.contractType = dict[@"contractType"];
                    model.contractId = dict[@"contractId"];
                    model.contractDeviceList = dict[@"contractDeviceList"];
                    if (self.type == JKContractTypeService) {
                        if ([model.contractType isEqualToString:@"service"]) {
                            [self.dataSource addObject:model];
                        }
                    } else if (self.type == JKContractTypeDeposit) {
                        if ([model.contractType isEqualToString:@"deposit"]) {
                            [self.dataSource addObject:model];
                        }
                    }
                    
                    if ([model.contractType isEqualToString:@"deposit"]) {
                        [self.depositArr addObject:model];
                    } else if ([model.contractType isEqualToString:@"service"]) {
                        [self.serviceArr addObject:model];
                    }
                }
            }
            
            if (self.dataSource.count == 0) {
                [YJProgressHUD showMessage:@"暂无合同" inView:self];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self cancleView];
                });
                return;
            }
            
            NSInteger depositSum = 0;
            NSInteger serviceSum = 0;
            NSString * contractId;
            for (JKContractModel *model in self.depositArr) {
                depositSum += [model.contractAmount integerValue];
            }
            for (JKContractModel *model in self.serviceArr) {
                serviceSum += [model.contractAmount integerValue];
                contractId = model.contractId;
            }
            
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadFree" object:nil userInfo:@{@"depositSum":[NSString stringWithFormat:@"%ld",depositSum],@"serviceSum":[NSString stringWithFormat:@"%ld",serviceSum],@"contractId":contractId == nil ? @"":contractId}]];
            
        }
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.8, self.dataSource.count * 48));
        }];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    JKContractModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.contractName;
    cell.textLabel.textColor = RGBHex(0x333333);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = JKFont(16);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JKContractModel *model = self.dataSource[indexPath.row];
    if (self.type == JKContractTypeService) {
        if ([_delegate respondsToSelector:@selector(popContractServiceModel:)]) {
            [_delegate popContractServiceModel:model];
        }
    } else {
        if ([_delegate respondsToSelector:@selector(popContractModel:)]) {
            [_delegate popContractModel:model];
        }
    }
    [self cancleView];
}

#pragma mark -- cell的分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

- (void)cancleView {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
