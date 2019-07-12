//
//  JKRecyceCell.h
//  BusinessManager
//
//  Created by  on 2018/6/22.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKTaskModel;

@protocol JKRecyceCellDelegate <NSObject>
- (void)callFarmerPhone:(NSString *)phoneNumber;
@end

@interface JKRecyceCell : UITableViewCell
@property (nonatomic, assign) JKRecyce recyceType;
@property (nonatomic, weak) id<JKRecyceCellDelegate> delegate;
@property (nonatomic, strong) NSString *telStr;
@property (nonatomic, strong) NSString *addrStr;
- (void)createUI:(JKTaskModel *)model;
@end
