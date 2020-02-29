//
//  SLNetworkConfigManager.h
//  SLCoreNetManage_Example
//
//  Created by libertine on 2020/2/29.
//  Copyright © 2020 18337125565@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SLNetworkManager;

NS_ASSUME_NONNULL_BEGIN

@protocol SLNetworkConfigManager <NSObject>

@optional
- (void)defaultNetworkConfigManager:(SLNetworkManager *)networkManager;
@end

NS_ASSUME_NONNULL_END
