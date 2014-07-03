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

@property (strong, readonly) NSArray *snapViews;

@property (assign) CGPoint touchOffset;

@property (assign) BOOL needsSnapViewRecreation;

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
    _trackTintColor = [UIColor colorWithRed:0.907 green:0.901 blue:0.926 alpha:1.000];
    
    _trackView = (^{
        UIView *trackView = [[UIView alloc] init];
        trackView.layer.cornerRadius = 2.0;
        [self addSubview:trackView];
        return trackView;
    })();

    _selectedTrackView = (^{
        UIView *selectedTrackView = [[UIView alloc] init];
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

- (float)relativeValueForValue:(float)value
{
    return (value - self.minimumValue) / (self.maximumValue - self.minimumValue);
}

- (CGRect)trackViewFrameForValue:(float)value
{
    CGRect frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds) - CGRectGetWidth(self.thumbImageView.frame), 3.0);
    frame = GERectInsideRect(self.bounds, frame, 0.5, 0.5);
    frame.size.width *= [self relativeValueForValue:value];
    return frame;
}

- (void)recreateSnapViews
{
    for (UIView *snapView in self.snapViews) {
        [snapView removeFromSuperview];
    }
    
    NSArray *snapViews = @[];
    for (float value = self.minimumValue; value <= self.maximumValue; value += self.snapValue) {
        UIView *snapView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 8.0, 8.0)];
        snapView.layer.cornerRadius = 4.0;
        [self insertSubview:snapView belowSubview:self.thumbImageView];
        snapViews = [snapViews arrayByAddingObject:snapView];
    }
    
    _snapViews = snapViews;
}

- (void)doLayout
{
    if (self.needsSnapViewRecreation) {
        self.needsSnapViewRecreation = NO;
        [self recreateSnapViews];
    }
    
    CGRect frame = CGRectInset(self.bounds, (CGRectGetWidth(self.thumbImageView.frame) - CGRectGetWidth([[self.snapViews firstObject] frame])) / 2.0, 0.0);
    for (UIView *snapView in self.snapViews) {
        NSInteger index = [self.snapViews indexOfObject:snapView];
        float value = self.minimumValue + index * self.snapValue;
        snapView.backgroundColor = (value > self.value ? self.trackTintColor : self.tintColor);
        snapView.frame = GERectInsideRect(frame, snapView.frame, [self relativeValueForValue:value], 0.5);
    }
    
    self.trackView.frame = [self trackViewFrameForValue:self.maximumValue];
    self.selectedTrackView.frame = [self trackViewFrameForValue:self.value];
    
    self.trackView.backgroundColor = self.trackTintColor;
    self.selectedTrackView.backgroundColor = self.tintColor;
    
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
    self.needsSnapViewRecreation = YES;
    [self setNeedsLayout];
}

- (void)setMaximumValue:(float)maximumValue
{
    _maximumValue = maximumValue;
    if (self.value > maximumValue) {
        self.value = maximumValue;
    }
    self.needsSnapViewRecreation = YES;
    [self setNeedsLayout];
}

- (void)setSnapValue:(float)snapValue
{
    _snapValue = snapValue;
    self.needsSnapViewRecreation = YES;
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
        [UIView animateWithDuration:0.1
                         animations:^{
                             [self updateThumbPosition];
                         }];
    } else {
        [self setNeedsLayout];
    }
}

- (void)tintColorDidChange
{
    [super tintColorDidChange];
    [self doLayout];
}

- (void)setTrackTintColor:(UIColor *)trackTintColor
{
    if ([trackTintColor isEqual:_trackTintColor])
        return;
    
    _trackTintColor = trackTintColor;
    [self doLayout];
}

@end
