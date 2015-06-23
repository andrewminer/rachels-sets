//
//  RSModel.m
//  rachels-sets
//
//  Created by Andrew Miner on 10/18/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

#import "RSModel.h"
#import "RSModel_Protected.h"

// Constants ///////////////////////////////////////////////////////////////////////////////////////////////////////////

NSString *RSModelChangedNotification = @"RSModelChangedNotification";

// Public Implementation ///////////////////////////////////////////////////////////////////////////////////////////////

@implementation RSModel

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:nil name:nil object:self];
}

// Public Methods //////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) addObserver:(id<RSModelObserver>)observer {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(modelChanged:)
        name:RSModelChangedNotification object:self];
}

- (void) removeObserver:(id<RSModelObserver>)observer {
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:RSModelChangedNotification object:self];
}

// Protected Methods ///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) postUpdatedNotification {
    [self postUpdatedNotificationWithUserInfo:nil];
}

- (void) postUpdatedNotificationWithUserInfo:(NSDictionary*)userInfo {
    NSNotification *notification = [NSNotification notificationWithName:RSModelChangedNotification
        object:self userInfo:userInfo];
    [[NSNotificationQueue defaultQueue] enqueueNotification:notification postingStyle:NSPostWhenIdle];
}

@end
