
# 手动实现KVO
### [git demo地址](https://github.com/NieYinlong/iOS_KVO_DIY)
看图
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200727100506603.gif)

首先说一下Apple KVO的底层实现吧

>内部实现原理
KVO是基于```runtime```机制实现的，运用了一个```isa-swizzling```技术. ```isa-swizzling```就是类型混合指针机制, 将2个对象的isa指针互相调换.
当某个类的属性对象第一次被观察时，系统就会在运行期动态地创建该类的一个派生类，在这个派生类中重写基类中任何被观察属性的setter 方法。派生类在被重写的setter方法内实现真正的通知机制
如果原类为MyPerson，那么生成的派生类名为```NSKVONotifying_MyPerson```
每个类对象中都有一个isa指针指向当前类，当一个类对象的第一次被观察，那么系统会偷偷将isa指针指向动态生成的派生类，从而在给被监控属性赋值时执行的是派生类的setter方法
键值观察通知依赖于NSObject 的两个方法: willChangeValueForKey: 和 didChangevlueForKey:；在一个被观察属性发生改变之前， willChangeValueForKey:一定会被调用，这就 会记录旧的值。而当改变发生后，didChangeValueForKey:会被调用，继而 observeValueForKey:ofObject:change:context: 也会被调用。
补充：KVO的这套实现机制中苹果还偷偷重写了class方法，让我们误认为还是使用的当前类，从而达到隐藏生成的派生类
# 开始手动实现KVO
##### 1. 创建一个```MyPerson```类, 定义一个```name```属性,
##### 2. 创建一个```NSKVONotifying_MyPerson```类继承自```MyPerson```, 然后重写父类的```setName```方法, 监听的值改变时, 回调通知观察者
```Objective-C
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
```
##### 3.创建```NSObject+KVO```分类,  添加```nyl_addObserver...```方法, 使用当前对象的isa指向新的派生类, 就会调用派生类的set方法
```Objective-C
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

```

##### 4 使用
添加观察者
```Objective-C
 [self.person nyl_addObserver:self forKeyPath:@"name" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
```
改变self.person.name的值
```Objective-C
self.person.name = @"张飞";
```

观察回调方法
```Objective-C
- (void)nyl_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"change = %@", change); // change = {new = "张飞";}
    self.nameLabel.text = change[@"new"];
}
```


### [git demo地址](https://github.com/NieYinlong/iOS_KVO_DIY)
