//
//  ViewController.m
//  RAC
//
//  Created by 李楠 on 2018/7/12.
//  Copyright © 2018年 李楠. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/RACReturnSignal.h>
#import <Masonry/Masonry.h>
#import "PersonViewModel.h"

@interface ViewController () <UITextFieldDelegate>
@property (nonatomic, strong) PersonViewModel *viewModel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self map];
}

#pragma mark - filterMap

/*
 FlatternMap和Map的区别
 
 1.FlatternMap中的Block返回信号。
 2.Map中的Block返回对象。
 3.开发中，如果信号发出的值不是信号，映射一般使用Map
 4.开发中，如果信号发出的值是信号，映射一般使用FlatternMap。
 */


#pragma mark - map

- (void)map {
//    RACSubject *subject = [RACSubject subject];
//    RACSignal *signal = [subject map:^id(id value) {
//        return [NSString stringWithFormat:@"map: %@",value];
//    }];
//    [signal subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
//    [subject sendNext:@"哈哈哈"];
    
    __block UITextField *acount = [[UITextField alloc] init];
    acount.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:acount];
    [acount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-30);
        make.height.equalTo(@44);
        make.left.equalTo(self.view).offset(24);
        make.right.equalTo(self.view).offset(-24);
    }];
    
    /** map的作用就是转换信号的值, 对信号的值做相应的处理 */
    RACSignal *signal = [acount.rac_textSignal map:^id(NSString *value) {
        if (value.length > 11) {
            return [value substringToIndex:11];
        } else {
            return value;
        }
    }];
    
    [signal subscribeNext:^(id x) {
        acount.text = x;
    }];
}


#pragma mark - command
/**
 rac - command
 */
- (void)test3Command {
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"input = %@",input);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"执行command产生的数据"];
            return nil;
        }];
    }];
    
    //直接获取信号中的数据
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    [command execute:@"嘻嘻嘻"];
}

- (void)test2Command {
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"input = %@",input);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"执行command产生的数据"];
            return nil;
        }];
    }];
    
    //command.executionSignals 得到的是一个信号 command内部的信号
    [command.executionSignals subscribeNext:^(RACSignal *x) {
        [x subscribeNext:^(id x) {
            NSLog(@"%@", x);
        }];
    }];
    
    [command execute:@"输入的参数"];
}

- (void)test1Command {
    //创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        //执行命令传进来的参数
        NSLog(@"input = %@",input);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"执行命令产生的数据"];
            return nil;
        }];
    }];
    
    /**
     如何拿到执行命令中产生的数据?
     订阅命令内的型号
     方式一: 直接订阅执行命令返回的信号
     **/
    
    //执行命令
    RACSignal *signal = [command execute:@"咿呀咿呀哟"];
    [signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
}


- (void)netRequest {
    self.viewModel = [PersonViewModel new];
    [self.viewModel.subject subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];

    [self.viewModel.subject subscribeError:^(NSError *error) {
        NSLog(@"%@", error);

    }];
    [self.viewModel requestWithUrl:nil dic:nil ways:nil];
}


#pragma mark - filter

/**
 rac_filter
 */
- (void)filter {
    UITextField *acount = [[UITextField alloc] init];
    acount.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:acount];
    [acount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-30);
        make.height.equalTo(@44);
        make.left.equalTo(self.view).offset(24);
        make.right.equalTo(self.view).offset(-24);
    }];
    [[acount.rac_textSignal filter:^BOOL(NSString *value) {
        return value.length > 11;
    }] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

#pragma mark - combine

/**
  rac_combine
 */
- (void)combineLatest {
    UITextField *acount = [[UITextField alloc] init];
    acount.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:acount];
    [acount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-30);
        make.height.equalTo(@44);
        make.left.equalTo(self.view).offset(24);
        make.right.equalTo(self.view).offset(-24);
    }];
    
    UITextField *password = [[UITextField alloc] init];
    password.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:password];
    [password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(acount);
        make.top.equalTo(acount.mas_bottom).offset(12);
    }];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"button" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(password.mas_bottom).offset(36);
        make.size.mas_equalTo(CGSizeMake(100, 44));
    }];
    
    RACSignal *combinSignal = [RACSignal combineLatest:@[acount.rac_textSignal, password.rac_textSignal] reduce:^id(NSString *loginID, NSString *pwd){
        NSLog(@"%@ %@", loginID, pwd);
        return @(loginID.length >= 6 && pwd.length >= 6);
    }];
    
    RAC(btn, enabled) = combinSignal;
}

