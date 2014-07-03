//
//  GESlider.m
//  Slider
//
//  Created by Max von Webel on 03/07/14.
//  Copyright (c) 2014 Max von Webel. All rights reserved.
//

#import "GERectHelpers.h"
#import "GESlider.h"

@interface GESlider ()

@property (weak, readonly) UIImageView *thumbImageView;

@end


@implementation GESlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonAwake];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _maximumValue = 1.0;
    
    [self commonAwake];
}

- (void)commonAwake
{
    _thumbImageView = (^{
        UIImageView *thumbImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GESliderThumbImage"]];
        [self addSubview:thumbImageView];
        return thumbImageView;
    })();
    
    [self doLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self doLayout];
}

- (void)doLayout
{
    [self updateThumbPosition];
}

- (void)updateThumbPosition
{
    self.thumbImageView.frame = GERectInsideRect(self.bounds, self.thumbImageView.frame, (self.value - self.minimumValue) / (self.maximumValue - self.minimumValue), 0.5);
}

- (void)setMinimumValue:(float)minimumValue
{
    _minimumValue = minimumValue;
    if (self.value < minimumValue) {
        self.value = minimumValue;
    }
    [self setNeedsLayout];
}

- (void)setMaximumValue:(float)maximumValue
{
    _maximumValue = maximumValue;
    if (self.value > maximumValue) {
        self.value = maximumValue;
    }
    [self setNeedsLayout];
}

- (void)setValue:(float)value
{
    [self setValue:value animated:NO];
}

- (void)setValue:(float)value animated:(BOOL)animated
{
    value = fminf(value, self.maximumValue);
    value = fmaxf(value, self.minimumValue);
    
    _value = value;
    
    if (animated) {
        [UIView animateWithDuration:0.2
                         animations:^{
                             [self updateThumbPosition];
                         }];
    } else {
        [self setNeedsLayout];
    }
}

@end
