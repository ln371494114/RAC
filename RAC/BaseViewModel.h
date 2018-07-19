//
//  BaseViewModel.h
//  RAC
//
//  Created by 李楠 on 2018/7/16.
//  Copyright © 2018年 李楠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/RACReturnSignal.h>

@interface BaseViewModel : NSObject

@property (nonatomic, strong) RACSubject *subject;

- (void)requestWithUrl:(NSString *)url dic:(NSDictionary *)dic ways:(NSString *)ways;

@end
