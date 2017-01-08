//
//  Posts.h
//  ViewTumbl
//
//  Created by Jan Świeżyński on 05.01.2017.
//  Copyright © 2017 jansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML+HTTP.h"

typedef NS_ENUM(NSInteger, PostType) {
    QuotePostType,
    RegularPostType,
    PhotoPostType,
    AnswerPostType,
    VideoPostType,
    AudioPostType,
    LinkPostType
};

@protocol PostProtocol
@required
-(PostType) type;
-(id) initWithPost:(TBXMLElement *)post;
-(NSAttributedString *) attributedText;
@end

@interface Post : NSObject<PostProtocol>
{
    NSString *postDate;
}

-(id) initWithPostXML:(TBXMLElement *)post;

@end

@interface QuotePost : Post

@property (nonatomic, strong) NSString *quoteText, *quoteSource;

@end

@interface PhotoPost : Post
{
    NSString *photoCaption;
}

@property (nonatomic, strong) NSString *photoUrl;

@end

@interface RegularPost : Post

@property (nonatomic, strong) NSString *body;

@end

@interface AnswerPost : Post
{
    NSString *question, *answer;
}

@end

@interface VideoPost : Post
{
    NSString *videoCaption, *videoSource, *videoPlayer;
}

-(NSString *) videoText;

@end

@interface AudioPost : Post
{
    NSString *audioCaption, *audioPlayer;
}

-(NSString *) audioText;

@end

@interface LinkPost : Post
{
    NSString *linkText, *linkDescription;
}

@property (nonatomic, strong) NSString *linkUrl;

@end
