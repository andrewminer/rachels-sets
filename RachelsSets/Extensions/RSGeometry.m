//
//  RSGeometry.m
//  rachels-sets
//
//  Created by Andrew Miner on 10/19/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

#import "RSGeometry.h"

// Public Implementation ///////////////////////////////////////////////////////////////////////////////////////////////

CGRect CGRectFloor(CGRect rect) {
    return (CGRect) {
        floor(rect.origin.x),
        floor(rect.origin.y),
        ceil(rect.size.width),
        ceil(rect.size.height)
    };
}

CGFloat CGSizeMinDimension(CGSize size) {
    return MIN(size.height, size.width);
}

CGFloat CGSizeMaxDimension(CGSize size) {
    return MAX(size.height, size.width);
}
