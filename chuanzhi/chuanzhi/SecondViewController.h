//
//  SecondViewController.h
//  chuanzhi
//
//  Created by allen_Chan on 16/8/10.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol changeName <NSObject>
@required
-(void)changeTitle:(NSString *)name;
@optional
-(void)changeBackgroundColor:(UIColor *)color;
@end

@interface SecondViewController : UIViewController

//代理人
@property(nonatomic,assign)id<changeName> changeNameDelegate;
//要传的属性
@property(nonatomic,strong)NSString *labelText;

@end
