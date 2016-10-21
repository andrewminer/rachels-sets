//
//  RSMainMenuView.h
//  rachels-sets
//
//  Created by Andrew Miner on 10/18/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

@protocol RSMainMenuViewDelegate;

// Public Interface ////////////////////////////////////////////////////////////////////////////////////////////////////

@interface RSMainMenuView : UIView

@property (nonatomic, weak) id<RSMainMenuViewDelegate> delegate;

- (id) initWithDelegate:(id<RSMainMenuViewDelegate>)delegate;

@end

// Delegate Protocol ///////////////////////////////////////////////////////////////////////////////////////////////////

@protocol RSMainMenuViewDelegate <NSObject>
@optional

- (void) mainMenuViewStartButtonTouched:(RSMainMenuView*)mainMenuView;

@end