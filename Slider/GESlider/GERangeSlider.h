//
//  GERangeSlider.h
//  Slider
//
//  Created by Max von Webel on 18/07/14.
//  Copyright (c) 2014 Max von Webel. All rights reserved.
//

#import "GESlider.h"

@interface GERangeSlider : GESlider

@property (assign, nonatomic) IBInspectable float upperValue;
@property (assign, nonatomic) IBInspectable float minimumDifference;

@property (strong, nonatomic) IBInspectable UIImage *upperThumbImage;

@end
