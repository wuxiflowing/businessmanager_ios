//
//  JKRecyceDeviceTopCell.h
//  BusinessManager
//
//  Created by  on 2018/7/2.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKRecyceDeviceTopCellDelegate <NSObject>
- (void)chooseFarmers;
@end

@interface JKRecyceDeviceTopCell : UITableViewCell
@property (nonatomic, weak) id<JKRecyceDeviceTopCellDelegate> delegate;
@property (nonatomic, strong) NSString *farmerId;
@end
