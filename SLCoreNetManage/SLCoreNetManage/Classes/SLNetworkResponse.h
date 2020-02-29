//
//  SLNetworkResponse.h
//  AFNetworking
//
//  Created by libertine on 2020/2/29.
//

#import <Foundation/Foundation.h>
//为什么把响应的处理要分开: 针对不用的网络响应需求
@protocol SLNetworkResponse <NSObject>
- (void)handleResponse:(NSURLSessionDataTask *)aOperation responseObject:(id)aResponseObject error:(NSError *)error;
@end
