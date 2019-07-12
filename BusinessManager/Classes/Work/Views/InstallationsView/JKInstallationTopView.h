//
//  JKInstallationTopView.h
//  BusinessManager
//
//  Created by  on 2018/6/26.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKInstallationTopViewDelegate <NSObject>
- (void)chooseFarmers;
- (void)chooseContracts;
- (void)chooseContractServices;
@end

@interface JKInstallationTopView : UIView
@property (nonatomic, weak) id<JKInstallationTopViewDelegate> delegate;
@property (nonatomic, strong) NSString *farmerId;
@property (nonatomic, strong) NSString *contractId;
@property (nonatomic, strong) NSString *addr;
@property (nonatomic, strong) NSString *farmerName;
@property (nonatomic, strong) NSString *tel;
@end

