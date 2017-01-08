//
//  AppSystem.m
//  ViewTumbl
//
//  Created by Jan Świeżyński on 03.01.2017.
//  Copyright © 2017 jansoft. All rights reserved.
//

#import "AppSystem.h"
#import "Posts.h"

@implementation AppSystem
@synthesize postsArray, postCount, user;

+(AppSystem *) inst
{
    static AppSystem *instance = nil;
    if (!instance)
    {
        instance = [[AppSystem alloc] init];
    }
    return instance;
}

-(id) init
{
    self = [super init];
    if (self)
    {
        postsArray = [NSMutableArray new];
        postCount = 0;
        user = nil;
    }
    return self;
}

-(int) parseTumblr:(TBXMLElement *)root {
    TBXMLElement *posts = [TBXML childElementNamed:@"posts" parentElement:root];
    if (!posts)
        return 0;
    postCount = [[TBXML valueOfAttributeNamed:@"total" forElement:posts] intValue];
    if (postCount == 0)
        return 0;
    
    TBXMLElement *postXML = posts->firstChild;
    if (!postXML)
        return 0;
    
    int postsDownloaded = 0;
    
    do {
        Post *post = [[Post alloc] initWithPostXML:postXML];
        if (post)
        {
            [postsArray addObject:post];
            postsDownloaded++;
        }
    } while ((postXML = postXML->nextSibling));
    
    return postsDownloaded;
}

@end
