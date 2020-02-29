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

- (void)viewDidLoad
{
    [super viewDidLoad];
    SLBaseNetworkManager *manager =[SLBaseNetworkManager managerWithOwner:self];
    
    [(SLBaseNetworkResponse *)manager.response setSuccessCallback:^(id  _Nonnull responseObj) {
        
    }];
    [(SLBaseNetworkResponse *)manager.response setFailureCallback:^(NSError * _Nonnull error) {
        
    }];
    [manager GETService:@"" pathString:@"" param:@{}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
