//
//  JKRepairBottomView.m
//  BusinessManager
//
//  Created by  on 2018/6/27.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKRepairBottomView.h"
#import "TZImagePickerHelper.h"

#define WeakPointer(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface JKRepairBottomView () <UITableViewDelegate, UITableViewDataSource, TZImagePickerControllerDelegate, UITextViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSString *operationPeopleStr;
@property (nonatomic, strong) NSString *pondNameStr;
@property (nonatomic, strong) NSString *pondAddr;
@property (nonatomic, strong) NSString *pondTel;
@property (nonatomic, strong) NSString *deviceName;
@property (nonatomic, strong) NSString *deviceType;
@property (nonatomic, strong) TZImagePickerHelper *repaireHelper;
@property (nonatomic, strong) NSMutableArray *imageRepaireURL;
@property (nonatomic, assign) NSInteger tags;
@property (nonatomic, strong) UILabel *repairPictureLb;
@end

@implementation JKRepairBottomView

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kClearColor;
        _tableView.separatorColor = RGBHex(0xdddddd);
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (TZImagePickerHelper *)repaireHelper {
    if (!_repaireHelper) {
        _repaireHelper = [[TZImagePickerHelper alloc] init];
        WeakPointer(weakSelf);
        _repaireHelper.imageType = JKImageTypeRepaire;
        _repaireHelper.finishRepaire = ^(NSArray *array, NSArray *imageArr) {
            [weakSelf.imageRepaireURL addObjectsFromArray:array];
            NSLog(@"%@",weakSelf.imageRepaireURL);
            for (NSString *str in imageArr) {
                [weakSelf.imageRepaireArr addObject:str];
            }
            //            [weakSelf saveImage:imageArr withImageType:JKImageTypeIDFront];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:8 inSection:0];
                NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
                [weakSelf.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            });
        };
    }
    return _repaireHelper;
}

- (NSMutableArray *)imageRepaireURL {
    if (!_imageRepaireURL) {
        _imageRepaireURL = [NSMutableArray array];
    }
    return _imageRepaireURL;
}


- (NSMutableArray *)imageRepaireArr {
    if (!_imageRepaireArr) {
        _imageRepaireArr = [NSMutableArray array];
    }
    return _imageRepaireArr;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = kWhiteColor;

        self.titleArr = @[@"报修信息", @"*选择鱼塘", @"鱼塘地址", @"*设备ID", @"设备型号", @"鱼塘联系方式", @"*运维管家", @"故障描述", @""];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRepaireOperationPeopleCell:)name:@"reloadRepaireOperationPeopleCell" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPondCell:)name:@"reloadPondCell" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDeviceCell:)name:@"reloadDeviceCell" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRepaireBottomView:)name:@"reloadRepaireBottomView" object:nil];
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self);
        }];
    }
    return self;
}

