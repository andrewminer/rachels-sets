//
//  RSCardViewController.m
//  rachels-sets
//
//  Created by Andrew Miner on 10/18/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

#import "RSCardViewController.h"

#import "RSCard.h"
#import "RSCardView.h"

// Private Interface ///////////////////////////////////////////////////////////////////////////////////////////////////

@interface RSCardViewController () <RSCardViewDelegate, RSModelObserver>

@property (nonatomic, strong, readonly) RSCardView *cardView;

@end

// Public Implementation ///////////////////////////////////////////////////////////////////////////////////////////////

@implementation RSCardViewController

- (id) initWithCard:(RSCard*)card andDelegate:(id<RSCardViewControllerDelegate>)delegate {
    if ((self = [super init])) {
        self.card = card;
        self.delegate = delegate;
    }
    return self;
}

- (RSCardView*) cardView {
    return (RSCardView*) self.view;
}

// UIViewController Methods ////////////////////////////////////////////////////////////////////////////////////////////

- (void) loadView {
    self.view = [[RSCardView alloc] initWithDelegate:self];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.card addObserver:self];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.card removeObserver:self];
}

// RSCardViewDelegate Methods //////////////////////////////////////////////////////////////////////////////////////////

- (RSCard*) cardForCardView:(RSCardView*)cardView {
    return self.card;
}

- (void) cardViewTouched:(RSCardView*)cardView {
    [self.delegate cardViewControllerCardTouched:self];
}

// RSModelObserver Methods /////////////////////////////////////////////////////////////////////////////////////////////

- (void) modelChanged:(NSNotification*)notification {
    [self.cardView refresh];
}

@end
