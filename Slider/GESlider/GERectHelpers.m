//
//  NXRectHelpers.m
//  NXKit
//
//  Created by Max Winde on 28.02.12.
//  Copyright (c) 2012 nxtbgthng. All rights reserved.
//

#import "GERectHelpers.h"

CGRect GERectInsideRect(CGRect outerRect, CGRect innerRect, CGFloat horizontalOffset, CGFloat verticalOffset)
{
    CGRect positionedRect = innerRect;
    
    if (horizontalOffset != GERectOffsetDontChange) {
        positionedRect.origin.x = outerRect.origin.x + (outerRect.size.width - innerRect.size.width) * horizontalOffset;
    }
    
    if (verticalOffset != GERectOffsetDontChange) {
        positionedRect.origin.y = outerRect.origin.y + (outerRect.size.height - innerRect.size.height) * verticalOffset;
    }
    
    return positionedRect;
}