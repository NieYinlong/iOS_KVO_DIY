//
//  NSObject+KVO.h
//  手动实现KVO
//
//  Created by 聂银龙 on 2020/7/26.
//  Copyright © 2020 聂银龙. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (KVO)


- (void)nyl_addObserver:(NSObject *)observer
             forKeyPath:(NSString *)keyPath
                options:(NSKeyValueObservingOptions)options
                context:(nullable void *)context;


- (void)nyl_removeObserver:(NSObject *)observer
                forKeyPath:(NSString *)keyPath
                   context:(nullable void *)context;


- (void)nyl_observeValueForKeyPath:(NSString *)keyPath
                          ofObject:(id)object
                            change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                           context:(void *)context;

@end

NS_ASSUME_NONNULL_END
