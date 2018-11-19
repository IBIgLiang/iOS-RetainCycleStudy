//
//  BLEdgeModel.m
//  iOS-循环引用
//
//  Created by zhangzhiliang on 2018/11/19.
//  Copyright © 2018年 zhangzhiliang. All rights reserved.
//

#import "BLEdgeModel.h"

@implementation BLEdgeModel

- (instancetype)initWithName:(NSString *)name{
    
    if (self = [super init]) {
        _name = name;
    }
    
    return self;
}

- (BLEdgeModel *)nextEdge {
    
    if (self.index == self.edgeArr.count) {
        self.index = 0;
        return nil;
    }
    
    BLEdgeModel *next = self.edgeArr[self.index];
    self.index++;
    return next;
}

@end
