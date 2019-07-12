//
//  JKRecyceResultCell.m
//  OperationsManager
//
//  Created by  on 2018/7/9.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKRecyceResultCell.h"
#import "TZImagePickerHelper.h"
#import "JKRecyceInfoModel.h"

#define WeakPointer(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface JKRecyceResultCell() <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *noBtn;
@property (nonatomic, strong) UIButton *yesBtn;
@property (nonatomic, strong) UIScrollView *pictureScrollView;
@property (nonatomic, strong) UIScrollView *orderScrollView;
@property (nonatomic, strong) NSMutableArray *imagePhotoURL;
@property (nonatomic, strong) NSMutableArray *imageOrderURL;
@property (nonatomic, strong) UILabel *orderLb;
@property (nonatomic, strong) UILabel *pictureLb;

@end

@implementation JKRecyceResultCell

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kBgColor;
        _tableView.separatorColor = RGBHex(0xdddddd);
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (UIScrollView *)pictureScrollView {
    if (!_pictureScrollView) {
        _pictureScrollView = [[UIScrollView alloc] init];
        _pictureScrollView.showsHorizontalScrollIndicator = NO;
        _pictureScrollView.backgroundColor = kWhiteColor;
    }
    return _pictureScrollView;
}

- (UIScrollView *)orderScrollView {
    if (!_orderScrollView) {
        _orderScrollView = [[UIScrollView alloc] init];
        _orderScrollView.showsHorizontalScrollIndicator = NO;
        _orderScrollView.backgroundColor = kWhiteColor;
    }
    return _orderScrollView;
}

- (NSMutableArray *)imagePhotoURL {
    if (!_imagePhotoURL) {
        _imagePhotoURL = [NSMutableArray array];
    }
    return _imagePhotoURL;
}

- (NSMutableArray *)imagePhotoArr {
    if (!_imagePhotoArr) {
        _imagePhotoArr = [NSMutableArray array];
    }
    return _imagePhotoArr;
}

- (NSMutableArray *)imageOrderURL {
    if (!_imageOrderURL) {
        _imageOrderURL = [NSMutableArray array];
    }
    return _imageOrderURL;
}

- (NSMutableArray *)imageOrderArr {
    if (!_imageOrderArr) {
        _imageOrderArr = [NSMutableArray array];
    }
    return _imageOrderArr;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kBgColor;
        
        [self createUI];
        _chooseSingle = YES;

    }
    return self;
}

- (void)createUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = kWhiteColor;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.left.right.bottom.equalTo(self);
    }];
    
    [bgView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.left.right.bottom.equalTo(bgView);
    }];
}

#pragma mark -- 回收信息是否符合
- (void)singleSelected:(UIButton *)btn {
    if (!btn.selected) {
        btn.selected = !btn.selected;
        if (btn.tag == 0) {
            self.noBtn.selected = NO;
        } else {
            self.yesBtn.selected = NO;
        }
        _chooseSingle = !_chooseSingle;
    }
}

//- (void)setDataSource:(NSMutableArray *)dataSource {
//    _dataSource = dataSource;
//    NSLog(@"%ld",_dataSource.count);
////    [self.tableView reloadData];
//}