- (void)reloadRepaireOperationPeopleCell:(NSNotification *)noti {
    self.operationPeopleStr = noti.userInfo[@"memName"];
    self.operationPeopleId = noti.userInfo[@"memId"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
    NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadPondCell:(NSNotification *)noti {
    self.pondNameStr = noti.userInfo[@"pondName"];
    self.pondId = noti.userInfo[@"pondId"];
    self.pondAddr = noti.userInfo[@"pondAddr"];
    self.pondTel = noti.userInfo[@"phone"];
    self.tags = [noti.userInfo[@"tag"] integerValue];
    self.deviceName = nil;
    self.deviceId = nil;
    self.deviceType = nil;
    NSIndexPath *indexPathOne = [NSIndexPath indexPathForRow:1 inSection:0];
    NSArray <NSIndexPath *> *indexPathArrayOne = @[indexPathOne];
    [self.tableView reloadRowsAtIndexPaths:indexPathArrayOne withRowAnimation:UITableViewRowAnimationNone];
    NSIndexPath *indexPathTwo = [NSIndexPath indexPathForRow:2 inSection:0];
    NSArray <NSIndexPath *> *indexPathArrayTwo = @[indexPathTwo];
    [self.tableView reloadRowsAtIndexPaths:indexPathArrayTwo withRowAnimation:UITableViewRowAnimationNone];
    NSIndexPath *indexPathThree = [NSIndexPath indexPathForRow:5 inSection:0];
    NSArray <NSIndexPath *> *indexPathArrayThree = @[indexPathThree];
    [self.tableView reloadRowsAtIndexPaths:indexPathArrayThree withRowAnimation:UITableViewRowAnimationNone];
    NSIndexPath *indexPathFour = [NSIndexPath indexPathForRow:3 inSection:0];
    NSArray <NSIndexPath *> *indexPathArrayFour = @[indexPathFour];
    [self.tableView reloadRowsAtIndexPaths:indexPathArrayFour withRowAnimation:UITableViewRowAnimationNone];
    NSIndexPath *indexPathFive = [NSIndexPath indexPathForRow:4 inSection:0];
    NSArray <NSIndexPath *> *indexPathArrayFive = @[indexPathFive];
    [self.tableView reloadRowsAtIndexPaths:indexPathArrayFive withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadRepaireBottomView:(NSNotification *)noti {
    self.pondNameStr = nil;
    self.pondId = nil;
    self.pondAddr = nil;
    self.pondTel = nil;
    self.deviceName = nil;
    self.deviceId = nil;
    self.deviceType = nil;
    self.operationPeopleStr = nil;
    [self.tableView reloadData];
}

- (void)reloadDeviceCell:(NSNotification *)noti {
    self.deviceName = noti.userInfo[@"deviceName"];
    self.deviceId = noti.userInfo[@"deviceId"];
    self.deviceType = noti.userInfo[@"deviceType"];
    NSIndexPath *indexPathOne = [NSIndexPath indexPathForRow:3 inSection:0];
    NSArray <NSIndexPath *> *indexPathArrayOne = @[indexPathOne];
    [self.tableView reloadRowsAtIndexPaths:indexPathArrayOne withRowAnimation:UITableViewRowAnimationNone];
    NSIndexPath *indexPathTwo = [NSIndexPath indexPathForRow:4 inSection:0];
    NSArray <NSIndexPath *> *indexPathArrayTwo = @[indexPathTwo];
    [self.tableView reloadRowsAtIndexPaths:indexPathArrayTwo withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 7) {
        return 90;
    } else if (indexPath.row == 8) {
        return 140;
    } else {
        return 48;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID = [NSString stringWithFormat:@"cell%ld",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    cell.textLabel.text = self.titleArr[indexPath.row];
    cell.textLabel.textColor = RGBHex(0x333333);
    cell.textLabel.font = JKFont(14);
    cell.detailTextLabel.font = JKFont(14);
    cell.detailTextLabel.textColor = RGBHex(0x333333);
    
    if ([cell.textLabel.text hasPrefix:@"*"]) {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:cell.textLabel.text];
        [attString addAttribute:NSForegroundColorAttributeName value:kRedColor range:NSMakeRange(0, 1)];
        cell.textLabel.attributedText = attString;
    }
    
    if (indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 6) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.font = JKFont(16);
    } else if (indexPath.row == 1) {
        if (self.pondNameStr == nil) {
            cell.detailTextLabel.text = @"请选择鱼塘";
            cell.detailTextLabel.textColor = RGBHex(0xcacaca);
        } else {
            cell.detailTextLabel.text = self.pondNameStr;
        }
    } else if (indexPath.row == 2) {
        if (self.pondAddr == nil) {
            cell.detailTextLabel.text = @"鱼塘地址";
            cell.detailTextLabel.textColor = RGBHex(0xcacaca);
        } else {
            cell.detailTextLabel.text = self.pondAddr;
        }
        cell.detailTextLabel.numberOfLines = 2;
    } else if (indexPath.row == 3) {
        if (self.deviceId == nil) {
            cell.detailTextLabel.text = @"请选择设备";
            cell.detailTextLabel.textColor = RGBHex(0xcacaca);
        } else {
            cell.detailTextLabel.text = self.deviceId;
        }
    } else if (indexPath.row == 4) {
        if (self.deviceType == nil) {
            cell.detailTextLabel.text = @"请选择设备型号";
            cell.detailTextLabel.textColor = RGBHex(0xcacaca);
        } else {
            cell.detailTextLabel.text = self.deviceType;
        }
    } else if (indexPath.row == 5) {
        if (self.pondAddr == nil) {
            cell.detailTextLabel.text = @"联系电话";
            cell.detailTextLabel.textColor = RGBHex(0xcacaca);
        } else {
            cell.detailTextLabel.text = self.pondTel;
        }
    } else if (indexPath.row == 6) {
        if (self.operationPeopleStr == nil) {
            cell.detailTextLabel.text = @"请选择运维管家";
            cell.detailTextLabel.textColor = RGBHex(0xcacaca);
        } else {
            cell.detailTextLabel.text = self.operationPeopleStr;
        }
    } else if (indexPath.row == 7) {
        UITextView *textV = [[UITextView alloc] init];
        textV.font = JKFont(14);
        textV.textColor = RGBHex(0x666666);
        textV.layer.borderColor = RGBHex(0xdddddd).CGColor;
        textV.layer.borderWidth = 1;
        [textV setPlaceholder:@"问题描述" placeholdColor: RGBHex(0xdddddd)];
        textV.delegate = self;
        [cell.contentView addSubview:textV];
        [textV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top).offset(10);
            make.left.equalTo(cell.contentView.mas_left).offset(100);
            make.right.equalTo(cell.contentView.mas_right).offset(-15);
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-10);
        }];
        self.textV = textV;
    } else if (indexPath.row == 8) {
//        [self.repairPictureLb removeFromSuperview];
        UILabel *repairPictureLb = [[UILabel alloc] init];
        repairPictureLb.text = @"上传报修照片";
        repairPictureLb.textColor = RGBHex(0x333333);
        repairPictureLb.textAlignment = NSTextAlignmentLeft;
        repairPictureLb.font = JKFont(14);
        [cell.contentView addSubview:repairPictureLb];
        [repairPictureLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView);
            make.left.equalTo(cell.contentView.mas_left).offset(15);
            make.right.equalTo(cell.contentView.mas_right).offset(-15);
            make.height.mas_equalTo(48);
        }];
//        self.repairPictureLb = repairPictureLb;
        
        [self createScrollImageUI:repairPictureLb withCell:cell withImageType:JKImageTypeRepaire withImageArr:self.imageRepaireURL];
    }
    
    return cell;
}

