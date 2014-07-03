//
//  GETestViewController.m
//  Slider
//
//  Created by Max von Webel on 03/07/14.
//  Copyright (c) 2014 Max von Webel. All rights reserved.
//

#import "GESlider/GESlider.h"

#import "GETestViewController.h"

@interface GETestViewController ()

@property (weak, nonatomic) IBOutlet GESlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *label;

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
    
    self.slider.minimumValue = 1.0;
    self.slider.maximumValue = 5.0;
    self.slider.stepValue = 1.0;
    
    [self.slider setValue:3.0 animated:YES];
    [self.slider addTarget:self action:@selector(didSlide:) forControlEvents:UIControlEventValueChanged];
    [self didSlide:self.slider];
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

@end
