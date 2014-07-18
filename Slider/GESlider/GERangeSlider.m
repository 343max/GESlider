//
//  GERangeSlider.m
//  Slider
//
//  Created by Max von Webel on 18/07/14.
//  Copyright (c) 2014 Max von Webel. All rights reserved.
//

#import "GERangeSlider.h"
#import "GESlider_Private.h"

@interface GERangeSlider ()

@property (weak, readonly) UIImageView *upperThumbImageView;

@property (assign) float internalUpperValue;

@property (weak, readonly) UIPanGestureRecognizer *upperPanGestureRecognizer;

@end


@implementation GERangeSlider

- (void)commonAwake
{
    self.internalUpperValue = self.upperValue;
    [super commonAwake];
    _upperThumbImageView = [self thumbImageViewWithImage:self.upperThumbImage];
    
    _upperPanGestureRecognizer = (^{
        UIPanGestureRecognizer *panGestureRecognizer = [self thumbPanGestureRecognizer];
        [self.upperThumbImageView addGestureRecognizer:panGestureRecognizer];
        return panGestureRecognizer;
    })();
}

- (void)doLayout
{
    [super doLayout];
    [self updateUpperThumbPosition];
}

@synthesize upperThumbImage = _upperThumbImage;
- (UIImage *)upperThumbImage
{
    if (_upperThumbImage == nil) {
        return self.thumbImage;
    } else {
        return _upperThumbImage;
    }
}

- (void)setUpperThumbImage:(UIImage *)upperThumbImage
{
    _upperThumbImage = upperThumbImage;
    self.upperThumbImageView.image = _upperThumbImage;
}

- (void)setUpperValue:(float)upperValue
{
    [self setUpperValue:upperValue animated:NO];
}

- (void)setUpperValue:(float)upperValue animated:(BOOL)animated
{
    [self willChangeValueForKey:@"upperValue"];
    
    upperValue = fminf(upperValue, self.maximumValue);
    upperValue = fmaxf(upperValue, self.minimumValue);

    self.internalUpperValue = _upperValue = upperValue;
    
    if (animated) {
        [UIView animateWithDuration:0.1
                         animations:^{
                             [self doLayout];
                         }];
    } else {
        [self setNeedsLayout];
    }
    
    [self didChangeValueForKey:@"upperValue"];
}

- (GERange)highligtedRange
{
    return GERangeMake(self.internalValue, self.internalUpperValue);
}

- (void)updateUpperThumbPosition
{
    self.upperThumbImageView.frame = [self thumbFrameWithValue:self.internalUpperValue thumbSize:self.upperThumbImageView.frame.size];
}

- (void)updateValue:(float)value forGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer gestureFinished:(BOOL)gestureFinished
{
    if (gestureRecognizer != self.upperPanGestureRecognizer) {
        [self addSubview:self.thumbImageView];
        value = fminf(value, self.upperValue - self.minimumDifference);
        [super updateValue:value forGestureRecognizer:gestureRecognizer gestureFinished:gestureFinished];
    } else {
        [self addSubview:self.upperThumbImageView];
        value = fmaxf(value, self.value + self.minimumDifference);
        value = fminf(value, self.maximumValue);
        if (gestureFinished) {
            value = [self steppedValueForValue:value];
            [self setUpperValue:value animated:YES];
        } else {
            self.internalUpperValue = value;
            [self updateLabelForValue:value];
            [self doLayout];
        }
    }
}

@end
