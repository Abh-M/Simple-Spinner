//
//  Spinner.m
//  QuartzFun
//
//  Created by Abhineet on 30/05/13.
//  Copyright (c) 2013 Abhineet. All rights reserved.
//

#import "Spinner.h"
#import <QuartzCore/QuartzCore.h>

static Spinner *sharedInstance;


/** Default values **/


#define OVERLAY_DEFAULT_BACKGROUND_COLOR [UIColor blackColor]

#define OVERLAY_DEFAULT_FROM_OPACITY 0.0;

#define OVERLAY_DEFAULT_END_OPACITY 0.5;

#define SPINNER_DEFAULT_BACKGROUND_COLOR [UIColor lightGrayColor]

#define SPINNER_DEFAULT_COLOR [UIColor blackColor]

const CGFloat SPINNER_DEFAULT_THICKNESS = 5.0;

const CGFloat SPINNER_DEFAULT_RADIUS = 25.0;



/*******************/

@interface Spinner ()

@property (nonatomic,strong) UIView *spinnerView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) CAShapeLayer *spinnerShape;
@property (nonatomic,strong) CAShapeLayer *spinnerInnerShape;
@property (nonatomic) CGFloat overlayOpacityEndValue;
@property (nonatomic) CGFloat overlayOpacityStartValue;
@property (nonatomic) BOOL isVisible;
@end



@implementation Spinner


-(id)init
{
    self = [super init];
    if(self)
    {
        self.overlayBackgroundColor = OVERLAY_DEFAULT_BACKGROUND_COLOR;
        self.spinnerRadius = SPINNER_DEFAULT_RADIUS;
        self.spinnerThickness = SPINNER_DEFAULT_THICKNESS;
        
        self.isVisible = NO;
        self.opaque = FALSE;
        self.overlayOpacityStartValue = OVERLAY_DEFAULT_FROM_OPACITY;
        self.overlayOpacityEndValue = OVERLAY_DEFAULT_END_OPACITY;
        self.alpha = self.overlayOpacityStartValue;
    }
    
    return self;
}


+(id)shared
{
    if(sharedInstance == NULL)
        sharedInstance = [[Spinner alloc] init];
    return sharedInstance;
}



-(UIView *)spinnerView
{
    if(_spinnerView == NULL)
    {
        _spinnerView = [[UIView alloc] init];
        _spinnerView.backgroundColor =SPINNER_DEFAULT_BACKGROUND_COLOR;
    }
    
    return _spinnerView;
}


-(CAShapeLayer*)spinnerShape
{
    
    if(_spinnerShape) return _spinnerShape;
    _spinnerShape = [CAShapeLayer layer];
    _spinnerShape.strokeColor = SPINNER_DEFAULT_COLOR.CGColor;
    //For filled circle remove below line
    _spinnerShape.fillColor = [UIColor clearColor].CGColor;
    _spinnerShape.lineWidth = self.spinnerThickness;
    _spinnerShape.lineCap = @"round";
    _spinnerShape.path = NULL;
    return _spinnerShape;
    
    
}

-(CAShapeLayer*)spinnerInnerShape
{
 
    
    if(_spinnerInnerShape) return _spinnerInnerShape;
    _spinnerInnerShape= [CAShapeLayer layer];
    _spinnerInnerShape.fillColor = [UIColor clearColor].CGColor;
    _spinnerInnerShape.path = NULL;
    return _spinnerInnerShape;
    

}

-(CAShapeLayer *)getSpinnerShapeForRect:(CGRect)kRect
{
    
    CGMutablePathRef newPath = CGPathCreateMutable();
    CGPathAddArc(newPath, NULL, CGRectGetMidX(kRect), CGRectGetMidY(kRect), self.spinnerRadius-self.spinnerThickness,  ((0)*M_PI)/180.0, ((270)*M_PI)/180.0, 1);
    self.spinnerShape.path = newPath;
    return self.spinnerShape;
    
    
}


-(CAShapeLayer *)getInnerShapeForRect:(CGRect)kRect
{
    CGMutablePathRef pp = CGPathCreateMutable();
    CGPathAddEllipseInRect(pp, NULL, kRect);
    self.spinnerInnerShape.path = pp;
    return self.spinnerInnerShape;
    
    
}

-(void)configureForRect:(CGRect)kRect
{
    
    self.frame = kRect;
    self.backgroundColor = self.overlayBackgroundColor;
    CGRect  overlayRect = self.bounds;
    CGPoint overlayCenter = CGPointMake(CGRectGetMidX(overlayRect), CGRectGetMidY(overlayRect));
    CGRect  spinnerRect = CGRectMake(overlayCenter.x-self.spinnerRadius, overlayCenter.y-self.spinnerRadius, self.spinnerRadius*2, self.spinnerRadius*2);
    CGRect  spinnerOuterRect = CGRectMake(0.0, 0.0, 2*self.spinnerRadius, 2*self.spinnerRadius);
    CGRect  spinnerInnerRect = CGRectMake(0.0+10.0, 0.0+10.0, 2*(self.spinnerRadius-10.0), 2*(self.spinnerRadius-10.0));
    [self.spinnerView setFrame:spinnerRect];
    [self addSubview:self.spinnerView];
    [self.spinnerView.layer setCornerRadius:self.spinnerRadius];
    [self.spinnerView.layer addSublayer:[self getSpinnerShapeForRect:spinnerOuterRect]];
    [self.spinnerView.layer addSublayer:[self getInnerShapeForRect:spinnerInnerRect]];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.005
                                                  target:self
                                                selector:@selector(rotate:)
                                                userInfo:nil
                                                 repeats:YES];
    
    
}

-(void)rotate:(id)sender
{
    static CGFloat angle = 0;
    angle = angle+(M_PI/80);
    self.spinnerView.layer.sublayerTransform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0);
}



-(void)addOnView:(UIView *)kParentView
{
    
    
    if(self.isVisible)
    {
        [self.timer invalidate];
        [self removeFromSuperview];

    }
    
    [kParentView addSubview:self];
    [UIView animateWithDuration:1.0
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                         [self.layer setOpacity:self.overlayOpacityEndValue];
                         
                     } completion:^(BOOL finished) {
                     }];
    
    [self configureForRect:kParentView.frame];
}

-(void)remove
{
    
    
    
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                         [self.layer setOpacity:self.overlayOpacityStartValue];
                         
                         
                     } completion:^(BOOL finished) {
                         
                         [self.timer invalidate];
                         [self removeFromSuperview];
                         
                     }];
    
    
    
}


-(void)willMoveToSuperview:(UIView *)newSuperview
{
    
    self.isVisible=!self.isVisible;
    NSLog(@"%@",(self.isVisible)?@"Added":@"removed");
    
}


-(void)addOnView:(UIView *)kParentView  forDuration:(NSTimeInterval)kDuration
{
    [self addOnView:kParentView];
    [NSTimer scheduledTimerWithTimeInterval:kDuration target:self
                                   selector:@selector(remove)
                                   userInfo:nil
                                    repeats:NO];
}




@end
