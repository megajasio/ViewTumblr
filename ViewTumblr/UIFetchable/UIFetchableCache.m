//
//  UIFetchableCache.m
//  ViewTumbl
//
//  Created by Jan Świeżyński on 06.01.2017.
//  Copyright © 2017 jansoft. All rights reserved.
//

#import "UIFetchableCache.h"

@implementation UIFetchableCache

+ (NSString*)pathFromURL:(NSURL *)url
{
    NSArray* pathList = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* cachePath = [pathList objectAtIndex:0];
    
    NSString* cacheFile = [[url absoluteString] stringByReplacingOccurrencesOfString:@"." withString:@""];
    cacheFile = [cacheFile stringByReplacingOccurrencesOfString:@"/" withString:@""];
    cacheFile = [cacheFile stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    return [NSString stringWithFormat:@"%@/UIFetchableCache/%@", cachePath, cacheFile];
}

+ (NSData*)dataWithContentsOfURL:(NSURL *)url
{
    NSString* path = [self pathFromURL:url];
    
    return [NSData dataWithContentsOfFile:path];
}

+ (NSDate*)lastModificationDateOfURL:(NSURL *)url
{
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[self pathFromURL:url] error:nil];
    return [attributes fileModificationDate];
}

+ (BOOL)cacheData:(NSData *)data fromURL:(NSURL *)url
{
    if (data == nil || url == nil)
        return NO;
    
    [[NSFileManager defaultManager] createDirectoryAtPath:[[self pathFromURL: url] stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
    [data writeToFile:[self pathFromURL:url] atomically:YES];
    
    return YES;
}

+ (void)invalidateCache
{
    NSString* directory = [self pathFromURL: [NSURL URLWithString:@""]];
    NSArray* cachedFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: directory error:nil];
    
    for (NSString* path in cachedFiles)
    {
        NSString* filePath = [NSString stringWithFormat:@"%@%@", directory, path];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

+ (void)invalidateCacheOlderThanDate:(NSDate *)date
{
    NSString* directory = [self pathFromURL: [NSURL URLWithString:@""]];
    NSArray* cachedFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: directory error:nil];
    
    for (NSString* path in cachedFiles)
    {
        NSString* filePath = [NSString stringWithFormat:@"%@%@", directory, path];
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath: filePath error:nil];
        NSDate* fileDate = [attributes fileModificationDate];
        
        if ([fileDate timeIntervalSinceDate:date] < 0)
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

@end
