//
//  ViewController.m
//  iOS-循环引用
//
//  Created by zhangzhiliang on 2018/11/17.
//  Copyright © 2018年 zhangzhiliang. All rights reserved.
//

#import "ViewController.h"
#import "BLDemoModel.h"
#import <FBRetainCycleDetector.h>
#import "BLEdgeModel.h"

@interface ViewController ()

/**
 最终找到的环都放在这个数组里面
 */
@property (nonatomic, strong) NSMutableArray *retainCycleArrM;

/**
 去重set(因为findCycleListWithEdgeList 只查找环,不负责去重)
 */
@property (nonatomic, strong) NSMutableArray <NSSet *> *retainCycleSetArrM;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self findCycleListWithEdgeList:[self createCycleList]];
}

//TODO:  FBRetainCycleDetector 的最简单的应用
- (void)demo {
    
    BLDemoModel *model1 = [[BLDemoModel alloc] init];
    model1.name = @"model1";
    
    BLDemoModel *model2 = [[BLDemoModel alloc] init];
    model2.name = @"model2";
    
    BLDemoModel *model3 = [[BLDemoModel alloc] init];
    model3.name = @"model3";
    
    BLDemoModel *model4 = [[BLDemoModel alloc] init];
    model4.name = @"model4";
    
    model1.model = model2;
    model2.model = model3;
    model3.model = model4;
    model4.model = model1;
    
    FBRetainCycleDetector *detector = [FBRetainCycleDetector new];
    [detector addCandidate:model1];
    NSSet<NSArray<FBObjectiveCGraphElement *> *> *set =  [detector findRetainCycles];
    NSLog(@"%@", set);
    
}

// 创建一个无序图
- (NSArray *)createCycleList {
    
    [self.retainCycleArrM removeAllObjects];
    
    NSMutableArray *edgeList = [[NSMutableArray alloc] init];
    
    BLEdgeModel *model1 = [[BLEdgeModel alloc] initWithName:@"1"];
    BLEdgeModel *model2 = [[BLEdgeModel alloc] initWithName:@"2"];
    BLEdgeModel *model3 = [[BLEdgeModel alloc] initWithName:@"3"];
    BLEdgeModel *model4 = [[BLEdgeModel alloc] initWithName:@"4"];
    BLEdgeModel *model5 = [[BLEdgeModel alloc] initWithName:@"5"];
    BLEdgeModel *model6 = [[BLEdgeModel alloc] initWithName:@"6"];
    BLEdgeModel *model7 = [[BLEdgeModel alloc] initWithName:@"7"];
    BLEdgeModel *model8 = [[BLEdgeModel alloc] initWithName:@"8"];
    
    model1.edgeArr = [[NSArray alloc] initWithObjects:model2,model4,model5, nil];
    model2.edgeArr = [[NSArray alloc] initWithObjects:model1,model3, nil];
    model3.edgeArr = [[NSArray alloc] initWithObjects:model2,model4,model8, nil];
    model4.edgeArr = [[NSArray alloc] initWithObjects:model1,model3,model5,model7, nil];
    model5.edgeArr = [[NSArray alloc] initWithObjects:model1,model4,model6, nil];
    model6.edgeArr = [[NSArray alloc] initWithObjects:model5, nil];
    model7.edgeArr = [[NSArray alloc] initWithObjects:model4,model8, nil];
    model8.edgeArr = [[NSArray alloc] initWithObjects:model3,model7, nil];
    
    [edgeList addObject:model1];
    [edgeList addObject:model2];
    [edgeList addObject:model3];
    [edgeList addObject:model4];
    [edgeList addObject:model5];
    [edgeList addObject:model6];
    [edgeList addObject:model7];
    [edgeList addObject:model8];
    
    return [edgeList copy];
}

