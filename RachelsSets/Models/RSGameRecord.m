//
//  RSGameRecord.m
//  rachels-sets
//
//  Created by Andrew Miner on 10/27/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

#import "RSGameRecord.h"

// Constants ///////////////////////////////////////////////////////////////////////////////////////////////////////////

static NSString *BEST_TIME = @"best-time";

static NSString *LAST_TIME = @"last-time";

// Private Interface ///////////////////////////////////////////////////////////////////////////////////////////////////

@interface RSGameRecord ()

@property (nonatomic, assign) NSTimeInterval bestTime;

@property (nonatomic, assign) NSTimeInterval lastTime;

@end

// Public Implementation ///////////////////////////////////////////////////////////////////////////////////////////////

@implementation RSGameRecord

- (id) init {
    if ((self = [super init])) {
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return self;
}

- (void) dealloc {
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSTimeInterval) bestTime {
    return (NSTimeInterval) [[NSUserDefaults standardUserDefaults] doubleForKey:BEST_TIME];
}

- (void) setBestTime:(NSTimeInterval)bestTime {
    [[NSUserDefaults standardUserDefaults] setDouble:bestTime forKey:BEST_TIME];
}

- (NSTimeInterval) lastTime {
    return (NSTimeInterval) [[NSUserDefaults standardUserDefaults] doubleForKey:LAST_TIME];
}

- (void) setLastTime:(NSTimeInterval)lastTime {
    [[NSUserDefaults standardUserDefaults] setDouble:lastTime forKey:LAST_TIME];
}

// Public Methods //////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) recordTime:(NSTimeInterval)time {
    self.lastTime = time;

    if (time < self.bestTime || self.bestTime == 0.0) {
        self.bestTime = time;
    }
}

@end
