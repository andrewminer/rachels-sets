//
//  NSString+RSExtensions.m
//  rachels-sets
//
//  Created by Andrew Miner on 10/26/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

#import "NSString+RSExtensions.h"

// Public Implementation ///////////////////////////////////////////////////////////////////////////////////////////////

@implementation NSString (RSExtensions)

+ (NSString*) stringWithMinutesSeconds:(NSTimeInterval)interval {
    if (interval == 0) return @"00:00";
    
    NSInteger seconds = floor(interval);
    NSInteger minutes = seconds / 60;
    seconds = seconds - minutes * 60;

    return [NSString stringWithFormat:@"%02d:%02d", ((int)minutes), (int)seconds];
}

@end
