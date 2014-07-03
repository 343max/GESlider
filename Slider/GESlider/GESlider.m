//
//  GESlider.m
//  Slider
//
//  Created by Max von Webel on 03/07/14.
//  Copyright (c) 2014 Max von Webel. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "GERectHelpers.h"
#import "GESlider.h"

@interface GESlider ()

@property (weak, readonly) UIImageView *thumbImageView;
@property (weak, readonly) UIView *trackView;
@property (weak, readonly) UIView *selectedTrackView;
@property (weak, readonly) UIPanGestureRecognizer *gestureRecognizer;

@property (assign) CGPoint touchOffset;

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
    _trackView = (^{
        UIView *trackView = [[UIView alloc] init];
        trackView.backgroundColor = [UIColor colorWithRed:0.907 green:0.901 blue:0.926 alpha:1.000];
        trackView.layer.cornerRadius = 2.0;
        [self addSubview:trackView];
        return trackView;
    })();

    _selectedTrackView = (^{
        UIView *selectedTrackView = [[UIView alloc] init];
        selectedTrackView.backgroundColor = [UIColor colorWithRed:0.943 green:0.587 blue:0.110 alpha:1.000];
        selectedTrackView.layer.cornerRadius = 2.0;
        [self addSubview:selectedTrackView];
        return selectedTrackView;
    })();

    _thumbImageView = (^{
        UIImageView *thumbImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GESliderThumbImage"]];
        [self addSubview:thumbImageView];
        thumbImageView.userInteractionEnabled = YES;
        return thumbImageView;
    })();
    
    _gestureRecognizer = (^{
        UIPanGestureRecognizer *gestureReocgnizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
        [self.thumbImageView addGestureRecognizer:gestureReocgnizer];
        return gestureReocgnizer;
    })();
    
    [self doLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self doLayout];
}

- (CGRect)trackViewFrameForValue:(float)value
{
    CGRect frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds) - CGRectGetWidth(self.thumbImageView.frame), 3.0);
    frame = GERectInsideRect(self.bounds, frame, 0.5, 0.5);
    frame.size.width *= (value - self.minimumValue) / (self.maximumValue - self.minimumValue);
    return CGRectIntegral(frame);
}

- (void)doLayout
{
    self.trackView.frame = [self trackViewFrameForValue:self.maximumValue];
    self.selectedTrackView.frame = [self trackViewFrameForValue:self.value];
    
    [self updateThumbPosition];
}

- (void)didPan:(UIPanGestureRecognizer *)panGestureRecognizer
{
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.touchOffset = [panGestureRecognizer locationInView:self.thumbImageView];
            break;
        case UIGestureRecognizerStateChanged:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            CGPoint location = [panGestureRecognizer locationInView:self];
            float offset = (location.x - self.touchOffset.x) / (CGRectGetWidth(self.bounds) - CGRectGetWidth(self.thumbImageView.frame));
            self.value = offset * (self.maximumValue - self.minimumValue) + self.minimumValue;
            break;
        }
            
        default:
            break;
    }
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
        [self doLayout];
        [UIView animateWithDuration:0.2
                         animations:^{
                             [self updateThumbPosition];
                         }];
    } else {
        [self setNeedsLayout];
    }
}

@end
