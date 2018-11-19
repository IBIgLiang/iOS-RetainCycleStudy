//
//  BLDemoModel.h
//  iOS-循环引用
//
//  Created by zhangzhiliang on 2018/11/17.
//  Copyright © 2018年 zhangzhiliang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLDemoModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) BLDemoModel *model;

@end

NS_ASSUME_NONNULL_END
