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

@end


@implementation GERangeSlider

- (void)commonAwake
{
    self.internalUpperValue = self.upperValue;
    [super commonAwake];
    _upperThumbImageView = [self thumbImageViewWithImage:self.upperThumbImage];
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

- (void)updateUpperThumbPosition
{
    self.upperThumbImageView.frame = [self thumbFrameWithValue:self.internalUpperValue thumbSize:self.upperThumbImageView.frame.size];
}

@end