/**
 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
 
 2.订阅信号,才会激活信号. - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
 
 3.发送信号 - (void)sendNext:(id)value
 */
- (void)racSignalDetail {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"xxx"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACDisposable *disposable = [signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    [disposable dispose];
}
    
#pragma mark -- retry
/**
 重复发送请求
 */
- (void)retry {
    __block int i = 0;
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (i == 10) {
            [subscriber sendNext:@1];
        } else {
            NSLog(@"接到错误");
            [subscriber sendError:nil];
        }
        i ++;
        return nil;
    }] retry] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }] ;
}

#pragma mark -- delay

/**
 延迟发送请求
 */
- (void)delay {
    //延迟三秒再发送消息
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"100"];
        return nil;
    }] delay:3] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

#pragma mark -- timer

/**
 定时器
 */
- (void)timer {
    __block int count = 0;
    __block RACDisposable *disposable = [[RACSignal interval:3 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        count ++;
        if (count == 4) {
            [disposable dispose];
        }
        NSLog(@"%@",x);
    }];
    
}
#pragma mark -- more request
//处理当界面有多次请求时，需要都获取到数据时，才能展示界面
- (void)moreRequest {
    RACSignal *requestFirst = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"请求1"];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
    RACSignal *requestSecond = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"请求2"];
        });
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];

    //当每个信号都过来时 执行@seleter
    [self rac_liftSelector:@selector(updateData:source:) withSignalsFromArray:@[requestFirst, requestSecond]];
}
    
- (void)updateData:(id)data source:(id)source {
    NSLog(@" data: %@  source: %@", data, source);
}

#pragma mark -- 代理
- (void)rac_delegate {
    //仅仅为语法
    [[self rac_signalForSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}
    
#pragma mark --  通知中心
- (void)rac_notification {
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

#pragma mark --  手势
/**
 rac_gesture
 */
- (void)rac_gesture {
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] init];
    [[gesture rac_gestureSignal] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    [self.view addGestureRecognizer:gesture];
}
 
#pragma mark --  按钮
/**
 rac_btn
 */
- (void)rac_btn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(100, 100, 100, 40);
    [btn setTitle:@"button" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        //x 为btn
        NSLog(@"%@",x);
    }];
    
}

#pragma mark --  输入框
/**
 rac_textfield
 */
- (void)rac_textfield {
    UITextField *textFiled = [[UITextField alloc] init];
    textFiled.backgroundColor = [UIColor cyanColor];
    textFiled.delegate = self;
    [self.view addSubview:textFiled];
    [textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(199, 44));
        make.center.equalTo(self.view);
    }];
    
    /*****************监听textField的属性变化情况*******************/
    [textFiled.rac_textSignal subscribeNext:^(id x) {
        //x为 text
        NSLog(@"%@", x);
    }];
}
    
- (void)signalBind {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"wxx"];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    RACSignal *bindSubject = [signal bind:^RACStreamBindBlock{
        return ^RACSignal *(id value, BOOL *stop) {
            return [RACReturnSignal return:[NSString stringWithFormat:@"我现在就想: %@",value]];
        };
    }];
    [bindSubject subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

    
/**
 RACSubject
 */
- (void)subject {
    //创建信号
    RACSubject *subject = [RACSubject subject];
    //订阅信号
    [subject subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    //发送信号
    [subject sendNext:@"老纸感冒了"];
}

/**
 RACSignal
 */
- (void)testRACSignal {
    //创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //发送信息
        [subscriber sendNext:@"hello wxx"];
        [subscriber sendCompleted];
        //销毁信号
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"信号被销毁");
        }];
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
