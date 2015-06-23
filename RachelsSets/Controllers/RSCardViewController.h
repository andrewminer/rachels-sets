//
//  RSCardViewController.h
//  rachels-sets
//
//  Created by Andrew Miner on 10/18/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

@class RSCard;
@protocol RSCardViewControllerDelegate;

// Public Interface ////////////////////////////////////////////////////////////////////////////////////////////////////

@interface RSCardViewController : UIViewController

@property (nonatomic, strong) RSCard *card;

@property (nonatomic, weak) id<RSCardViewControllerDelegate> delegate;

- (id) initWithCard:(RSCard*)card andDelegate:(id<RSCardViewControllerDelegate>)delegate;

@end

// Delegate Protocol ///////////////////////////////////////////////////////////////////////////////////////////////////

@protocol RSCardViewControllerDelegate <NSObject>
@optional

- (void) cardViewControllerCardTouched:(RSCardViewController*)controller;

@end
