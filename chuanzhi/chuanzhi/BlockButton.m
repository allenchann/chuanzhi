//
//  BlockButton.m
//  TYAttributedLabelDemo
//
//  Created by allen_Chan on 16/8/5.
//  Copyright © 2016年 tanyang. All rights reserved.
//

#import "BlockButton.h"

@implementation BlockButton


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

- (void)tranBlock:(block)block
{
    _aBlock = block;
}

- (void)click
{
    _aBlock(@{@"name":@"a"});
}


//- (void)clickBlock:(NSString *)name andBlock:(void (^)(NSDictionary *))block
//{
//    block(@{@"name":name});
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