//TODO: 用DFS算法 求得所有环
- (void)findCycleListWithEdgeList:(NSArray *)edgeList {
    
    NSMutableArray *arrayMOfEdge = [[NSMutableArray alloc] init];
    
    // 先取得第一个顶点 作为起始点
    BLEdgeModel *edge = edgeList[0];
    [arrayMOfEdge addObject:edge];
    
    while (arrayMOfEdge.count > 0) {
        @autoreleasepool {
            
            BLEdgeModel *edge = arrayMOfEdge.lastObject;// 得到当前顶点列表中的最后一个顶点
            BLEdgeModel *nextEdge = [edge nextEdge];// 得到与该顶点相连接的顶点(依次取得该顶点相关联的顶点)
            
            // 如果该顶点的相连顶点已经取完 则从当前的顶点列表中删除该顶点
            if (nextEdge == nil) {
                [arrayMOfEdge removeLastObject];
                continue;
            }
            
            
            if ([arrayMOfEdge containsObject:nextEdge]) {
                // 当得到的顶点已经在 arrayMOfEdge 中, 则拿到顶点的位置
                // 判断该顶点与 arrayMOfEdge 中的最后一个顶点的长度length
                // 如果length大于1的话, 说明是 环
                // addToRetainCycleArrMWithIndex 通过该方法 将环添加到 retainCycleArrM 中
                // 如果length是1的话 说明是相邻的两个顶点
                NSUInteger index = [arrayMOfEdge indexOfObject:nextEdge];
                NSInteger length = arrayMOfEdge.count-1 - index;
                if (length > 1) {
                    [self addToRetainCycleArrMWithIndex:index withLength:length withArrayOfEdge:[arrayMOfEdge copy]];
                } else {
                    
                    // 相邻顶点时 判断是否是最后一个相连的顶点,是的话,处理index, 并且从arrayMOfEdge中删除
                    // index表示 edgeArr的偏移量
                    if (edge.index == edge.edgeArr.count) {
                        edge.index = 0;
                        [arrayMOfEdge removeLastObject];
                    }
                }
            } else {
                // 当得到的顶点不存在 arrayMOfEdge 中 添加到 arrayMOfEdge
                [arrayMOfEdge addObject:nextEdge];
            }
            
        }
    }
    
    NSLog(@"%@", self.retainCycleArrM);
}

- (void)addToRetainCycleArrMWithIndex:(NSInteger)index withLength:(NSInteger)length withArrayOfEdge:(NSArray *)arrayOfEdge {
    
    NSMutableSet *setADD = [[NSMutableSet alloc] init];
    for (NSInteger i = index; i <= length+index; i ++) {
        BLEdgeModel *model = arrayOfEdge[i];
        [setADD addObject:model];
    }
    
    if (self.retainCycleSetArrM.count > 0) {
        BOOL hasSet = NO;
        for (NSSet *set in self.retainCycleSetArrM) {
            if ([setADD isEqualToSet:set]) {
                hasSet = YES;
                break;
            }
        }
        if (!hasSet) {
            [self.retainCycleSetArrM addObject:setADD];
        } else {
            return;
        }
    } else {
        [self.retainCycleSetArrM addObject:setADD];
    }
    
    
    BLEdgeModel *model = arrayOfEdge[index];
    NSString *str = [NSString stringWithFormat:@"%@,name=%@",[model class] , model.name];
    for (NSInteger i = index+1; i <= length+index; i ++) {
        BLEdgeModel *model = arrayOfEdge[i];
        str = [str stringByAppendingString:[NSString stringWithFormat:@" -> %@,name=%@",[model class] , model.name]];
    }
    
    str = [str stringByAppendingString:[NSString stringWithFormat:@" -> %@,name=%@",[model class] , model.name]];
    
    [self.retainCycleArrM addObject:str];
}


//TODO: ---------------- 初始化 ---------------------
- (NSMutableArray *)retainCycleArrM {
    
    if (_retainCycleArrM == nil) {
        _retainCycleArrM = [[NSMutableArray alloc] init];
    }
    
    return _retainCycleArrM;
}

- (NSMutableArray<NSSet *> *)retainCycleSetArrM {
    
    if (_retainCycleSetArrM == nil) {
        _retainCycleSetArrM = [[NSMutableArray<NSSet *> alloc] init];
    }
    
    return _retainCycleSetArrM;
}

@end
