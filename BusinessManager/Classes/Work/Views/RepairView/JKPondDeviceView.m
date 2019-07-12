//
//  JKPondDeviceView.m
//  BusinessManager
//
//  Created by  on 2018/8/12.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKPondDeviceView.h"
#import "JKPondModel.h"


@interface JKPondDeviceView () <UITableViewDelegate, UITableViewDataSource>
{
    NSInteger _tag;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *rowNumberArr;
@property (nonatomic, strong) NSMutableArray *sectionTitileArr;
@end

@implementation JKPondDeviceView

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kWhiteColor;
        _tableView.separatorColor = RGBHex(0xdddddd);
        _tableView.tableFooterView = [[UIView alloc] init];
//        _tableView.scrollEnabled = NO;
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

- (NSMutableArray *)rowNumberArr {
    if (!_rowNumberArr) {
        _rowNumberArr = [[NSMutableArray alloc] init];
    }
    return _rowNumberArr;
}

- (NSMutableArray *)sectionTitileArr {
    if (!_sectionTitileArr) {
        _sectionTitileArr = [[NSMutableArray alloc] init];
    }
    return _sectionTitileArr;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.alpha = 0.5;
    }
    return _coverView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _tag = 0;
        [self addSubview:self.coverView]; //蒙版
    }
    return self;
}

- (void)setFarmerId:(NSString *)farmerId {
    [self getFishRawData:farmerId];
}

- (void)setDeviceTag:(NSInteger)deviceTag {
    _deviceTag = deviceTag;
}

#pragma mark -- 鱼塘设备状态列表
- (void)getFishRawData:(NSString *)customerIdStr {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"0" forKey:@"startTime"];
    [params setObject:@"0" forKey:@"endTime"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/%@/pondData",kUrl_Base,customerIdStr];
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self];
    [[JKHttpTool shareInstance] GetReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            [self.sectionTitileArr removeAllObjects];
            [self.rowNumberArr removeAllObjects];
            
            for (NSDictionary *dict in responseObject[@"data"]) {
                JKPondModel *pModel = [[JKPondModel alloc] init];
                pModel.farmerId = dict[@"farmerId"];
                pModel.area = dict[@"area"];
                pModel.fishVariety = dict[@"fishVariety"];
                pModel.fryNumber = dict[@"fryNumber"];
                pModel.name = dict[@"name"];
                if ([[NSString stringWithFormat:@"%@",dict[@"phoneNumber"]] isEqualToString:@"<null>"]) {
                   pModel.phoneNumber = @"";
                } else {
                   pModel.phoneNumber = dict[@"phoneNumber"];
                }
                pModel.pondAddress = dict[@"pondAddress"];
                pModel.pondId = dict[@"pondId"];
                pModel.putInDate = dict[@"putInDate"];
                if ([[NSString stringWithFormat:@"%@",dict[@"reckonSaleDate"]] isEqualToString:@"<null>"]) {
                    pModel.reckonSaleDate = @"";
                } else {
                    pModel.reckonSaleDate = dict[@"reckonSaleDate"];
                }
                pModel.region = dict[@"region"];
                pModel.childDeviceList = dict[@"childDeviceList"];
                [self.sectionTitileArr addObject:pModel];
                
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in dict[@"childDeviceList"]) {
                    JKPondChildDeviceModel *pcdModel = [[JKPondChildDeviceModel alloc] init];
                    pcdModel.alarmType = dic[@"alarmType"];
                    pcdModel.alertlineTwo = dic[@"alertlineTwo"];
                    pcdModel.automatic = dic[@"automatic"];
                    pcdModel.dissolvedOxygen = dic[@"dissolvedOxygen"];
                    pcdModel.enabled = dic[@"enabled"];
                    pcdModel.deviceId = dic[@"id"];
                    pcdModel.ident = dic[@"identifier"];
                    pcdModel.name = dic[@"name"];
                    pcdModel.oxyLimitDownOne = dic[@"oxyLimitDownOne"];
                    pcdModel.oxyLimitUp = dic[@"oxyLimitUp"];
                    pcdModel.ph = dic[@"ph"];
                    pcdModel.scheduled = dic[@"scheduled"];
                    pcdModel.temperature = dic[@"temperature"];
                    pcdModel.type = dic[@"type"];
                    pcdModel.workStatus = dic[@"workStatus"];
                    NSArray *aeratorControls = dic[@"aeratorControlList"];
                    if (aeratorControls.count != 0) {
                        pcdModel.aeratorControlOne = aeratorControls[0][@"open"];
                        pcdModel.aeratorControlTwo = aeratorControls[1][@"open"];
                    }
                    [arr addObject:pcdModel];
                }
                [self.rowNumberArr addObject:arr];
            }
        }
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            if (self.isPond) {
                if ( self.sectionTitileArr.count > 10) {
                    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.8, 10 * 48));
                } else {
                    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.8, self.sectionTitileArr.count * 48));
                }
            } else {
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.8, [self.rowNumberArr[_deviceTag] count] * 48));
                
            }
        }];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isPond) {
        if (self.sectionTitileArr.count == 0) {
            [YJProgressHUD showMessage:@"暂无鱼塘" inView:self];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self cancleView];
            });
        }
        return self.sectionTitileArr.count;
    } else {
        NSInteger count = [self.rowNumberArr[_deviceTag] count];
        if (count == 0) {
            [YJProgressHUD showMessage:@"暂无设备" inView:self];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self cancleView];
            });
        }
        return count;
    }
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
    
    if (self.isPond) {
        JKPondModel *model = self.sectionTitileArr[indexPath.row];
        cell.textLabel.text = model.name;
    } else {
        JKPondChildDeviceModel *model = self.rowNumberArr[_deviceTag][indexPath.row];
        cell.textLabel.text = model.ident;
    }

    cell.textLabel.textColor = RGBHex(0x333333);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = JKFont(16);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isPond) {
        JKPondModel *model = self.sectionTitileArr[indexPath.row];
        NSMutableArray *pondArr = [[NSMutableArray alloc] init];
        for (JKPondModel *model in self.sectionTitileArr) {
            [pondArr addObject:model.name];
        }
//        NSInteger index = [pondArr indexOfObject:model.name];
        _tag = indexPath.row;
        if ([_delegate respondsToSelector:@selector(popPondModel:withTag:)]) {
            [_delegate popPondModel:model withTag:_tag];
        }
    } else {
        JKPondChildDeviceModel *model = self.rowNumberArr[_deviceTag][indexPath.row];
        if ([_delegate respondsToSelector:@selector(popDeviceModel:)]) {
            [_delegate popDeviceModel:model];
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
