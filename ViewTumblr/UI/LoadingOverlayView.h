//
//  LoadingOverlayView.h
//  ViewTumbl
//
//  Created by Jan Świeżyński on 02.01.2017.
//  Copyright © 2017 jansoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingOverlayView : UIView
{
    UIActivityIndicatorView *activitySpinner;
    UILabel *loadingLabel;
}

-(void) hide;
-(void) show:(NSString *)text;

@end
