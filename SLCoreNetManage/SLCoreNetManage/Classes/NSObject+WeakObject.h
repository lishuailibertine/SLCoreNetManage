//
//  NSObject+WeakObject.h
//  AFNetworking
//
//  Created by libertine on 2020/2/29.
//
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@interface NSObject (WeakObject)
- (void)objc_setAssociatedObject:(NSString *)propertyName value:(id)value policy:(objc_AssociationPolicy)policy;
@end
