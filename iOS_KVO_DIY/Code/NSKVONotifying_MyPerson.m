//
//  NSKVONotifying_MyPerson.m
//  手动实现KVO
//
//  Created by 聂银龙 on 2020/7/26.
//  Copyright © 2020 聂银龙. All rights reserved.
//

#import "NSKVONotifying_MyPerson.h"
#import <objc/runtime.h>
#import "NSObject+KVO.h"

@implementation NSKVONotifying_MyPerson

// 重写setter方法
- (void)setName:(NSString *)name
{
    [super setName:name];
    
    // 监听的值改变时, 回调通知观察者
    id observer = objc_getAssociatedObject(self, @"observer");
    id keyPath = objc_getAssociatedObject(self, @"keyPath");
    id context = objc_getAssociatedObject(self, @"context");
    
    if (observer) {
        
        NSDictionary *dic = @{@"new" : name};
        
        [observer nyl_observeValueForKeyPath:keyPath ofObject:self change:dic context:nil];
    }
}

@end
