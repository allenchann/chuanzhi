iOS中,我所知的传值方法有以下这些.
- 方法(属性传值)
- 通知传值
- 代理传值
- block(块)

#方法(属性传值)
属性其实就是为我们生成一个全局变量,并为这个变量生成一个set方法以及get方法,所以利用属性传值,就是同个set方法,对这个变量进行传值,不过这种传值只能由前到后的传,而不能进行回调.

```
//传值方法
-(void)push:(id)sender
{
    SecondViewController *second = [[SecondViewController alloc]init];
    second.labelText = @"方法传值";
    [self.navigationController pushViewController:second animated:YES];
}
```
```
@interface SecondViewController : UIViewController
//要传的属性
@property(nonatomic,strong)NSString *labelText;

@end
```

```
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"second";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //将传过来的值显示在Label上
    UILabel *_aLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    _aLabel.text = _labelText;
    [self.view addSubview:_aLabel];
}
```

![结果](http://upload-images.jianshu.io/upload_images/1711673-f08c3ad73382ee2f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这样就完成了方法传值,很简单,相信大家也都懂,就不浪费时间了,接下来说说通知
#通知传值
- 观察者模式：多个观察者对象同时监听某一个主题对象。这个主题对象在状态发生变化时，会通知所有观察者对象，使它们能够做出相应的举措。
- NSNotificationCenter(通知中心，观察者统一监听对象，是一个单例)
  - 上面说过了,观察者模式是监听一个主题对象,所以通知中心是一个单例,主要的操作流程就是,成为观察者,然后通知中心发出通知,观察者响应,那怎么实现呢?
我们先看看怎么为通知中心添加观察者
```
-(void)addObserver:(id)observer selector:(SEL)aSelector name:(nullable NSString *)aName object:(nullable id)anObject;
```
API中提供了这个方法,首先我们需要一个观察者,并为它指定一个方法，名字和对象。接受到通知时，执行方法,下面是实际调用,添加了记得移除哦.
```
-(void)viewDidLoad {
    [super viewDidLoad]; 
    //添加一个观察者，可以为它指定一个方法，名字和对象。接受到通知时，执行方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeName:) name:@"CHANGENAMENOTIFICE" object:nil];
}
-(void)changeName:(NSNotification *)noti
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
-(void)dealloc
{
    //移除监听者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CHANGENAMENOTIFICE" object:nil];
}
```
观察者添加完毕了,那接下来怎么发送呢
```
-(void)postNotification:(NSNotification *)notification;
-(void)postNotificationName:(NSString *)aName object:(nullable id)anObject;
-(void)postNotificationName:(NSString *)aName object:(nullable id)anObject userInfo:(nullable NSDictionary *)aUserInfo;
```
API中同样提供了3种方法,下面我们新建一个发送通知的控制器
```
-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"second";
    self.view.backgroundColor = [UIColor whiteColor];
    //开始发送通知
    UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [aBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [aBtn setTitle:@"发送通知回传参数" forState:UIControlStateNormal];
    aBtn.frame = CGRectMake(100, 150, 200, 100);
    [aBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aBtn];
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
```

![回调前.png](http://upload-images.jianshu.io/upload_images/1711673-5bc1b5d0ad3d0ee6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![点击通知按钮.png](http://upload-images.jianshu.io/upload_images/1711673-a1551a908e3a7cbd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![通知回调后.png](http://upload-images.jianshu.io/upload_images/1711673-3794c7fd64c0d673.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

通知就先讲这么多,接下来讲讲代理
#代理(由三部分组成)
- 协议：用来指定代理双方可以做什么，必须做什么。
- 代理：根据指定的协议，完成委托方需要实现的功能。﻿
- 委托：根据指定的协议，指定代理去完成什么功能。
简单来说吧,代理模式,就是委托人没办法直接完成这件事,所以需要拟定一份协议,由一个代理人来帮他做这件事.就像房产中介跟房主一样.房主因为种种原因不想自己去寻找买房人,所以拟了一份协议,由中介去帮他寻找,下面说说OC中的实现.
  - protocol(协议)
```
@protocol <#protocol name#> <NSObject>
<#methods#>
@end
```
这是OC中协议的写法,但我们需要注意的是,protocol中有两种方法,一种是必须实现的方法,对应关键字@required;一种是可选的实现方法,对应关键字@optional
下面我们定义一个changeName协议,里面有一个必须实现的修改名称的方法以及一个可选的修改背景颜色的方法.
```
@protocol changeName <NSObject>
@required
-(void)changeTitle:(NSString *)name;
@optional
-(void)changeBackgroundColor:(UIColor *)color;
@end
```
协议有了,那么就需要一个委托人了,我们这里把SecondViewController作为委托人,既然是委托人,那么它就必须有一个代理人对象
```
@interface SecondViewController : UIViewController
@property(nonatomic,assign)id<changeName> changeNameDelegate;
@end
```
oc中对象后加<>,在尖括号里面填写协议名称,即表示签署了改协议.我们使ViewController成为代理人,就必须向签署协议
```
@interface ViewController ()<changeName>
@end
@implementation ViewController
-(void)changeTitle:(NSString *)name
{
    self.title = name;
}
-(void)changeBackgroundColor:(UIColor *)color
{
    self.view.backgroundColor = color;
}
```
然后使ViewController成为SecondViewController的代理人
```
-(void)push:(id)sender
{
      SecondViewController *second = [[SecondViewController alloc]init];
      second.labelText = @"传值";
      second.changeNameDelegate = self;
      [self.navigationController pushViewController:second animated:YES];
}
```
委托人有了,代理人也有了,那接下来委托人怎么让代理人做事呢.上代码
```
-(void)viewDidLoad {
    [super viewDidLoad];
      //代理传值
      UIButton *dBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      [dBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [dBtn setTitle:@"代理传值" forState:UIControlStateNormal];
      dBtn.frame = CGRectMake(100, 200, 200, 50);
      [dBtn addTarget:self action:@selector(popD:) forControlEvents:UIControlEventTouchUpInside];
      [self.view addSubview:dBtn];
   }
-(void)popD:(UIButton *)sender
{
      // 判断代理对象是否实现这个方法，没有实现会导致崩溃﻿
      if ([self.changeNameDelegate respondsToSelector:@selector(changeTitle:)])
      {
          //由代理人执行方法,接受name值
          [self.changeNameDelegate changeTitle:@"haha"];
      }
      [self.navigationController popViewControllerAnimated:YES];
}
```
切记在调用方法前,判断代理人是否实现了这个方法,否则就会crash掉

![Snip20160809_4.png](http://upload-images.jianshu.io/upload_images/1711673-551b84f610af27a4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![Snip20160809_5.png](http://upload-images.jianshu.io/upload_images/1711673-7e2e522d2a19c03a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![Snip20160809_6.png](http://upload-images.jianshu.io/upload_images/1711673-2343f3b0093b5c23.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


#block
- block
  - 写法,从XCODE提供的typedef方法中,给出了block的写法.首先是返回类型<^块的名称><传入参数>,
<pre><code>
<#returnType#>(^<#name#>)(<#arguments#>);
</code></pre>
  - 声明(我们声明了一个名为testBlock,传入两个int类型的变量,并返回一个数据类型为int的值)
```
int (^testBlock)(int a,int b);
```
  - 定义
```
testBlock = ^(int a,int b){
        return a+b;
    };
```  
  - 调用
```
int a =testBlock(1,2);
```
这是基础的应用,然而这些我都知道,我怎么传值呢?我当时也是这么想的.别急,慢慢来.
此处我们自定义一个button,我们把它的addTarget对象指向自己,然后用块传值.
.h
```
//定义一个结构体块
typedef void(^block)(NSDictionary *dict);
@interface BlockButton : UIButton
{
      //全局块变量,用来传值
      block _aBlock;
}
//为调用该块的对象提供一个定义块的接口
-(void)tranBlock:(block)block;
@end
```
.m
```
-(instancetype)initWithFrame:(CGRect)frame
{
      self = [super initWithFrame:frame];
      //为按钮添加相应方法
      [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
      return self;
}
//把实现方法传递给全局变量(_aBlock)
-(void)tranBlock:(block)block
{
      _aBlock = block;
}
//响应方法
-(void)click
{
      //调用_aBlock,传递一个key为name,值为a的字典
      _aBlock(@{@"name":@"a"});
}
```
接下来我们在需要这个button的地方,先实例化button对象,并添加到视图上
```
self.title = @"test";
//实例化button
    BlockButton *block = [[BlockButton alloc]initWithFrame:CGRectMake(100, 250, 100, 100)];
[block setTitle:@"块传值" forState:UIControlStateNormal];
    [block setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//对button中的块进行定义
    [block tranBlock:^(NSDictionary *dict) {
      _aLabel.text = dict[@"name"];
    }];
    [self.view addSubview:block];
```

![Snip20160809_7.png](http://upload-images.jianshu.io/upload_images/1711673-8c9b171d87d37b9c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![Snip20160809_8.png](http://upload-images.jianshu.io/upload_images/1711673-e25a72de3dcc9b7e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

我们可以看到,我们并没有使控制器成为button的响应者,只是持有了button中块的定义,我们在button中调用后,就会自然相应到控制器中定义的块中,是不是很方便呢?


----------------
