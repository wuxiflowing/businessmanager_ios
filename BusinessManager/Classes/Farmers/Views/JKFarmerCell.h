//
//  JKFarmerCell.h
//  BusinessManager
//
//  Created by  on 2018/8/9.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKFarmerModel;
@protocol JKFarmerCellDelegate <NSObject>
- (void)callFarmerPhone:(JKFarmerModel *)model;
@end

@interface JKFarmerCell : UITableViewCell
@property (nonatomic, weak) id<JKFarmerCellDelegate> delegate;
- (void)createUI:(JKFarmerModel *)model;
@end
