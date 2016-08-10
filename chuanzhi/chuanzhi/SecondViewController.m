//
//  SecondViewController.m
//  chuanzhi
//
//  Created by allen_Chan on 16/8/10.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "SecondViewController.h"
#import "BlockButton.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.title = @"second";
    self.view.backgroundColor = [UIColor whiteColor];
    //将传过来的值显示在Label上
    UILabel *_aLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    _aLabel.text = _labelText;
    [self.view addSubview:_aLabel];
    //开始发送通知
    UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [aBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [aBtn setTitle:@"发送通知回传参数" forState:UIControlStateNormal];
    aBtn.frame = CGRectMake(100, 150, 200, 100);
    [aBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aBtn];
    //代理传值
    UIButton *dBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dBtn setTitle:@"代理传值" forState:UIControlStateNormal];
    dBtn.frame = CGRectMake(100, 200, 200, 50);
    [dBtn addTarget:self action:@selector(popD:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dBtn];
    
    //实例化button
    BlockButton *block = [[BlockButton alloc]initWithFrame:CGRectMake(100, 250, 100, 100)];
//    block.backgroundColor = [UIColor blueColor];
    [block setTitle:@"块传值" forState:UIControlStateNormal];
    [block setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //对button中的块进行定义
    [block tranBlock:^(NSDictionary *dict) {
        _aLabel.text = dict[@"name"];
    }];
    [self.view addSubview:block];
    
}

- (void)popD:(UIButton *)sender
{
    // 判断代理对象是否实现这个方法，没有实现会导致崩溃﻿
    if ([self.changeNameDelegate respondsToSelector:@selector(changeTitle:)])
    {
    //由代理人执行方法,接受name值
    [self.changeNameDelegate changeTitle:@"haha"];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)pop:(UIButton *)sender
{
    //第一种,生成一个通知对象,并配置好想要传递的对象
    NSNotification *noti = [[NSNotification alloc]initWithName:@"CHANGENAMENOTIFICE" object:@"haha" userInfo:@{@"name":@"haha"}];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
    
    //第二种,直接通过通知名称,传递一个想要传递的对象
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGENAMENOTIFICE" object:@"haha"];
    
    //第三种,直接通过通知名称,传递一个想要传递的对象以及传递的userInfo
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGENAMENOTIFICE" object:@"haha" userInfo:@{@"name":@"haha"}];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
