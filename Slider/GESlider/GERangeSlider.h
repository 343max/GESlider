//
//  GERangeSlider.h
//  Slider
//
//  Created by Max von Webel on 18/07/14.
//  Copyright (c) 2014 Max von Webel. All rights reserved.
//

#import "GESlider.h"

@interface GERangeSlider : GESlider

@property (assign, nonatomic) float upperValue;
@property (assign, nonatomic) float minimumDifference;

@property (strong, nonatomic) UIImage *upperThumbImage;

- (void)setUpperValue:(float)upperValue animated:(BOOL)animated;

@end
