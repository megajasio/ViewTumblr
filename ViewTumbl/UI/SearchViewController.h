//
//  ViewController.h
//  ViewTumbl
//
//  Created by Jan Świeżyński on 02.01.2017.
//  Copyright © 2017 jansoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingOverlayView.h"

@interface SearchViewController : UIViewController<UISearchBarDelegate>
{
    UISearchBar *userSearchBar;
    UILabel *instructionsLabel;
    LoadingOverlayView *overlayView;
}

@end
