//
//  GETestViewController.m
//  Slider
//
//  Created by Max von Webel on 03/07/14.
//  Copyright (c) 2014 Max von Webel. All rights reserved.
//

#import "GESlider/GESlider.h"
#import "GESlider/GERangeSlider.h"

#import "GETestViewController.h"

@interface GETestViewController () <GESliderDelegate>

@property (weak, nonatomic) IBOutlet GESlider *steppingSlider;
@property (weak, nonatomic) IBOutlet GESlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet GERangeSlider *rangeSlider;

@end

@implementation GETestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.tintColor = [UIColor colorWithRed:0.943 green:0.587 blue:0.110 alpha:1.000];
    
    self.steppingSlider.minimumValue = 0.0;
    self.steppingSlider.maximumValue = 5.0;
    self.steppingSlider.stepValue = 1.0;
    self.steppingSlider.delegate = self;
    self.steppingSlider.showValueLabelWhilePanning = YES;
    
    [self.steppingSlider setValue:2.0 animated:YES];
    [self.steppingSlider addTarget:self action:@selector(didSlide:) forControlEvents:UIControlEventValueChanged];
    [self didSlide:self.steppingSlider];
    
    self.slider.minimumValue = 0.0;
    self.slider.maximumValue = 10.0;
    self.slider.showValueLabelWhilePanning = YES;
    
    self.rangeSlider.upperValue = 15.0;
    self.rangeSlider.delegate = self;
}

- (IBAction)didSlide:(GESlider *)sender
{
    self.label.text = [NSString stringWithFormat:@"%f", sender.value];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark GESliderDelegate

- (NSString *)descriptionForValue:(float)value ofSlider:(GESlider *)slider
{
    if (slider == self.rangeSlider) {
        return [NSString stringWithFormat:@"%.0f:00", value];
    } else {
        switch ((int)value) {
            case 0:
                return @"No Stops";
            case 1:
                return @"1 Stop";
            default:
                return [NSString stringWithFormat:@"%.0f Stops", value];
        }
    }
}


@end
