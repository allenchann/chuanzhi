//
//  ViewController.m
//  chuanzhi
//
//  Created by allen_Chan on 16/8/10.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

@interface ViewController ()<changeName>

@end

@implementation ViewController

//必实现的方法
- (void)changeTitle:(NSString *)name
{
    self.title = name;
}

//可选的实现方法
- (void)changeBackgroundColor:(UIColor *)color
{
    self.view.backgroundColor = color;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"push" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    
    
    //添加一个观察者，可以为它指定一个方法，名字和对象。接受到通知时，执行方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeName:) name:@"CHANGENAMENOTIFICE" object:nil];
}

- (void)changeName:(NSNotification *)noti
{
    if (noti.userInfo)
    {
        if (noti.object)
            self.title = [NSString stringWithFormat:@"%@+%@",noti.object,noti.userInfo[@"name"  ]];
    }
    else
    {
        if (noti.object)
            self.title = [NSString stringWithFormat:@"%@",noti.object];
    }
}

- (void)dealloc
{
    //移除监听者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CHANGENAMENOTIFICE" object:nil];
}

//方法传值
- (void)push:(id)sender
{
    SecondViewController *second = [[SecondViewController alloc]init];
    second.labelText = @"方法传值";
    second.changeNameDelegate = self;
    [self.navigationController pushViewController:second animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
