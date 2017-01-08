//
//  UIImageView+Fetchable.h
//  ViewTumbl
//
//  Created by Jan Świeżyński on 06.01.2017.
//  Copyright © 2017 jansoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Fetchable)

- (void)loadURL:(NSURL*)imageURL completion:(void (^)())block;

@property (nonatomic, retain) id associatedObject;

@end
