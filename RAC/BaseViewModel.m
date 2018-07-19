//
//  BaseViewModel.m
//  RAC
//
//  Created by 李楠 on 2018/7/16.
//  Copyright © 2018年 李楠. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel

- (void)requestWithUrl:(NSString *)url dic:(NSDictionary *)dic ways:(NSString *)ways {
    //使用NetRequest类请求数据,请求数据成功时
    [self.subject sendNext:@"lxn"];
    
    //使用NetRequest类请求数据失败时
    [self.subject sendError:nil];
}

- (RACSubject *)subject {
    if (!_subject) {
        _subject = [RACSubject subject];
    }
    return _subject;
}

@end
