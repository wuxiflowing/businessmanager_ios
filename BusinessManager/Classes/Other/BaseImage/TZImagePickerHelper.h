//
//  TZImagePickerHelper.h
//  BusinessManager
//
//  Created by  on 2018/8/9.
//  Copyright © 2018年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TZImagePickerHelper : NSObject <UINavigationControllerDelegate,  UIImagePickerControllerDelegate, TZImagePickerControllerDelegate>

@property (nonatomic, assign) JKImageType imageType;
@property (nonatomic, copy) void(^finishIDFront)(NSArray *array, NSArray *imageArr);
@property (nonatomic, copy) void(^finishIDBackground)(NSArray *array, NSArray *imageArr);
@property (nonatomic, copy) void(^finishAccount)(NSArray *array, NSArray *imageArr);
@property (nonatomic, copy) void(^finishFarmer)(NSArray *array, NSArray *imageArr);
@property (nonatomic, copy) void(^finishPond)(NSArray *array, NSArray *imageArr);
@property (nonatomic, copy) void(^finishRepaire)(NSArray *array, NSArray *imageArr);
@property (nonatomic, copy) void(^finishContract)(NSArray *array, NSArray *imageArr);
@property (nonatomic, copy) void(^finishPay)(NSArray *array, NSArray *imageArr);
@property (nonatomic, copy) void(^finishRecyceAnnex)(NSArray *array, NSArray *imageArr);
@property (nonatomic, copy) void(^finishMaintain)(NSArray *array, NSArray *imageArr);
@property (nonatomic, copy) void(^finishAttachFile)(NSArray *array, NSArray *imageArr);

- (void)showImagePickerControllerWithMaxCount:(NSInteger )maxCount WithViewController: (UIViewController *)superController;

@end
