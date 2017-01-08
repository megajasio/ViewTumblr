//
//  Posts.m
//  ViewTumbl
//
//  Created by Jan Świeżyński on 05.01.2017.
//  Copyright © 2017 jansoft. All rights reserved.
//

#import "Posts.h"
#import <UIKit/UIKit.h>

@implementation Post

-(id) initWithPostXML:(TBXMLElement *)post
{
    self = nil;
    
    NSString *type = [TBXML valueOfAttributeNamed:@"type" forElement:post];
    if ([type isEqualToString:@"quote"])
    {
        self = [[QuotePost alloc] initWithPost:post];
    }
    else if ([type isEqualToString:@"photo"])
    {
        self = [[PhotoPost alloc] initWithPost:post];
    }
    else if ([type isEqualToString:@"regular"])
    {
        self = [[RegularPost alloc] initWithPost:post];
    }
    else if ([type isEqualToString:@"answer"])
    {
        self = [[AnswerPost alloc] initWithPost:post];
    }
    else if ([type isEqualToString:@"video"])
    {
        self = [[VideoPost alloc] initWithPost:post];
    }
    else if ([type isEqualToString:@"audio"])
    {
        self = [[AudioPost alloc] initWithPost:post];
    }
    else if ([type isEqualToString:@"link"])
    {
        self = [[LinkPost alloc] initWithPost:post];
    }
    
    if (self)
    {
        double unixTimeStamp = [[TBXML valueOfAttributeNamed:@"unix-timestamp" forElement:post] doubleValue];
        NSTimeInterval _interval=unixTimeStamp;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setDateFormat:@"dd MMMM yyyy HH:mm"];
        postDate = [formatter stringFromDate:date];
    }
    
    return self;
}

-(PostType) type
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You have not implemented %@ in %@", NSStringFromSelector(_cmd), NSStringFromClass([self class])];
    return RegularPostType;
}

-(id) initWithPost:(TBXMLElement *)post
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You have not implemented %@ in %@", NSStringFromSelector(_cmd), NSStringFromClass([self class])];
    return nil;
}

-(NSAttributedString *) attributedText
{
    return nil;
}

+(NSString*)textToHtml:(NSString*)htmlString {
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&amp;"  withString:@"&"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&lt;"  withString:@"<"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&gt;"  withString:@">"];
    return htmlString;
}

@end

@implementation QuotePost
@synthesize quoteText, quoteSource;

-(id) initWithPost:(TBXMLElement *)post
{
    self = [super init];
    quoteText = [NSString stringWithFormat:@"\"%@\"", [Post textToHtml:[TBXML textForElement:[TBXML childElementNamed:@"quote-text" parentElement:post]]]];
    quoteSource = [Post textToHtml:[TBXML textForElement:[TBXML childElementNamed:@"quote-source" parentElement:post]]];
    return self;
}

