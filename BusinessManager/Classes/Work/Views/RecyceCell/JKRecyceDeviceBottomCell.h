//
//  JKRecyceDeviceBottomCell.h
//  BusinessManager
//
//  Created by  on 2018/7/2.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKRecyceDeviceBottomCellDelegate <NSObject>
- (void)chooseOperationPeople;
@end

@interface JKRecyceDeviceBottomCell : UITableViewCell
@property (nonatomic, weak) id<JKRecyceDeviceBottomCellDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSString *bankAccount;
@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *bankPerson;
@property (nonatomic, strong) UITextView *textV;
@end
