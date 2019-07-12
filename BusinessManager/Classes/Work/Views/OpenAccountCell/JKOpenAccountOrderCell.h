//
//  JKOpenAccountOrderCell.h
//  BusinessManager
//
//  Created by  on 2018/6/28.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKContractModel;
@protocol JKOpenAccountOrderCellDelegate <NSObject>
- (void)deleteOrderWithNumber:(NSInteger)number;
- (void)alertContractTimeWithCellTag:(NSInteger)cellTag;
@end

@interface JKOpenAccountOrderCell : UITableViewCell
@property (nonatomic, weak) id<JKOpenAccountOrderCellDelegate> delegate;


@property (nonatomic, strong) NSString *contractDateStr;
@property (nonatomic, strong) NSString *contractNameDateStr;
@property (nonatomic, strong) NSString *contractTypeStr;
@property (nonatomic, strong) NSString *contractNameStr;
@property (nonatomic, strong) NSString *farmerNameStr;
@property (nonatomic, strong) UITextField *contractAmountTF;
@property (nonatomic, strong) UITextField *actualAmountTF;
@property (nonatomic, strong) NSMutableArray *imageContractArr;
@property (nonatomic, strong) NSMutableArray *imagePayArr;
@property (nonatomic, strong) NSMutableArray *contractInfoArr;
@property (nonatomic, strong) NSMutableArray *selectDeviceArr;

- (void)createUIWithModel:(JKContractModel *)model;
@end
