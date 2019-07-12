//
//  JKPondDeviceView.h
//  BusinessManager
//
//  Created by  on 2018/8/12.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKPondModel;
@class JKPondChildDeviceModel;
@protocol JKPondDeviceViewDelegate <NSObject>
- (void)popPondModel:(JKPondModel *)model withTag:(NSInteger)tag;
- (void)popDeviceModel:(JKPondChildDeviceModel *)model;
@end

@interface JKPondDeviceView : UIView
@property (nonatomic, strong) NSString *farmerId;
@property (nonatomic, assign) NSInteger deviceTag;
@property (nonatomic, weak) id<JKPondDeviceViewDelegate> delegate;
@property (nonatomic, assign) BOOL isPond;
@end
