//
//  RSModel.h
//  rachels-sets
//
//  Created by Andrew Miner on 10/18/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

@protocol RSModelObserver;

// Constants ///////////////////////////////////////////////////////////////////////////////////////////////////////////

extern NSString *RSModelChangedNotification;

// Public Interface ////////////////////////////////////////////////////////////////////////////////////////////////////

@interface RSModel : NSObject

- (void) addObserver:(id<RSModelObserver>)observer;

- (void) removeObserver:(id<RSModelObserver>)observer;

@end

// Observer Protocol ///////////////////////////////////////////////////////////////////////////////////////////////////

@protocol RSModelObserver <NSObject>

- (void) modelChanged:(NSNotification*)notification;

@end
