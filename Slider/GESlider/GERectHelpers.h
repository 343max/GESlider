//
//  NXRectHelpers.h
//  NXKit
//
//  Created by Max Winde on 28.02.12.
//  Copyright (c) 2012 nxtbgthng. All rights reserved.
//

#import <Foundation/Foundation.h>

# define GERectOffsetDontChange CGFLOAT_MAX

CGRect GERectInsideRect(CGRect outerRect, CGRect innerRect, CGFloat horizontalOffset, CGFloat verticalOffset);