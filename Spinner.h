//
//  Spinner.h
//  QuartzFun
//
//  Created by Abhineet on 30/05/13.
//  Copyright (c) 2013 Abhineet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Spinner : UIView

@property (nonatomic, strong) UIColor *overlayBackgroundColor;
@property (nonatomic) CGFloat spinnerThickness;
@property (nonatomic) CGFloat spinnerRadius;
@property (nonatomic, readonly) BOOL isVisible;

+(id)shared;
-(void)addOnView:(UIView *)kParentView;
-(void)remove;
-(void)addOnView:(UIView *)kParentView  forDuration:(NSTimeInterval)kDuration;


@end
