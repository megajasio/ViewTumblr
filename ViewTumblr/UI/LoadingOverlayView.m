//
//  LoadingOverlayView.m
//  ViewTumbl
//
//  Created by Jan Świeżyński on 02.01.2017.
//  Copyright © 2017 jansoft. All rights reserved.
//

#import "LoadingOverlayView.h"

@implementation LoadingOverlayView

-(id) init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.75f];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // create the activity spinner, center it horizontall and put it 5 points above center x
        activitySpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self addSubview:activitySpinner];
        [activitySpinner startAnimating];
        
        // create and configure the "Loading Data" label
        loadingLabel = [UILabel new];
        loadingLabel.backgroundColor = [UIColor clearColor];
        loadingLabel.textColor = [UIColor whiteColor];
        loadingLabel.text = @"";
        loadingLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:loadingLabel];
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    float labelHeight = 22;
    float labelWidth = self.frame.size.width - 20;
    
    // derive the center x and y
    float centerX = self.frame.size.width / 2;
    float centerY = self.frame.size.height / 2;
    
    activitySpinner.frame = CGRectMake(
                                       centerX - (activitySpinner.frame.size.width / 2),
                                       centerY - activitySpinner.frame.size.height - 20,
                                       activitySpinner.frame.size.width,
                                       activitySpinner.frame.size.height);
    
    loadingLabel.frame = CGRectMake(
                                    centerX - (labelWidth / 2),
                                    centerY + 20,
                                    labelWidth,
                                    labelHeight
                                    );
}

-(void) hide
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL result){
        [self removeFromSuperview];
    }];
}

-(void) show:(NSString *)text
{
    loadingLabel.text = text;
    if (!self.superview)
    {
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        self.frame = [UIScreen mainScreen].bounds;
        [window addSubview:self];
        self.alpha = 0.0f;
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 1.0f;
        }];
    }
}

@end
