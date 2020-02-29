#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "SLCoreNetInterface.h"
#import "SLCoreNetRequest.h"
#import "SLCoreNetResponse.h"

FOUNDATION_EXPORT double SLCoreNetManageVersionNumber;
FOUNDATION_EXPORT const unsigned char SLCoreNetManageVersionString[];