- (void)createScrollImageUI:(UILabel *)titleLb withCell:(UITableViewCell *)cell withImageType:(JKImageType)imageType withImageArr:(NSMutableArray *)imgArr {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = kWhiteColor;
    [cell.contentView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLb.mas_bottom);
        make.left.equalTo(cell.contentView.mas_left).offset(15);
        make.right.equalTo(cell.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(80);
    }];
    
    scrollView.contentSize = CGSizeMake(90 *(imgArr.count +1), 80);
    
    if (imgArr.count == 0) {
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(0, 0, 80, 80);
        addBtn.tag = imageType;
        [addBtn setImage:[UIImage imageNamed:@"ic_image_add"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:addBtn];
    } else {
        if (imgArr.count == 9) {
            for (NSInteger i = 0; i < imgArr.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(90 * i , 0, 80, 80);
                btn.tag = i;
                [btn setImage:[UIImage imageWithContentsOfFile:imgArr[i]] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(showImageClick:) forControlEvents:UIControlEventTouchUpInside];
                [scrollView addSubview:btn];
                
                UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                deleteBtn.frame = CGRectMake(60, 0, 20, 20);
                deleteBtn.tag = i + 20;
                [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [deleteBtn setImage:[UIImage imageNamed:@"ic_image_delete"] forState:UIControlStateNormal];
                [btn addSubview:deleteBtn];
            }
        } else {
            for (NSInteger i = 0; i < imgArr.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(90 * i , 0, 80, 80);
                btn.tag = i;
                [btn setImage:[UIImage imageWithContentsOfFile:imgArr[i]] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(showImageClick:) forControlEvents:UIControlEventTouchUpInside];
                [scrollView addSubview:btn];
                
                UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                deleteBtn.frame = CGRectMake(60, 0, 20, 20);
                deleteBtn.tag = i + 20;
                [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [deleteBtn setImage:[UIImage imageNamed:@"ic_image_delete"] forState:UIControlStateNormal];
                [btn addSubview:deleteBtn];
                
                UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                addBtn.frame = CGRectMake(90 * (i + 1), 0, 80, 80);
                addBtn.tag = imageType;
                [addBtn setImage:[UIImage imageNamed:@"ic_image_add"] forState:UIControlStateNormal];
                [addBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [scrollView addSubview:addBtn];
            }
        }
    }
}

- (void)btnClick:(UIButton *)btn {
    [self.repaireHelper showImagePickerControllerWithMaxCount:(9 - self.imageRepaireArr.count) WithViewController:[self View:self]];
}

- (void)showImageClick:(UIButton *)btn {
    JKShowImagePagesView *sipV = [[JKShowImagePagesView alloc] init];
    sipV.frame = [UIScreen mainScreen].bounds;
    [sipV showGuideViewWithImages:self.imageRepaireURL withTag:btn.tag];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: sipV];
}

- (void)deleteBtnClick:(UIButton *)btn {
    [self.imageRepaireURL removeObjectAtIndex:(btn.tag - 20)];
    [self.imageRepaireArr removeObjectAtIndex:(btn.tag - 20)];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:8 inSection:0];
    NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -- view对应的UIViewController
- (UIViewController *)View:(UIView *)view {
    UIResponder *responder = view;
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        if ([_delegate respondsToSelector:@selector(choosePond)]) {
            [_delegate choosePond];
        }
    } else if (indexPath.row == 3) {
        if ([_delegate respondsToSelector:@selector(chooseDeviceId:)]) {
            [_delegate chooseDeviceId:self.tags];
        }
    } else if (indexPath.row == 6) {
        if ([_delegate respondsToSelector:@selector(chooseOperationPeople)]) {
            [_delegate chooseOperationPeople];
        }
    }
}

#pragma mark -- cell的分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        return NO;
    }
    
    NSString *tem = [[text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![text isEqualToString:tem]) {
        return NO;
    }
    
    return YES;
}

@end
