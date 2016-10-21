//
//  RSModel_Protected.h
//  rachels-sets
//
//  Created by Andrew Miner on 10/18/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

#import "RSModel.h"

@interface RSModel ()

- (void) postUpdatedNotification;

- (void) postUpdatedNotificationWithUserInfo:(NSDictionary*)userInfo;

@end
