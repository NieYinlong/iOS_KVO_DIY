//
//  NSObject+KVO.m
//  手动实现KVO
//
//  Created by 聂银龙 on 2020/7/26.
//  Copyright © 2020 聂银龙. All rights reserved.
//

#import "NSObject+KVO.h"
#import "NSKVONotifying_MyPerson.h"
#import <objc/runtime.h>

@implementation NSObject (KVO)


- (void)nyl_addObserver:(NSObject *)observer
             forKeyPath:(NSString *)keyPath
                options:(NSKeyValueObservingOptions)options
                context:(nullable void *)context
{
    // 使用当前对象的isa指向新的派生类(NSKVONotifying_MyPerson), 就会调用派生类的set方法
    object_setClass(self, [NSKVONotifying_MyPerson class]);
    
    // 给分类添加属性
    objc_setAssociatedObject(self, @"observer", observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, @"keyPath", keyPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, @"context", [NSString stringWithFormat:@"%@", context], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}


- (void)nyl_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(nullable void *)context
{
    // 移除
    objc_setAssociatedObject(self, @"observer", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @"keyPath", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @"context", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)nyl_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
 
    NSLog(@"子类去实现");
    
}

@end
