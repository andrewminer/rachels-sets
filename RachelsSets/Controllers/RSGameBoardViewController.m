//
//  RSGameBoardViewController.m
//  rachels-sets
//
//  Created by Andrew Miner on 10/14/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

#import "RSGameBoardViewController.h"

#import "RSCard.h"
#import "RSCardView.h"
#import "RSCardViewController.h"
#import "RSGameBoard.h"
#import "RSGameBoardView.h"

// Private Interface ///////////////////////////////////////////////////////////////////////////////////////////////////

@interface RSGameBoardViewController () <RSCardViewControllerDelegate, RSGameBoardViewDelegate, RSModelObserver>

@property (nonatomic, strong) NSMutableDictionary *cardControllers;

@property (nonatomic, strong, readonly) RSGameBoardView* gameBoardView;

@end

// Public Implementation ///////////////////////////////////////////////////////////////////////////////////////////////

@implementation RSGameBoardViewController

- (id) initWithGameBoard:(RSGameBoard*)gameBoard andDelegate:(id<RSGameBoardViewControllerDelegate>)delegate {
    if ((self = [super initWithNibName:nil bundle:nil])) {
        self.delegate = delegate;
        self.gameBoard = gameBoard;

        self.cardControllers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (RSGameBoardView*) gameBoardView {
    return (RSGameBoardView*) self.view;
}

// Public Methods //////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) refresh:(BOOL)animated {
    NSArray *allCards = [self.gameBoard allCards];
    NSMutableArray *cardsToAdd = [NSMutableArray arrayWithCapacity:allCards.count];
    NSMutableDictionary *cardsToRemove = [NSMutableDictionary dictionaryWithDictionary:self.cardControllers];
    BOOL updateLayout = (allCards.count != self.gameBoardView.subviews.count);

    for (NSInteger index = 0; index < allCards.count; index++) {
        RSCard *card = allCards[index];
        if ((id) card == [NSNull null]) continue;

        RSCardViewController *controller = [self.cardControllers objectForKey:card.name];
        if (! controller) {
            controller = [[RSCardViewController alloc] initWithCard:card andDelegate:self];
            [self addChildViewController:controller];
            [self.cardControllers setObject:controller forKey:card.name];

            RSCardView *cardView = (RSCardView*) controller.view;
            cardView.tag = index;
            [cardsToAdd addObject:cardView];
        }
        [cardsToRemove removeObjectForKey:card.name];
    }

    for (RSCardViewController *controller in [cardsToRemove allValues]) {
        controller.view.tag = NSNotFound;
        [self.cardControllers removeObjectForKey:controller.card.name];
        [controller removeFromParentViewController];
        [self.gameBoardView removeCard:((RSCardView*)controller.view) animated:animated];
    }

    if (updateLayout) {
        [self.gameBoardView adjustCardPositions];
        
        for (NSInteger index = 0; index < allCards.count; index++) {
            RSCard *card = allCards[index];
            if ((id)card == [NSNull null]) continue;
            
            RSCardViewController *controller = [self.cardControllers objectForKey:card.name];
            if (!controller) continue;

            RSCardView *cardView = (RSCardView*) controller.view;
            [self.gameBoardView moveCard:cardView toIndex:index animated:YES];
        }
    }

    for (RSCardView *cardView in cardsToAdd) {
        [self.gameBoardView dealCard:cardView atIndex:cardView.tag animated:animated];
    }
}

// UIViewController Methods ////////////////////////////////////////////////////////////////////////////////////////////

- (void) loadView {
    RSGameBoardView *gameBoardView = [[RSGameBoardView alloc] initWithDelegate:self];
    self.view = gameBoardView;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.gameBoard addObserver:self];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.gameBoard removeObserver:self];
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration {
    [self.gameBoardView adjustCardPositions];
}

// RSCardViewControllerDelegate Methods ////////////////////////////////////////////////////////////////////////////////

- (void) cardViewControllerCardTouched:(RSCardViewController*)controller {
    [self.delegate gameBoard:self cardTouched:controller.card];
}

// RSGameBoardViewDelegate Methods /////////////////////////////////////////////////////////////////////////////////////

- (NSInteger) cardCountOnGameBoard:(RSGameBoardView*)gameBoardView {
    return [self.gameBoard allCards].count;
}

- (RSCard*) cardAtIndex:(NSInteger)index {
    return [self.gameBoard.allCards objectAtIndex:index];
}

- (void) gameBoardTouched:(RSGameBoardView*)gameBoardView {
    [self.delegate gameBoardTouched:self];
}

// RSModelObserver Methods /////////////////////////////////////////////////////////////////////////////////////////////

- (void) modelChanged:(NSNotification*)notification {
    BOOL animated = [@(NO) isEqual:notification.userInfo[@"animated"]] ? NO : YES;
    [self refresh:animated];
}

@end
