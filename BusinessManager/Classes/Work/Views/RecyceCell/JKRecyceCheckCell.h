//
//  JKRecyceCheckCell.h
//  BusinessManager
//
//  Created by  on 2018/11/22.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKTaskModel;

@protocol JKRecyceCheckCellDelegate <NSObject>
- (void)callFarmerPhone:(NSString *)phoneNumber;
@end

@interface JKRecyceCheckCell : UITableViewCell
@property (nonatomic, assign) JKRecyce recyceType;
@property (nonatomic, weak) id<JKRecyceCheckCellDelegate> delegate;
@property (nonatomic, strong) NSString *telStr;
@property (nonatomic, strong) NSString *addrStr;
- (void)createUI:(JKTaskModel *)model;
@end
