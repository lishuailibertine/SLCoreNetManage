//
//  SLNetworkManager.m
//  AFNetworking
//
//  Created by libertine on 2020/2/29.
//

#import "SLNetworkManager.h"
#import <objc/runtime.h>

@interface SLNetworkManager()
@property (nonatomic, strong) NSString *hostClassName;
@end

@interface SLWeakObjectDeath :NSObject{}
typedef void(^SLWeakObjectDeathBlock)(SLWeakObjectDeath *sender);
@property (nonatomic, weak) id owner;
@property (nonatomic, copy) SLWeakObjectDeathBlock aBlock;
- (void)setBlock:(SLWeakObjectDeathBlock)block;
@end


@implementation SLNetworkManager
- (void)dealloc {
    NSLog(@"%@ call %@ --> %@",[self class],NSStringFromSelector(_cmd),self.hostClassName);
}
- (void)defaultNetworkConfigManager{
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                       @"text/html",
                                                                                       @"text/json",
                                                                                       @"text/plain",
                                                                                       @"text/javascript",
                                                                                       @"text/xml",
                                                                                       @"image/*"]];
    [self.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    self.securityPolicy =[self.class defaultSecurityPolicy];
    self.operationQueue.maxConcurrentOperationCount = 3;
}
+ (instancetype)managerWithOwner:(id)owner{
    SLNetworkManager *networkManager = [super manager];
    networkManager.hostClassName = NSStringFromClass([owner class]);
    [networkManager defaultNetworkConfigManager];
    [networkManager configWeakObjectDeathWithOwer:owner];
    return networkManager;
}
+ (instancetype)managerWithOwner:(id)owner configManager:(id<SLNetworkConfigManager>)configManager{
    SLNetworkManager *networkManager = [super manager];
    networkManager.hostClassName = NSStringFromClass([owner class]);
    if ([configManager conformsToProtocol:@protocol(SLNetworkConfigManager)]) {
        if ([configManager respondsToSelector:@selector(defaultNetworkConfigManager:)]) {
            [configManager defaultNetworkConfigManager:networkManager];
        }
    }
    [networkManager configWeakObjectDeathWithOwer:owner];
    return networkManager;
}
- (void)runRequest:(SLNetworkRequestType)requestType service:(NSString *)serviceString pathString:(NSString * __nullable)pathString param:(NSDictionary * __nullable)aParam callback:(SLCompletionBlock)callback{
    if (requestType == SLNetworkRequestType_Get) {
        [self GETService:serviceString pathString:pathString param:aParam callback:callback];
    }
    if (requestType == SLNetworkRequestType_Post) {
        [self POSTService:serviceString pathString:pathString param:aParam callback:callback];
    }
}
- (void)GETService:(NSString *)serviceString pathString:(NSString * __nullable)pathString param:(NSDictionary * __nullable)aParam callback:(SLCompletionBlock)callback{
    
    [self GET:@"" parameters:@"" progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)POSTService:(NSString *)serviceString pathString:(NSString * __nullable)pathString param:(NSDictionary * __nullable)aParam callback:(SLCompletionBlock)callback{
    
    [self POST:@"" parameters:@"" progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
+ (AFSecurityPolicy *)defaultSecurityPolicy {
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    //是否允许无效证书（也就是自建的证书），默认为NO
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    return securityPolicy;
}
#pragma mark --
- (void)configWeakObjectDeathWithOwer:(id)owner{
    __weak typeof(self) weakSelf = self;
    SLWeakObjectDeath *wo = [[SLWeakObjectDeath alloc] init];
    [wo setOwner:owner];
    [wo setBlock:^(SLWeakObjectDeath *sender) {
        [weakSelf invalidateSessionCancelingTasks:YES];
    }];
}
@end

@implementation SLWeakObjectDeath
static char associatedObjectNamesKey;

- (void)setBlock:(SLWeakObjectDeathBlock)block{
    self.aBlock = block;
}

- (void)dealloc{
    if (self.aBlock) {
        self.aBlock(self);
    }
    self.aBlock = nil;
}

- (void)setOwner:(id)owner{
    _owner = owner;
    [owner objc_setAssociatedObject:[NSString stringWithFormat:@"observerOwner_%p",self] value:self policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}
- (NSMutableArray *)associatedObjectNames{
    NSMutableArray *array = objc_getAssociatedObject(self, &associatedObjectNamesKey);
    if (!array) {
        array = [NSMutableArray array];
        [self setAssociatedObjectNames:array];
    }
    return array;
}
- (void)setAssociatedObjectNames:(NSMutableArray *)associatedObjectNames{
    objc_setAssociatedObject(self, &associatedObjectNamesKey, associatedObjectNames,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)objc_setAssociatedObject:(NSString *)propertyName value:(id)value policy:(objc_AssociationPolicy)policy{
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_10_0
    objc_setAssociatedObject(self, objc_unretainedPointer(propertyName), value, policy);
#else
    objc_setAssociatedObject(self, (__bridge void *)(propertyName), value, policy);
#endif
    [self.associatedObjectNames addObject:propertyName];
}

- (id)objc_getAssociatedObject:(NSString *)propertyName{
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_10_0
    return objc_getAssociatedObject(self, objc_unretainedPointer(propertyName));
#else
    return objc_getAssociatedObject(self, (__bridge void *)(propertyName));
#endif
    
}
- (void)objc_removeAssociatedObjects{
    [self.associatedObjectNames removeAllObjects];
    objc_removeAssociatedObjects(self);
}
@end

