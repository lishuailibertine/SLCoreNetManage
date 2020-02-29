//
//  SLNetworkManager.h
//  AFNetworking
//
//  Created by libertine on 2020/2/29.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "SLNetworkResponse.h"
#import "SLParamManager.h"
#import "SLNetworkConfigManager.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,SLNetworkRequestType) {
    SLNetworkRequestType_Get,
    SLNetworkRequestType_Post,
};
typedef void (^ __nullable SLSuccessCompletionBlock)(id <SLNetworkResponse>response);

typedef void (^ __nullable SLFailCompletionBlock)(id <SLNetworkResponse>response,NSError * __nullable error);

typedef void (^ __nullable SLCompletionBlock)(SLSuccessCompletionBlock, SLFailCompletionBlock);

@interface SLNetworkManager : AFHTTPSessionManager

@property (nonatomic, strong) id <SLParamManager>paramManager;

@property (nonatomic, strong) id <SLNetworkResponse>response;

+ (instancetype)managerWithOwner:(id)owner;

+ (instancetype)managerWithOwner:(id)owner configManager:(id<SLNetworkConfigManager>)configManager;

- (void)runRequest:(SLNetworkRequestType)requestType service:(NSString *)serviceString pathString:(NSString * __nullable)pathString param:(NSDictionary * __nullable)aParam callback:(SLCompletionBlock)callback;

- (void)GETService:(NSString *)serviceString pathString:(NSString * __nullable)pathString param:(NSDictionary * __nullable)aParam callback:(SLCompletionBlock)callback;

- (void)POSTService:(NSString *)serviceString pathString:(NSString * __nullable)pathString param:(NSDictionary * __nullable)aParam callback:(SLCompletionBlock)callback;

@end

NS_ASSUME_NONNULL_END
