//
//  BLEdgeModel.h
//  iOS-循环引用
//
//  Created by zhangzhiliang on 2018/11/19.
//  Copyright © 2018年 zhangzhiliang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLEdgeModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray *edgeArr;

@property (nonatomic, assign) NSInteger index;

- (instancetype)initWithName:(NSString *)name;

- (BLEdgeModel *)nextEdge;

@end

NS_ASSUME_NONNULL_END
