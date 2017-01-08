//
//  ViewController.m
//  ViewTumbl
//
//  Created by Jan Świeżyński on 02.01.2017.
//  Copyright © 2017 jansoft. All rights reserved.
//

#import "SearchViewController.h"
#import "AppSystem.h"
#import "TumblrTableViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    userSearchBar = [UISearchBar new];
    userSearchBar.placeholder = NSLocalizedString(@"user_name", @"");
    userSearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    userSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    userSearchBar.delegate = self;
    [self.view addSubview:userSearchBar];
    
    instructionsLabel = [UILabel new];
    instructionsLabel.numberOfLines = 0;
    instructionsLabel.backgroundColor = [UIColor clearColor];
    instructionsLabel.textColor = [UIColor lightGrayColor];
    instructionsLabel.text = NSLocalizedString(@"instructions", @"");
    instructionsLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:instructionsLabel];
    
    overlayView = [LoadingOverlayView new];
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    userSearchBar.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, self.view.frame.size.width, 44);
    instructionsLabel.frame = CGRectMake(20, userSearchBar.frame.origin.y + 54, self.view.frame.size.width - 40, 50);
}

-(void) loadTumblr
{
    [overlayView show:NSLocalizedString(@"loading", @"")];
    [[AppSystem inst].postsArray removeAllObjects];
    
    // Create a success block to be called when the async request completes
    TBXMLSuccessBlock successBlock = ^(TBXML *tbxmlDocument) {
        // If TBXML found a root node, process element and iterate all children
        if (tbxmlDocument.rootXMLElement)
//            [self traverseElement:tbxmlDocument.rootXMLElement];
            [[AppSystem inst] parseTumblr:tbxmlDocument.rootXMLElement];
        dispatch_async(dispatch_get_main_queue(), ^{
            [overlayView hide];
            TumblrTableViewController *tumblrViewController = [[TumblrTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:tumblrViewController animated:YES];
        });
    };
    
    // Create a failure block that gets called if something goes wrong
    TBXMLFailureBlock failureBlock = ^(TBXML *tbxmlDocument, NSError * error) {
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [overlayView hide];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"") message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        });
    };
    
    // Initialize TBXML with the URL of an XML doc. TBXML asynchronously loads and parses the file.
    TBXML *tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@.tumblr.com/api/read?num=5", [AppSystem inst].user]]
                                      success:successBlock
                                      failure:failureBlock];
    NSLog(@"%@", tbxml);
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [AppSystem inst].user = searchBar.text;
    [self loadTumblr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
