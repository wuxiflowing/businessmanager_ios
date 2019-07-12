//
//  JKMaintainInfoMidCell.h
//  BusinessManager
//
//  Created by  on 2018/6/25.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKMaintainInfoMidCellDelegate <NSObject>
- (void)clickOrderBtn:(UIButton *)btn;
@end

@interface JKMaintainInfoMidCell : UITableViewCell
@property (nonatomic, weak) id<JKMaintainInfoMidCellDelegate> delegate;
@property (nonatomic, assign) JKMaintain maintainType;
- (void)createUI;
@end
