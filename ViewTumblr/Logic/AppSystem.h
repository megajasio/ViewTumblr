//
//  AppSystem.h
//  ViewTumbl
//
//  Singletion class handling parsing & loaded data management
//
//  Created by Jan Świeżyński on 03.01.2017.
//  Copyright © 2017 jansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML+HTTP.h"

@interface AppSystem : NSObject

//loaded posts
@property (strong) NSMutableArray *postsArray;
//total count of posts available
@property (nonatomic) NSInteger postCount;
//name of Tumblr account for which we load posts
@property (strong) NSString *user;

+(AppSystem *) inst;

//parse TumblrXML & returns number of posts downloaded
-(int) parseTumblr:(TBXMLElement *)root;

@end
