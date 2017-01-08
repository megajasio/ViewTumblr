//
//  TumblrTableViewController.m
//  ViewTumbl
//
//  Created by Jan Świeżyński on 02.01.2017.
//  Copyright © 2017 jansoft. All rights reserved.
//

#import "TumblrTableViewController.h"
#import "AppSystem.h"
#import "Posts.h"

#import "TumblrTableViewCells.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+Fetchable.h"

@interface TumblrTableViewController ()

@end

@implementation TumblrTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [[AppSystem inst] user];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    for (int i = 0; i < 1000; i++) {
        heights[i] = -1;
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

-(void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[AppSystem inst].postsArray count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= [[AppSystem inst].postsArray count])
    {
        LoadingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingCell"];
        if (!cell)
        {
            cell = [[LoadingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LoadingCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([AppSystem inst].postCount >  [[AppSystem inst].postsArray count])
        {
            [cell.spinner startAnimating];
            cell.spinner.hidden = NO;
        }
        else
            cell.spinner.hidden = YES;
        return cell;
    }
    
    Post *post = [[AppSystem inst].postsArray objectAtIndex:indexPath.section];
    if ([post type] == QuotePostType || [post type] == RegularPostType || [post type] == AnswerPostType || [post type] == LinkPostType)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            cell.textLabel.numberOfLines = 0;
        }
        cell.selectionStyle = [post type] == LinkPostType ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
        
        cell.textLabel.text = nil;
        cell.textLabel.attributedText = [post attributedText];
        
        return cell;
    }
    else if ([post type] == PhotoPostType)
    {
        PhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellPhoto"];
        
        if (!cell)
        {
            cell = [[PhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellPhoto"];
            cell.photoCaption.font = [UIFont systemFontOfSize:14.0f];
            cell.photoCaption.numberOfLines = 0;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        PhotoPost *photoPost = (PhotoPost *)post;
        float oldHeight = heights[indexPath.section];
        
        cell.imageRect = CGRectMake(0, 0, self.tableView.frame.size.width, oldHeight);
        cell.captionRect = CGRectMake(0, oldHeight + 20, self.tableView.frame.size.width, 30);
        
        [cell.photoImage loadURL:[NSURL URLWithString:photoPost.photoUrl] completion:^{
            CGRect rect = AVMakeRectWithAspectRatioInsideRect(cell.photoImage.image.size, CGRectMake(0, 0, self.view.frame.size.width, 5000));
            //                cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
            cell.imageRect = CGRectMake(0, 0, self.view.frame.size.width, rect.size.height);;
            cell.photoImage.frame = cell.imageRect;
            heights[indexPath.section] = rect.size.height;
            cell.captionRect = CGRectMake(20, rect.size.height + 20, self.view.frame.size.width - 40, [self attributedTextHeight:[photoPost attributedText] width:tableView.contentSize.width - 40]);
            cell.photoCaption.frame = cell.captionRect;
            cell.photoCaption.attributedText = [photoPost attributedText];
            if (oldHeight != rect.size.height)
            {
//                [self.tableView beginUpdates];
//                [self.tableView endUpdates];
            }
        }];
        cell.photoCaption.text = nil;
        cell.photoCaption.attributedText = [photoPost attributedText];
        
        return cell;
    }
    else if ([post type] == VideoPostType || [post type] == AudioPostType)
    {
        VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AVCell"];
        
        if (!cell)
        {
            cell = [[VideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AVCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *htmlString;
        NSAttributedString *attributedText;
        CGFloat height;
        
        if ([post type] == VideoPostType)
        {
            VideoPost *videoPost = (VideoPost *)post;
            htmlString = [videoPost videoText];
            attributedText = [videoPost attributedText];
            height = 200;
        }
        else
        {
            AudioPost *audioPost = (AudioPost *)post;
            htmlString = [audioPost audioText];
            attributedText = [audioPost attributedText];
            height = 90;
        }
        
        [cell.webView loadHTMLString:htmlString baseURL:nil];
        cell.webView.frame = CGRectMake(0, 0, tableView.frame.size.width, height);
        
        if (attributedText)
        {
            cell.videoCaption.hidden = NO;
            cell.videoCaption.attributedText = attributedText;
            cell.videoCaption.frame = CGRectMake(20, height + 5, tableView.frame.size.width - 40, [self attributedTextHeight:attributedText width:tableView.contentSize.width - 40]);
        }
        else
            cell.videoCaption.hidden = YES;
        
        return cell;
    }
    
    return nil;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section >= [[AppSystem inst].postsArray count])
        return [AppSystem inst].postCount >  [[AppSystem inst].postsArray count] ? 44.0f : 1.0f;
    
    Post *post = [[AppSystem inst].postsArray objectAtIndex:indexPath.section];
    if ([post type] == QuotePostType || [post type] == RegularPostType || [post type] == AnswerPostType || [post type] == LinkPostType)
    {
        return [self attributedTextHeight:[post attributedText] width:tableView.contentSize.width - 40];
    }
    else if ([post type] == PhotoPostType)
    {
        PhotoPost *photoPost = (PhotoPost *)post;
        return (heights[indexPath.section] > 0 ? heights[indexPath.section] : 30.0f) + 20.0f + [self attributedTextHeight:[photoPost attributedText] width:tableView.contentSize.width - 40];
    }
    else if ([post type] == VideoPostType)
    {
        VideoPost *videoPost = (VideoPost *)post;
        return 200.0f + ([videoPost attributedText] ? 5 + [self attributedTextHeight:[videoPost attributedText] width:tableView.contentSize.width - 40] : 0);
    }
    else if ([post type] == AudioPostType)
    {
        AudioPost *audioPost = (AudioPost *)post;
        return 90.0f + ([audioPost attributedText] ? 5 + [self attributedTextHeight:[audioPost attributedText] width:tableView.contentSize.width - 40] : 0);
    }
    return 30.0f;
}

-(CGFloat) attributedTextHeight:(NSAttributedString *)attrStr width:(CGFloat)width
{
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return rect.size.height;
}

-(CGFloat) htmlTextHeight:(NSString *)htmlString width:(CGFloat)width
{
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding allowLossyConversion:YES] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    return [self attributedTextHeight:attrStr width:width];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section >= [[AppSystem inst].postsArray count] && [AppSystem inst].postCount >  [[AppSystem inst].postsArray count])
        [self loadMore];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section >= [[AppSystem inst].postsArray count])
        return;
    
    Post *post = [[AppSystem inst].postsArray objectAtIndex:indexPath.section];
    if ([post type] == LinkPostType)
    {
        LinkPost *linkPost = (LinkPost *)post;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        });
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkPost.linkUrl]];
    }
}

-(void) loadMore
{
    static BOOL loadingMore = NO;
    if (loadingMore)
        return;
    loadingMore = YES;
    
    // Create a success block to be called when the async request completes
    TBXMLSuccessBlock successBlock = ^(TBXML *tbxmlDocument) {
        // If TBXML found a root node, process element and iterate all children
        int postsDownloaded = 0;
        int lastPost = [[AppSystem inst].postsArray count];
        if (tbxmlDocument.rootXMLElement)
            postsDownloaded = [[AppSystem inst] parseTumblr:tbxmlDocument.rootXMLElement];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(lastPost, postsDownloaded)] withRowAnimation:UITableViewRowAnimationNone];
            loadingMore = NO;
        });
    };
    
    // Create a failure block that gets called if something goes wrong
    TBXMLFailureBlock failureBlock = ^(TBXML *tbxmlDocument, NSError * error) {
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
        dispatch_async(dispatch_get_main_queue(), ^{
            loadingMore = NO;
        });
    };
    
    TBXML *tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@.tumblr.com/api/read?start=%d&num=5", [AppSystem inst].user, [[AppSystem inst].postsArray count]]]
                                      success:successBlock
                                      failure:failureBlock];
    NSLog(@"%@", tbxml);
}

@end
