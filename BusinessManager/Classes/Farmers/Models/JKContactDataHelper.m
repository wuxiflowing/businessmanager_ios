//
//  JKContactDataHelper.m
//  BusinessManager
//
//  Created by  on 2018/8/9.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKContactDataHelper.h"
#import "JKFarmerModel.h"

@implementation JKContactDataHelper

+ (NSMutableArray *)getFriendListDataBy:(NSMutableArray *)array{
    NSMutableArray *ans = [[NSMutableArray alloc] init];
    
    NSArray *serializeArray = [(NSArray *)array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {//排序
        int i;
        NSString *strA = ((JKFarmerModel *)obj1).pinyin;
        NSString *strB = ((JKFarmerModel *)obj2).pinyin;
        for (i = 0; i < strA.length && i < strB.length; i ++) {
            char a = [strA characterAtIndex:i];
            char b = [strB characterAtIndex:i];
            if (a > b) {
                return (NSComparisonResult)NSOrderedDescending;//上升
            }
            else if (a < b) {
                return (NSComparisonResult)NSOrderedAscending;//下降
            }
        }
        
        if (strA.length > strB.length) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if (strA.length < strB.length){
            return (NSComparisonResult)NSOrderedAscending;
        }else{
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
    
    char lastC = '1';
    NSMutableArray *data;
    NSMutableArray *oth = [[NSMutableArray alloc] init];
    for (JKFarmerModel *model in serializeArray) {
        if ([model.pinyin isEqualToString:@""]) {
            continue;
        }
        char c = [model.pinyin characterAtIndex:0];
        if (!isalpha(c)) {
            [oth addObject:model];
        }
        else if (c != lastC){
            lastC = c;
            if (data && data.count > 0) {
                [ans addObject:data];
            }
            
            data = [[NSMutableArray alloc] init];
            [data addObject:model];
        }
        else {
            [data addObject:model];
        }
    }
    if (data && data.count > 0) {
        [ans addObject:data];
    }
    if (oth.count > 0) {
        [ans addObject:oth];
    }
    return ans;
}

+ (NSMutableArray *)getFriendListSectionBy:(NSMutableArray *)array{
    NSMutableArray *section = [[NSMutableArray alloc] init];
//    [section addObject:@""];
    for (NSArray *item in array) {
        JKFarmerModel *model = [item objectAtIndex:0];
        char c = [model.pinyin characterAtIndex:0];
        if (!isalpha(c)) {
            c = '#';
        }
        [section addObject:[NSString stringWithFormat:@"%c", toupper(c)]];
    }
    return section;
}

@end
