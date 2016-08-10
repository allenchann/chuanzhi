//
//  BlockButton.h
//  TYAttributedLabelDemo
//
//  Created by allen_Chan on 16/8/5.
//  Copyright © 2016年 tanyang. All rights reserved.
//

#import <UIKit/UIKit.h>

//定义一个结构体块
typedef void(^block)(NSDictionary *dict);

@interface BlockButton : UIButton


{
    //全局块变量,用来传值
    block _aBlock;
}

//为调用该块的对象提供一个定义块的接口
- (void)tranBlock:(block)block;


@end
