//
//  TumblrTableViewCells.m
//  ViewTumbl
//
//  Created by Jan Świeżyński on 05.01.2017.
//  Copyright © 2017 jansoft. All rights reserved.
//

#import "TumblrTableViewCells.h"

@implementation PhotoTableViewCell
@synthesize photoImage, photoCaption, imageRect, captionRect;

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        photoCaption = [UILabel new];
        photoCaption.textColor = [UIColor blackColor];
        photoCaption.backgroundColor = [UIColor clearColor];
        
        photoImage = [UIImageView new];
        
        [self.contentView addSubview:photoCaption];
        [self.contentView addSubview:photoImage];
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    photoCaption.frame = captionRect;
    photoImage.frame = imageRect;
}

@end

@implementation LoadingTableViewCell
@synthesize spinner;

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.color = [UIColor colorWithRed:0.2 green:0.275 blue:0.365 alpha:1.0];
        [self.contentView addSubview:spinner];
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    spinner.center = self.contentView.center;
}

@end

@implementation VideoTableViewCell
@synthesize webView, videoCaption;

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        videoCaption = [UILabel new];
        videoCaption.textColor = [UIColor blackColor];
        videoCaption.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:videoCaption];
        
        webView = [UIWebView new];
        webView.allowsInlineMediaPlayback = true;
        [self.contentView addSubview:webView];
    }
    return self;
}

@end
