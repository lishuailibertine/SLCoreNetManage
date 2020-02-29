//
//  NSObject+WeakObject.m
//  AFNetworking
//
//  Created by libertine on 2020/2/29.
//

#import "NSObject+WeakObject.h"

@implementation NSObject (WeakObject)
static char associatedObjectNamesKey;
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
