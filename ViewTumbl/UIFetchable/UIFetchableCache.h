//
//  UIFetchableCache.h
//  ViewTumbl
//
//  Created by Jan Świeżyński on 06.01.2017.
//  Copyright © 2017 jansoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIFetchableCache : NSObject

+ (NSString*)pathFromURL:(NSURL*)url;
+ (NSData*)dataWithContentsOfURL:(NSURL*)url;
+ (NSDate*)lastModificationDateOfURL:(NSURL*)url;

+ (BOOL)cacheData:(NSData*)data fromURL:(NSURL*)url;

+ (void)invalidateCache;
+ (void)invalidateCacheOlderThanDate:(NSDate*)date;

@end
