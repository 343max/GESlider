//
//  GESliderDelegate.h
//  Slider
//
//  Created by Max von Webel on 07/07/14.
//  Copyright (c) 2014 Max von Webel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GESlider;

@protocol GESliderDelegate <NSObject>

@optional

- (NSString *)labelForSlider:(GESlider *)slider value:(float)value;

@end
