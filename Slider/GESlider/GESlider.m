//
//  GESlider.m
//  Slider
//
//  Created by Max von Webel on 03/07/14.
//  Copyright (c) 2014 Max von Webel. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "GERectHelpers.h"
#import "GESlider_Private.h"

GERange GERangeMake(float lowerValue, float upperValue)
{
    GERange range;
    range.lowerValue = lowerValue;
    range.upperValue = upperValue;
    return range;
}

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
    
    [self commonAwake];
}

- (void)commonAwake
{
    if (_maximumValue == 0.0) {
        _maximumValue = 1.0;
    }
    
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

    _thumbImageView = [self thumbImageViewWithImage:self.thumbImage];
    
    _valueLabel = (^{
        GELabelWithPadding *valueLabel = [[GELabelWithPadding alloc] init];
        valueLabel.edgeInsets = UIEdgeInsetsMake(0.0, 4.0, 0.0, 4.0);
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        valueLabel.textColor = [UIColor whiteColor];
        valueLabel.layer.cornerRadius = 3.0;
        valueLabel.clipsToBounds = YES;
        return valueLabel;
    })();
    
    _gestureRecognizer = (^{
        UIPanGestureRecognizer *gestureReocgnizer = [self thumbPanGestureRecognizer];
        [self.thumbImageView addGestureRecognizer:gestureReocgnizer];
        return gestureReocgnizer;
    })();
    
    [self doLayout];
}

- (UIPanGestureRecognizer *)thumbPanGestureRecognizer
{
    return [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self doLayout];
}

- (float)relativeValueForValue:(float)value
{
    if (self.maximumValue == self.minimumValue)
        return 0.0;
    
    return (value - self.minimumValue) / (self.maximumValue - self.minimumValue);
}

- (CGRect)trackViewFrameForLowerValue:(float)lowerValue upperValue:(float)upperValue
{
    CGRect frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds) - CGRectGetWidth(self.thumbImageView.frame), 3.0);
    frame = GERectInsideRect(self.bounds, frame, 0.5, 0.5);
    frame.origin.x += roundf(frame.size.width * [self relativeValueForValue:lowerValue] * 2.0) / 2.0;
    frame.size.width = roundf(frame.size.width * [self relativeValueForValue:upperValue - lowerValue + self.minimumValue] * 2.0) / 2.0;
    return frame;
}

- (float)steppedValueForValue:(float)value
{
    if (self.stepValue == 0) {
        return value;
    } else {
        return roundf((value - self.minimumValue) / self.stepValue) * self.stepValue + self.minimumValue;
    }
}

- (void)updateLabelForValue:(float)value
{
    if (!self.showValueLabelWhilePanning)
        return;
    
    value = [self steppedValueForValue:value];
    
    if (value == self.recentLabelValue)
        return;
    
    self.recentLabelValue = value;
    
    NSString *stringValue = (^{
        if ([self.delegate respondsToSelector:@selector(descriptionForValue:ofSlider:)]) {
            return [self.delegate descriptionForValue:value ofSlider:self];
        } else {
            return [NSString stringWithFormat:@"%.2f", value];
        }
    })();
    
    self.valueLabel.text = stringValue;
    
    CGRect frame = CGRectZero;
    frame.size = [self.valueLabel sizeThatFits:CGSizeZero];
    frame.origin.x = CGRectGetMaxX([self trackViewFrameForLowerValue:self.minimumValue upperValue:value]) - frame.size.width / 2.0;
    frame.origin.y = CGRectGetMinY(self.thumbImageView.frame) - frame.size.height;
    
    if (self.valueLabel.superview == nil) {
        self.valueLabel.frame = frame;
        [self addSubview:self.valueLabel];
    } else {
        [UIView animateWithDuration:0.1
                              delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.valueLabel.frame = frame;
                         }
                         completion:nil];
    }
}

- (void)removeValueLabelAnimated
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.valueLabel.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [self.valueLabel removeFromSuperview];
                         self.valueLabel.alpha = 1.0;
                     }];
}

- (void)recreateStepViews
{
    for (UIView *stepView in self.stepViews) {
        [stepView removeFromSuperview];
    }
    
    if (self.stepValue == 0.0) {
        _stepViews = nil;
        return;
    }
    
    NSArray *stepViews = @[];
    for (float value = self.minimumValue; value <= self.maximumValue; value += self.stepValue) {
        UIView *stepView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 8.0, 8.0)];
        stepView.layer.cornerRadius = 4.0;
        [self insertSubview:stepView belowSubview:self.thumbImageView];
        stepViews = [stepViews arrayByAddingObject:stepView];
    }
    
    _stepViews = stepViews;
}

- (GERange)highligtedRange
{
    return GERangeMake(self.minimumValue, self.internalValue);
}

- (void)doLayout
{
    if (self.minimumValue == self.maximumValue) {
        self.gestureRecognizer.enabled = NO;
        self.thumbImageView.alpha = 0.5;
    } else {
        self.gestureRecognizer.enabled = YES;
        self.thumbImageView.alpha = 1.0;
    }
    
    if (self.needsStepViewRecreation) {
        self.needsStepViewRecreation = NO;
        [self recreateStepViews];
    }
    
    CGRect frame = CGRectInset(self.bounds, (CGRectGetWidth(self.thumbImageView.frame) - CGRectGetWidth([[self.stepViews firstObject] frame])) / 2.0, 0.0);
    GERange highlightedRange = [self highligtedRange];
    for (UIView *stepView in self.stepViews) {
        NSInteger index = [self.stepViews indexOfObject:stepView];
        float value = self.minimumValue + index * self.stepValue;
        stepView.backgroundColor = (value <= highlightedRange.upperValue && value >= highlightedRange.lowerValue ? self.tintColor : self.trackTintColor);
        stepView.frame = GERectInsideRect(frame, stepView.frame, [self relativeValueForValue:value], 0.5);
    }
    
    self.trackView.frame = [self trackViewFrameForLowerValue:self.minimumValue upperValue:self.maximumValue];
    self.selectedTrackView.frame = [self trackViewFrameForLowerValue:highlightedRange.lowerValue
                                                          upperValue:highlightedRange.upperValue];
    
    self.trackView.backgroundColor = self.trackTintColor;
    self.selectedTrackView.backgroundColor = self.tintColor;
    
    [self updateThumbPosition];
}

