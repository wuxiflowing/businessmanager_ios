//
//  JKRepairBottomView.h
//  BusinessManager
//
//  Created by  on 2018/6/27.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKRepairBottomViewDelegate <NSObject>
- (void)choosePond;
- (void)chooseDeviceId:(NSInteger)tag;
- (void)chooseOperationPeople;
@end

@interface JKRepairBottomView : UIView
@property (nonatomic, weak) id<JKRepairBottomViewDelegate> delegate;
@property (nonatomic, strong) UITextView *textV;
@property (nonatomic, strong) NSString *pondId;
@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, strong) NSString *operationPeopleId;
@property (nonatomic, strong) NSMutableArray *imageRepaireArr;
@end