-(NSAttributedString *) attributedText
{
    return [[NSAttributedString alloc] initWithData:[[NSString stringWithFormat:@"%@<br><br>%@<style>body{font-size:14px;}</style>", quoteText, quoteSource] dataUsingEncoding:NSUnicodeStringEncoding allowLossyConversion:YES] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
}

-(PostType) type
{
    return QuotePostType;
}

@end

@implementation PhotoPost
@synthesize photoUrl;

-(id) initWithPost:(TBXMLElement *)post
{
    self = [super init];
    TBXMLElement *xmlPhotoUrl = [TBXML childElementNamed:@"photo-url" parentElement:post];
    photoUrl = xmlPhotoUrl ? [TBXML textForElement:xmlPhotoUrl] : @"";
    TBXMLElement *xmlPhotoCaption = [TBXML childElementNamed:@"photo-caption" parentElement:post];
    photoCaption = xmlPhotoCaption ? [Post textToHtml:[TBXML textForElement:xmlPhotoCaption]] : @"";
    return self;
}

-(PostType) type
{
    return PhotoPostType;
}

-(NSAttributedString *) attributedText
{
    return photoCaption && [photoCaption length] > 0 ? [[NSAttributedString alloc] initWithData:[[photoCaption stringByAppendingString:@"<style>body{font-size:14px;}</style>"] dataUsingEncoding:NSUnicodeStringEncoding allowLossyConversion:YES] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil] : nil;
}

@end

@implementation RegularPost
@synthesize body;

-(id) initWithPost:(TBXMLElement *)post
{
    self = [super init];
    body = [Post textToHtml:[TBXML textForElement:[TBXML childElementNamed:@"regular-body" parentElement:post]]];
    return self;
}

-(PostType) type
{
    return RegularPostType;
}

-(NSAttributedString *) attributedText
{
    return [[NSAttributedString alloc] initWithData:[[body stringByAppendingString:@"<style>body{font-size:14px;}</style>"] dataUsingEncoding:NSUnicodeStringEncoding allowLossyConversion:YES] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
}

@end

@implementation AnswerPost

-(id) initWithPost:(TBXMLElement *)post
{
    self = [super init];
    question = [Post textToHtml:[TBXML textForElement:[TBXML childElementNamed:@"question" parentElement:post]]];
    answer = [Post textToHtml:[TBXML textForElement:[TBXML childElementNamed:@"answer" parentElement:post]]];
    return self;
}

-(PostType) type
{
    return AnswerPostType;
}

-(NSAttributedString *) attributedText
{
    return [[NSAttributedString alloc] initWithData:[[NSString stringWithFormat:@"Question:<br>%@<br><br>Answer:</br>%@<style>body{font-size:14px;}</style>", question, answer] dataUsingEncoding:NSUnicodeStringEncoding allowLossyConversion:YES] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
}

@end

@implementation VideoPost

-(id) initWithPost:(TBXMLElement *)post
{
    self = [super init];
    TBXMLElement *xmlVideoSource = [TBXML childElementNamed:@"video-source" parentElement:post];
    videoSource = xmlVideoSource ? [TBXML textForElement:xmlVideoSource] : @"";
    TBXMLElement *xmlVideoPlayer = [TBXML childElementNamed:@"video-player" parentElement:post];
    videoPlayer = xmlVideoPlayer ? [Post textToHtml:[TBXML textForElement:xmlVideoPlayer]] : @"";
    TBXMLElement *xmlVideoCaption = [TBXML childElementNamed:@"video-caption" parentElement:post];
    videoCaption = xmlVideoCaption ? [Post textToHtml:[TBXML textForElement:xmlVideoCaption]] : @"";
    return self;
}

-(PostType) type
{
    return VideoPostType;
}

-(NSString *) videoText
{
    return [NSString stringWithFormat:@"<html>%@</html>", videoPlayer];
}

-(NSAttributedString *) attributedText
{
    return videoCaption && [videoCaption length] > 0 ? [[NSAttributedString alloc] initWithData:[[videoCaption stringByAppendingString:@"<style>body{font-size:14px;}</style>"] dataUsingEncoding:NSUnicodeStringEncoding allowLossyConversion:YES] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil] : nil;
}

@end

@implementation AudioPost

-(id) initWithPost:(TBXMLElement *)post
{
    self = [super init];
    TBXMLElement *xmlAudioPlayer = [TBXML childElementNamed:@"audio-player" parentElement:post];
    audioPlayer = xmlAudioPlayer ? [Post textToHtml:[TBXML textForElement:xmlAudioPlayer]] : @"";
    TBXMLElement *xmlAudioCaption = [TBXML childElementNamed:@"audio-caption" parentElement:post];
    audioCaption = xmlAudioCaption ? [Post textToHtml:[TBXML textForElement:xmlAudioCaption]] : @"";
    return self;
}

-(PostType) type
{
    return AudioPostType;
}

-(NSString *) audioText
{
    return [NSString stringWithFormat:@"<html>%@</html>", audioPlayer];
}

-(NSAttributedString *) attributedText
{
    return audioCaption && [audioCaption length] > 0 ? [[NSAttributedString alloc] initWithData:[[audioCaption stringByAppendingString:@"<style>body{font-size:14px;}</style>"] dataUsingEncoding:NSUnicodeStringEncoding allowLossyConversion:YES] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil] : nil;
}

@end

@implementation LinkPost
@synthesize linkUrl;

-(id) initWithPost:(TBXMLElement *)post
{
    self = [super init];
    TBXMLElement *xmlLinkText = [TBXML childElementNamed:@"link-text" parentElement:post];
    linkText = xmlLinkText ? [TBXML textForElement:xmlLinkText] : @"";
    TBXMLElement *xmlLinkUrl = [TBXML childElementNamed:@"link-url" parentElement:post];
    linkUrl = xmlLinkUrl ? [Post textToHtml:[TBXML textForElement:xmlLinkUrl]] : @"";
    TBXMLElement *xmlLinkDescription = [TBXML childElementNamed:@"link-description" parentElement:post];
    linkDescription = xmlLinkDescription ? [Post textToHtml:[TBXML textForElement:xmlLinkDescription]] : @"";
    return self;
}

-(PostType) type
{
    return LinkPostType;
}

-(NSAttributedString *) attributedText
{
    NSString *linkString = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>", linkUrl, linkText];
    if (linkDescription && [linkDescription length] > 0)
        linkString = [NSString stringWithFormat:@"%@<br><br>%@", linkString, linkDescription];
    return [[NSAttributedString alloc] initWithData:[[linkString stringByAppendingString:@"<style>body{font-size:14px;}</style>"] dataUsingEncoding:NSUnicodeStringEncoding allowLossyConversion:YES] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
}

@end