- (void)updateValue:(float)value forGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer gestureFinished:(BOOL)gestureFinished
{
    if (gestureFinished) {
        [self setValue:[self steppedValueForValue:value] animated:YES];
    } else {
        self.internalValue = value;
        [self updateLabelForValue:self.internalValue];
    }
}

- (void)didPan:(UIPanGestureRecognizer *)panGestureRecognizer
{
    float value = 0.0;
    
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.recentLabelValue = self.minimumValue - 1.0;
            self.touchOffset = [panGestureRecognizer locationInView:panGestureRecognizer.view];
            break;
        case UIGestureRecognizerStateChanged:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            CGPoint location = [panGestureRecognizer locationInView:self];
            float offset = (location.x - self.touchOffset.x) / (CGRectGetWidth(self.bounds) - CGRectGetWidth(self.thumbImageView.frame));
            value = offset * (self.maximumValue - self.minimumValue) + self.minimumValue;
            [self updateValue:value forGestureRecognizer:panGestureRecognizer gestureFinished:NO];
            
            [self doLayout];
            break;
        }
            
        default:
            break;
    }
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded || panGestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        [self updateValue:value forGestureRecognizer:panGestureRecognizer gestureFinished:YES];
        [self removeValueLabelAnimated];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (CGRect)thumbFrameWithValue:(float)value thumbSize:(CGSize)thumbSize
{
    CGRect thumbFrame = (CGRect){CGPointZero, thumbSize};
    CGRect frame = GERectInsideRect(self.bounds, thumbFrame, (value - self.minimumValue) / (self.maximumValue - self.minimumValue ?: 1.0), 0.5);
    frame.origin.x = roundf(frame.origin.x * 2.0) / 2.0;
    frame.origin.y = roundf(frame.origin.y * 2.0) / 2.0;
    
    return frame;
}

- (void)updateThumbPosition
{
    self.thumbImageView.frame = [self thumbFrameWithValue:self.internalValue thumbSize:self.thumbImageView.frame.size];
}

- (void)setMinimumValue:(float)minimumValue
{
    [self willChangeValueForKey:@"minimumValue"];
    _minimumValue = minimumValue;
    if (self.internalValue < minimumValue) {
        self.value = minimumValue;
    }
    self.needsStepViewRecreation = YES;
    [self setNeedsLayout];
    [self didChangeValueForKey:@"minimumValue"];
}

- (void)setMaximumValue:(float)maximumValue
{
    [self willChangeValueForKey:@"maximumValue"];
    _maximumValue = maximumValue;
    if (self.internalValue > maximumValue) {
        self.value = maximumValue;
    }
    self.needsStepViewRecreation = YES;
    [self setNeedsLayout];
    [self didChangeValueForKey:@"maximumValue"];
}

- (void)setStepValue:(float)stepValue
{
    [self willChangeValueForKey:@"stepValue"];
    _stepValue = stepValue;
    self.needsStepViewRecreation = YES;
    [self setNeedsLayout];
    [self didChangeValueForKey:@"stepValue"];
}

- (void)setValue:(float)value
{
    [self setValue:value animated:NO];
}

- (void)setInternalValue:(float)internalValue
{
    internalValue = fminf(internalValue, self.maximumValue);
    internalValue = fmaxf(internalValue, self.minimumValue);

    _internalValue = internalValue;
}

- (void)setValue:(float)value animated:(BOOL)animated
{
    [self willChangeValueForKey:@"value"];
    
    value = fminf(value, self.maximumValue);
    value = fmaxf(value, self.minimumValue);
  
    self.internalValue = _value = value;
    
    if (animated) {
        [UIView animateWithDuration:0.1
                         animations:^{
                             [self doLayout];
                         }];
    } else {
        [self setNeedsLayout];
    }
    
    [self didChangeValueForKey:@"value"];
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

@synthesize thumbImage = _thumbImage;
- (UIImage *)thumbImage
{
    if (_thumbImage == nil) {
        _thumbImage = [UIImage imageNamed:@"GESliderThumbImage"];
    }
    
    return _thumbImage;
}

- (void)setThumbImage:(UIImage *)thumbImage
{
    _thumbImage = thumbImage;
    self.thumbImageView.image = _thumbImage;
}

- (UIImageView *)thumbImageViewWithImage:(UIImage *)image
{
    UIImageView *thumbImageView = [[UIImageView alloc] initWithImage:image];
    CGRect frame = thumbImageView.frame;
    frame.size.width = (fmax(frame.size.width, 44.0));
    frame.size.height = (fmax(frame.size.height, 44.0));
    thumbImageView.contentMode = UIViewContentModeCenter;
    thumbImageView.frame = frame;
    [self addSubview:thumbImageView];
    thumbImageView.userInteractionEnabled = YES;
    return thumbImageView;
}

@end
