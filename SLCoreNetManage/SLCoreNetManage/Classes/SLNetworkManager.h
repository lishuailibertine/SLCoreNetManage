//
//  SLNetworkManager.h
//  AFNetworking
//
//  Created by libertine on 2020/2/29.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "NSObject+WeakObject.h"
#import "SLNetworkConfigManager.h"
#import "SLNetworkResponse.h"

NS_ASSUME_NONNULL_BEGIN
@class  SLParamManager;
typedef NS_ENUM(NSInteger,SLNetworkRequestType) {
    SLNetworkRequestType_Get,
    SLNetworkRequestType_Post,
};
@interface SLNetworkManager : AFHTTPSessionManager
#pragma mark -必须配置的参数
/// 请求参数处理对象
@property (nonatomic, strong) SLParamManager *paramManager;
/// 处理响应的管理对象
@property (nonatomic, strong) id <SLNetworkResponse>response;

///  创建请求管理类
/// @param owner 宿主对象: 为了可以使网络请求高效的释放
+ (instancetype)managerWithOwner:(id)owner;

/// 创建请求管理类
/// @param owner 宿主对象: 为了可以使网络请求高效的释放
/// @param configManager 网络请求相关的配置，需要特殊配置的可以在这个管理对象中实现
+ (instancetype)managerWithOwner:(id)owner configManager:(id<SLNetworkConfigManager>)configManager;

/// 发起请求
/// @param requestType 请求的类型: GET POST ...
/// @param serviceString domain
/// @param pathString endpoint 请求的路径path
/// @param aParam 请求的参数
- (void)RUNRequest:(SLNetworkRequestType)requestType service:(NSString *)serviceString pathString:(NSString * __nullable)pathString param:(NSDictionary * __nullable)aParam;

/// 发起GET请求
/// @param serviceString domain
/// @param pathString endpoint 请求的路径path
/// @param aParam 请求的参数
- (void)GETService:(NSString *)serviceString pathString:(NSString * __nullable)pathString param:(NSDictionary * __nullable)aParam;

/// 发起POST请求
/// @param serviceString domain
/// @param pathString endpoint 请求的路径path
/// @param aParam 请求的参数
- (void)POSTService:(NSString *)serviceString pathString:(NSString * __nullable)pathString param:(NSDictionary * __nullable)aParam;

@end

NS_ASSUME_NONNULL_END
