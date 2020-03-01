//
//  SLBaseNetworkManager.h
//  SLCoreNetManage_Example
//
//  Created by libertine on 2020/2/29.
//  Copyright © 2020 18337125565@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLCoreNetManage.h"

NS_ASSUME_NONNULL_BEGIN
@interface SLBaseNetworkResponse : NSObject <SLNetworkResponse>
//成功响应结果
@property (nonatomic, strong) void(^successCallback)(id responseObj);
//失败响应结果
@property (nonatomic, strong) void(^failureCallback)(NSError *error);
@end

@interface SLBaseNetworkManager : SLNetworkManager
//  SLBaseNetworkResponse *response;

// - (void)RUNRequest:(SLNetworkRequestType)requestType service:(NSString *)serviceString pathString:(NSString * __nullable)pathString param:(NSDictionary * __nullable)aParam;

// - (void)GETService:(NSString *)serviceString pathString:(NSString * __nullable)pathString param:(NSDictionary * __nullable)aParam;

// - (void)POSTService:(NSString *)serviceString pathString:(NSString * __nullable)pathString param:(NSDictionary * __nullable)aParam;
@end
NS_ASSUME_NONNULL_END
