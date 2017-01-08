//
//  UIImageView+Fetchable.m
//  ViewTumbl
//
//  Created by Jan Świeżyński on 06.01.2017.
//  Copyright © 2017 jansoft. All rights reserved.
//

#import "UIImageView+Fetchable.h"
#import "UIFetchableCache.h"
#import <objc/runtime.h>

@implementation UIImageView (Fetchable)

- (id)associatedObject
{
    return objc_getAssociatedObject(self, @selector(associatedObject));
}

- (void)setAssociatedObject:(id)associatedObject
{
    objc_setAssociatedObject(self,
                             @selector(associatedObject),
                             associatedObject,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)loadURL:(NSURL *)url completion:(void (^)())block
{
    [self.associatedObject cancel];
    
    NSData* cachedData = [UIFetchableCache dataWithContentsOfURL:url];
    
    if (cachedData)
    {
        self.image = [UIImage imageWithData: cachedData];
        if (block) block();
        return;
    }
    
    self.image = [UIImage new];
    self.backgroundColor = [UIColor clearColor];
    
    NSURLSessionTask* task = [[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        NSData* data = [NSData dataWithContentsOfURL:location];
        
        if (!data)
            return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.backgroundColor = [UIColor clearColor];
            self.image = [UIImage imageWithData:data];
            self.alpha = 0.0;
            
            [UIView animateWithDuration:0.5 animations:^{
                self.alpha = 1.0f;
            }];
            
            if (block) block();
            
            [UIFetchableCache cacheData:data fromURL:url];
        });
    }];
    
    self.associatedObject = task;
    [task resume];
}

@end
