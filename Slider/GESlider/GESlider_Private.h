//
//  GESlider_Private.h
//  Slider
//
//  Created by Max von Webel on 18/07/14.
//  Copyright (c) 2014 Max von Webel. All rights reserved.
//

#import "GESlider.h"

@interface GESlider ()

- (UIImageView *)thumbImageViewWithImage:(UIImage *)image;
- (void)commonAwake;
- (void)doLayout;
- (float)steppedValueForValue:(float)value;
- (CGRect)thumbFrameWithValue:(float)value thumbSize:(CGSize)thumbSize;
- (UIPanGestureRecognizer *)thumbPanGestureRecognizer;
- (void)updateValue:(float)value forGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer
    gestureFinished:(BOOL)gestureFinished;
- (GERange)highligtedRange;

@property (weak, readonly) UIImageView *thumbImageView;
@property (weak, readonly) UIView *trackView;
@property (weak, readonly) UIView *selectedTrackView;
@property (weak, readonly) UIPanGestureRecognizer *gestureRecognizer;

@property (strong, readonly) NSArray *stepViews;

@property (assign) CGPoint touchOffset;

@property (assign) BOOL needsStepViewRecreation;

@property (assign, nonatomic) float internalValue;
@property (assign) float recentLabelValue;

@end