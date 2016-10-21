//
//  RSCardView.h
//  rachels-sets
//
//  Created by Andrew Miner on 10/8/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

@class RSCard;
@protocol RSCardViewDelegate;

// Public Interface ////////////////////////////////////////////////////////////////////////////////////////////////////

@interface RSCardView : UIControl

@property (nonatomic, weak) id<RSCardViewDelegate> delegate;

- (id) initWithDelegate:(id<RSCardViewDelegate>)delegate;

- (void) refresh;

@end

// Delegate Protocol ///////////////////////////////////////////////////////////////////////////////////////////////////

@protocol RSCardViewDelegate <NSObject>
@optional

- (RSCard*) cardForCardView:(RSCardView*)cardView;

- (void) cardViewTouched:(RSCardView*)cardView;

@end
