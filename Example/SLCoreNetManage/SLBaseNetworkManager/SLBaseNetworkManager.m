//
//  SLBaseNetworkManager.m
//  SLCoreNetManage_Example
//
//  Created by libertine on 2020/2/29.
//  Copyright © 2020 18337125565@163.com. All rights reserved.
//

#import "SLBaseNetworkManager.h"
@interface SLBaseConfigManager : NSObject<SLNetworkConfigManager>
@end
@interface SLBaseParamManager : SLParamManager
@end

@implementation SLBaseNetworkManager
+ (instancetype)managerWithOwner:(id)owner{
    SLBaseConfigManager *configManage =[[SLBaseConfigManager alloc] init];
    SLBaseNetworkManager *networkManager = [super managerWithOwner:owner configManager:configManage];
    networkManager.response = [[SLBaseNetworkResponse alloc] init];
    networkManager.paramManager = [[SLBaseParamManager alloc] init];
    return networkManager;
}
@end
@implementation SLBaseParamManager
//处理请求参数
- (void)handleRequestWithService:(NSString *)serviceString path:(NSString *)path param:(NSDictionary *)param handleFinished:(void (^)(BOOL, NSError * , SLParamManager * ))handleFinished{
    self.requestUrl =[NSString stringWithFormat:@"%@%@",serviceString,path];
    self.requestParam = param;
    //参数配置结束，有需要特殊处理的可以在这里修改
    handleFinished(YES,nil,self);
}
@end

@implementation SLBaseNetworkResponse
//处理响应结果
- (void)handleResponse:(NSURLSessionDataTask *)aOperation responseObject:(id)aResponseObject error:(NSError *)error{
    if (error) {
        if (self.failureCallback) {
            self.failureCallback(error);
        }else{
            NSLog(@"请设置请求成功回调");
        }
    }else{
        if (self.successCallback) {
            self.successCallback(aResponseObject);
        }else{
            NSLog(@"请设置请求失败回调");
        }
    }
}
@end

@implementation SLBaseConfigManager
- (void)defaultNetworkConfigManager:(SLNetworkManager *)networkManager{
    //修改了一下默认的配置
    networkManager.requestSerializer.timeoutInterval = 5;
}
@end
