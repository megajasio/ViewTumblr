//
//  TumblrTableViewCells.h
//  ViewTumbl
//
//  Created by Jan Świeżyński on 05.01.2017.
//  Copyright © 2017 jansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoTableViewCell : UITableViewCell

@property (strong) UILabel *photoCaption;
@property (strong) UIImageView *photoImage;

@property (nonatomic) CGRect imageRect, captionRect;

@end

@interface LoadingTableViewCell : UITableViewCell

@property (strong) UIActivityIndicatorView *spinner;

@end

@interface VideoTableViewCell : UITableViewCell

@property (strong) UILabel *videoCaption;
@property (strong) UIWebView *webView;

@end
