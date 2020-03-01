//
//  SLViewController.m
//  SLCoreNetManage
//
//  Created by 18337125565@163.com on 03/13/2019.
//  Copyright (c) 2019 18337125565@163.com. All rights reserved.
//

#import "SLViewController.h"
#import "SLBaseNetworkManager.h"
@interface SLViewController ()

@end

@implementation SLViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    SLBaseNetworkManager *manager =[SLBaseNetworkManager managerWithOwner:self];
    
    [(SLBaseNetworkResponse *)manager.response setSuccessCallback:^(id  _Nonnull responseObj) {
        NSLog(@"请求成功");
    }];
    [(SLBaseNetworkResponse *)manager.response setFailureCallback:^(NSError * _Nonnull error) {
        NSLog(@"请求失败%@",error);
    }];
    [manager GETService:@"https://openapi.bitmart.com" pathString:@"/v2/ping" param:@{}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
