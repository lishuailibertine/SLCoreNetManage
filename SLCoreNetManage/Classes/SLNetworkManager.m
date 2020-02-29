//
//  SLNetworkManager.m
//  AFNetworking
//
//  Created by libertine on 2020/2/29.
//

#import "SLNetworkManager.h"
#import "SLParamManager.h"

@interface SLNetworkManager()
@property (nonatomic, strong) NSString *hostClassName;
@property (nonatomic, strong) dispatch_group_t requestGroup;
@end

@interface SLWeakObjectDeath :NSObject
typedef void(^SLWeakObjectDeathBlock)(SLWeakObjectDeath *sender);
@property (nonatomic, weak) id owner;
@property (nonatomic, copy) SLWeakObjectDeathBlock aBlock;
- (void)setBlock:(SLWeakObjectDeathBlock)block;
@end

@implementation SLNetworkManager
- (void)dealloc {
    NSLog(@"%@ call %@ --> %@",[self class],NSStringFromSelector(_cmd),self.hostClassName);
}
- (dispatch_group_t)requestGroup{
    if (!_requestGroup) {
        _requestGroup = dispatch_group_create();
    }
    return _requestGroup;
}
- (SLParamManager *)paramManager{
    if (!_paramManager) {
        _paramManager = [[SLParamManager alloc] init];
    }
    return _paramManager;
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
- (void)RUNRequest:(SLNetworkRequestType)requestType service:(NSString *)serviceString pathString:(NSString * __nullable)pathString param:(NSDictionary * __nullable)aParam{
    if (requestType == SLNetworkRequestType_Get) {
        [self GETService:serviceString pathString:pathString param:aParam];
    }
    if (requestType == SLNetworkRequestType_Post) {
        [self POSTService:serviceString pathString:pathString param:aParam];
    }
}
- (void)GETService:(NSString *)serviceString pathString:(NSString * __nullable)pathString param:(NSDictionary * __nullable)aParam {
    dispatch_block_t startRequest = ^(){
        __weak typeof(self)weakSelf = self;
        [self GET:self.paramManager.requestUrl parameters:self.paramManager.requestParam progress:^(NSProgress * _Nonnull downloadProgress) {
            //处理进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //处理成功
            [weakSelf successWithOperation:task responseObject:responseObject];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //处理失败
            [weakSelf failureWithOperation:task error:error];
        }];
    };
    if ([self.paramManager respondsToSelector:@selector(handleRequestWithService:path:param:handleFinished:)]) {
        dispatch_group_async(self.requestGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            //这里用信号量处理的原因: handleRequest 有可能会执行网络请求，需要在请求返回以后再发起当前请求
            [self.paramManager handleRequestWithService:serviceString path:pathString param:aParam handleFinished:^(BOOL success, NSError * _Nonnull error, SLParamManager * _Nonnull paramManager) {
                startRequest();
               dispatch_semaphore_signal(semaphore);
            }];
            //设置超时
            dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 20 * NSEC_PER_SEC));
        });
    }
}

- (void)POSTService:(NSString *)serviceString pathString:(NSString * __nullable)pathString param:(NSDictionary * __nullable)aParam{
    dispatch_block_t startRequest = ^(){
        __weak typeof(self)weakSelf = self;
        [self GET:self.paramManager.requestUrl parameters:self.paramManager.requestParam progress:^(NSProgress * _Nonnull downloadProgress) {
            //处理进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //处理成功
            [weakSelf successWithOperation:task responseObject:responseObject];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //处理失败
            [weakSelf failureWithOperation:task error:error];
        }];
    };
    if ([self.paramManager respondsToSelector:@selector(handleRequestWithService:path:param:handleFinished:)]) {
        dispatch_group_async(self.requestGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            //这里用信号量处理的原因: handleRequest 有可能会执行网络请求，需要在请求返回以后再发起当前请求
            [self.paramManager handleRequestWithService:serviceString path:pathString param:aParam handleFinished:^(BOOL success, NSError * _Nonnull error, SLParamManager * _Nonnull paramManager) {
                startRequest();
                dispatch_semaphore_signal(semaphore);
            }];
            //设置超时
            dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 20 * NSEC_PER_SEC));
        });
    }
}
- (void)successWithOperation:(NSURLSessionDataTask *)aOperation responseObject:(id)aResponseObject{
    if ([self.response respondsToSelector:@selector(handleRequestWithService:path:param:handleFinished:)]) {
        [self.response handleResponse:aOperation responseObject:aResponseObject error:nil];
    }
}
- (void)failureWithOperation:(NSURLSessionDataTask *)aOperation error:(NSError *)error{
    
   if ([self.response respondsToSelector:@selector(handleRequestWithService:path:param:handleFinished:)]) {
        [self.response handleResponse:aOperation responseObject:nil error:error];
    }
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

@end

