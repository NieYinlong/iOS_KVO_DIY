//
//  ViewController.m
//  手动实现KVO
//
//  Created by 聂银龙 on 2020/7/26.
//  Copyright © 2020 聂银龙. All rights reserved.
//

#import "ViewController.h"
#import "MyPerson.h"
#import <objc/message.h>
#import "NSObject+KVO.h"

@interface ViewController ()

@property (nonatomic, strong) MyPerson *person;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MyPerson *person = [MyPerson new];
    person.name = @"诸葛亮";
    
    self.person = person;
    NSLog(@"2. 添加观察者之前 person class = %s", object_getClassName(person)); // MyPerson
    
//    [person addObserver:self forKeyPath:@"name" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    
    [person nyl_addObserver:self forKeyPath:@"name" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    
    // runtime运行时动态添加了一个NSKVONotifying_MyPerson的类, 继承自MyPerson
    NSLog(@"2. 添加观察者之后 person class = %s", object_getClassName(person)); // NSKVONotifying_MyPerson
    
    self.nameLabel.text = person.name;
}


- (void)nyl_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"change = %@", change);
    self.nameLabel.text = change[@"new"];
    NSLog(@"");
}


//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
//{
//    NSLog(@"change = %@", change);
//}


- (IBAction)changeBtnClick:(id)sender {
    self.person.name = @"张飞";
}


@end
