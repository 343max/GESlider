//
//  GELabelWithPadding.m
//  Slider
//
//  Created by Max von Webel on 07/07/14.
//  Copyright (c) 2014 Max von Webel. All rights reserved.
//

#import "GELabelWithPadding.h"

@implementation GELabelWithPadding

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    size = [super sizeThatFits:size];
    size.width += self.edgeInsets.left + self.edgeInsets.right;
    size.height += self.edgeInsets.top + self.edgeInsets.bottom;
    return size;
}

@end