- (void)setModel:(JKRecyceInfoModel *)model {
    _model = model;
    [self.tableView reloadData];
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 1) {
        return 48;
    } else if (indexPath.row == 2 || indexPath.row == 3) {
        if (self.recyceType == JKRecyceIng) {
            return 100;
        } else {
            return 60;
        }
    } else {
        return 150;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.font = JKFont(14);
    cell.textLabel.textColor = RGBHex(0x333333);
    cell.detailTextLabel.font = JKFont(14);
    cell.detailTextLabel.textColor = RGBHex(0x999999);
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"处理结果";
        cell.textLabel.font = JKFont(16);
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"设备是否完好";

        if (self.model.rdoYes) {
            cell.detailTextLabel.text = @"是";
        } else {
            cell.detailTextLabel.text = @"否";
        }
        
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"说明";
        cell.detailTextLabel.text = self.model.tarExplain;
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
        cell.detailTextLabel.numberOfLines = 2;
//        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"备注";
        cell.detailTextLabel.text = self.model.tarRemarks;
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
        cell.detailTextLabel.numberOfLines = 2;
//        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        
    } else if (indexPath.row == 4) {
        [self.pictureLb removeFromSuperview];
        UILabel *pictureLb = [[UILabel alloc] init];
        pictureLb.textColor = RGBHex(0x333333);
        pictureLb.textAlignment = NSTextAlignmentLeft;
        pictureLb.font = JKFont(14);
        [cell addSubview:pictureLb];
        [pictureLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell);
            make.left.equalTo(cell).offset(15);
            make.width.mas_offset(200);
            make.height.mas_equalTo(48);
        }];
        self.pictureLb = pictureLb;
        
        pictureLb.text = @"损坏设备照片";
        
        [cell addSubview:self.pictureScrollView];
        [self.pictureScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(pictureLb.mas_bottom);
            make.left.equalTo(cell.mas_left).offset(SCALE_SIZE(15));
            make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
            make.height.mas_equalTo(80);
        }];
        
        if (self.model.txtDamageImgSrc.length != 0) {
            self.model.txtDamageImgSrc = [self.model.txtDamageImgSrc stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSArray *brokenUrls = [self.model.txtDamageImgSrc componentsSeparatedByString:@","];
            self.pictureScrollView.contentSize = CGSizeMake(90 * brokenUrls.count, 80);
            
            for (NSInteger i = 0; i < brokenUrls.count; i++) {
                UIImageView *imgV = [[UIImageView alloc] init];
                imgV.frame = CGRectMake(90 * i , 0, 80, 80);
                imgV.userInteractionEnabled = YES;
                imgV.yy_imageURL = [NSURL URLWithString:brokenUrls[i]];
                imgV.contentMode = UIViewContentModeScaleAspectFit;
                [self.pictureScrollView addSubview:imgV];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(0 , 0, 110, 110);
                btn.tag = i;
                [btn addTarget:self action:@selector(brokenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [imgV addSubview:btn];
            }
        }
    } else {
        [self.orderLb removeFromSuperview];
        UILabel *orderLb = [[UILabel alloc] init];
        orderLb.textColor = RGBHex(0x333333);
        orderLb.textAlignment = NSTextAlignmentLeft;
        orderLb.font = JKFont(14);
        [cell addSubview:orderLb];
        [orderLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell);
            make.left.equalTo(cell).offset(15);
            make.width.mas_offset(200);
            make.height.mas_equalTo(48);
        }];
        self.orderLb = orderLb;
        
        orderLb.text = @"设备回收单";
        
        [cell addSubview:self.orderScrollView];
        [self.orderScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(orderLb.mas_bottom);
            make.left.equalTo(cell.mas_left).offset(SCALE_SIZE(15));
            make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
            make.height.mas_equalTo(80);
        }];
        
        if (self.model.txtFormImgSrc.length != 0) {
            self.model.txtFormImgSrc = [self.model.txtFormImgSrc stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSArray *recycleUrls = [self.model.txtFormImgSrc componentsSeparatedByString:@","];
            self.orderScrollView.contentSize = CGSizeMake(90 * recycleUrls.count, 80);
            
            for (NSInteger i = 0; i < recycleUrls.count; i++) {
                UIImageView *imgV = [[UIImageView alloc] init];
                imgV.frame = CGRectMake(90 * i , 0, 80, 80);
                imgV.userInteractionEnabled = YES;
                imgV.yy_imageURL = [NSURL URLWithString:recycleUrls[i]];
                imgV.contentMode = UIViewContentModeScaleAspectFit;
                [self.orderScrollView addSubview:imgV];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(0 , 0, 110, 110);
                btn.tag = i;
                [btn addTarget:self action:@selector(recycleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [imgV addSubview:btn];
            }
        }
    }
    
    return cell;
}

- (void)brokenBtnClick:(UIButton *)btn {
    NSArray *brokenUrls = [self.model.txtDamageImgSrc componentsSeparatedByString:@","];
    JKShowImagePagesView *sipV = [[JKShowImagePagesView alloc] init];
    sipV.frame = [UIScreen mainScreen].bounds;
    [sipV showGuideViewWithImages:brokenUrls withTag:btn.tag];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: sipV];
}

- (void)recycleBtnClick:(UIButton *)btn {
    NSArray *recycleUrls = [self.model.txtFormImgSrc componentsSeparatedByString:@","];
    JKShowImagePagesView *sipV = [[JKShowImagePagesView alloc] init];
    sipV.frame = [UIScreen mainScreen].bounds;
    [sipV showGuideViewWithImages:recycleUrls withTag:btn.tag];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: sipV];
}

#pragma mark -- cell的分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

@end
