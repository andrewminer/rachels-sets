//
//  RSGameViewController.h
//  rachels-sets
//
//  Created by Andrew Miner on 10/18/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

@class RSGame, RSGameRecord;

// Public Interface ////////////////////////////////////////////////////////////////////////////////////////////////////

@interface RSGameViewController : UIViewController

@property (nonatomic, strong) RSGame *game;

@property (nonatomic, strong) RSGameRecord *record;

- (id) initWithGame:(RSGame*)game;

@end
