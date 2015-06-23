//
//  RSGameRecord.h
//  rachels-sets
//
//  Created by Andrew Miner on 10/27/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

// Public Interface ////////////////////////////////////////////////////////////////////////////////////////////////////

@interface RSGameRecord : NSObject

@property (nonatomic, assign, readonly) NSTimeInterval bestTime;

@property (nonatomic, assign, readonly) NSTimeInterval lastTime;

- (void) recordTime:(NSTimeInterval)time;

@end
