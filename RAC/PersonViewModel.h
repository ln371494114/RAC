//
//  PersonViewModel.h
//  RAC
//
//  Created by 李楠 on 2018/7/16.
//  Copyright © 2018年 李楠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import "BaseViewModel.h"

@interface PersonViewModel : BaseViewModel

@property (nonatomic, strong) Person *person;

@end
