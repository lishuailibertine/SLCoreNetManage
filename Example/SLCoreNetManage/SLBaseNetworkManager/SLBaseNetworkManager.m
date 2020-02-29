//
//  SLBaseNetworkManager.m
//  SLCoreNetManage_Example
//
//  Created by libertine on 2020/2/29.
//  Copyright © 2020 18337125565@163.com. All rights reserved.
//

#import "SLBaseNetworkManager.h"
@interface SLBaseParamManager : SLParamManager
@end

@implementation SLBaseNetworkManager
+ (instancetype)managerWithOwner:(id)owner{
    SLBaseNetworkManager *networkManager = [super managerWithOwner:owner];
    networkManager.response = [[SLBaseNetworkResponse alloc] init];
    return networkManager;
}
@end
@implementation SLBaseParamManager
//处理请求参数
- (void)handleRequestWithService:(NSString *)serviceString path:(NSString *)path param:(NSDictionary *)param handleFinished:(void (^)(BOOL, NSError * _Nonnull, SLParamManager * _Nonnull))handleFinished{
    
    
}
@end

@implementation SLBaseNetworkResponse
//处理响应结果
- (void)handleResponse:(NSURLSessionDataTask *)aOperation responseObject:(id)aResponseObject error:(NSError *)error{
    
    
}
@end
