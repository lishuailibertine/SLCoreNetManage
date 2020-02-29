//
//  SLParamManager.h
//  AFNetworking
//
//  Created by libertine on 2020/2/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SLParamManager;
//为什么不在网络管理中集中处理: 某些业务场景 参数可能需要处理(比如加密方式的改变；参数可能会有path等等)
@protocol SLParamManager <NSObject>
//⚠️子类实现:  不同的场景处理的参数有所不同，需要加工
- (void)handleRequestWithService:(NSString *)serviceString path:(NSString *)path param:(NSDictionary *)param handleFinished:(void(^)(BOOL success,NSError *error,SLParamManager *paramManager))handleFinished;
@end
@interface SLParamManager :NSObject <SLParamManager>
@property (nonatomic, copy) NSString *requestUrl;
@property (nonatomic, strong) id requestParam;
@end
NS_ASSUME_NONNULL_END
