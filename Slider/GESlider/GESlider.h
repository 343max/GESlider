//
//  GESlider.h
//  Slider
//
//  Created by Max von Webel on 03/07/14.
//  Copyright (c) 2014 Max von Webel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GELabelWithPadding.h"
#import "GESliderDelegate.h"

IB_DESIGNABLE
@interface GESlider : UIControl

@property (assign, nonatomic) IBInspectable float minimumValue;
@property (assign, nonatomic) IBInspectable float maximumValue;
@property (assign, nonatomic) IBInspectable float value;
@property (assign, nonatomic) IBInspectable float stepValue;

@property (strong, nonatomic) IBInspectable UIColor *trackTintColor;

@property (strong, readonly) GELabelWithPadding *valueLabel;
@property (assign) BOOL showValueLabelWhilePanning;

@property (assign) id<GESliderDelegate> delegate;

- (void)setValue:(float)value animated:(BOOL)animated;

@end
