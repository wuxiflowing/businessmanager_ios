//
//  JKContractFarmerCell.h
//  BusinessManager
//
//  Created by  on 2018/8/11.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKFarmerModel;

@interface JKContractFarmerCell : UITableViewCell

- (void)createUI:(JKFarmerModel *)model;
@end
