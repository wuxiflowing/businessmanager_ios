//
//  JKInstallationBottomView.h
//  BusinessManager
//
//  Created by  on 2018/6/26.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKInstallationBottomViewDelegate <NSObject>
- (void)chooseOperationPeoples;
- (void)chooseInstallationTime;
- (void)locationAddr;
@end

@interface JKInstallationBottomView : UIView
@property (nonatomic, weak) id<JKInstallationBottomViewDelegate> delegate;
@property (nonatomic, strong) UITextField *addrTF;
@property (nonatomic, strong) NSString *operationPeopleStr;
@property (nonatomic, strong) NSString *memIdStr;
@property (nonatomic, strong) NSString *installTimeStr;
@property (nonatomic, strong) NSString *depositSumStr;
@property (nonatomic, strong) NSString *serviceSumStr;
@property (nonatomic, strong) NSString *addrStr;

@end
