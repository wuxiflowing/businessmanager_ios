//
//  JKInstallationsCell.h
//  BusinessManager
//
//  Created by  on 2018/6/22.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKTaskModel;

@protocol JKInstallationsCellDelegate <NSObject>
- (void)callFarmerPhone:(NSString *)phoneNumber;
@end

@interface JKInstallationsCell : UITableViewCell
@property (nonatomic, weak) id<JKInstallationsCellDelegate> delegate;
@property (nonatomic, assign) JKInstallation installType;
@property (nonatomic, strong) NSString *telStr;
@property (nonatomic, strong) NSString *addrStr;
- (void)createUI:(JKTaskModel *)model;

@end
