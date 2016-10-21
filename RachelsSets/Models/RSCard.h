//
//  RSCard.h
//  rachels-sets
//
//  Created by Andrew Miner on 10/7/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

#import "RSModel.h"

// Constants ///////////////////////////////////////////////////////////////////////////////////////////////////////////

typedef enum {
    RSCardColorRed,
    RSCardColorGreen,
    RSCardColorBlue,

    RSCardColorCount
} RSCardColor;

typedef enum {
    RSCardCountSingle = 1,
    RSCardCountDouble,
    RSCardCountTriple,

    RSCardCountCount = 3
} RSCardCount;

typedef enum {
    RSCardFillSolid,
    RSCardFillSemi,
    RSCardFillHollow,

    RSCardFillCount
} RSCardFill;

typedef enum {
    RSCardShapeCircle,
    RSCardShapeSquare,
    RSCardShapeTriangle,

    RSCardShapeCount
} RSCardShape;

enum {
    RSCardCardsInValidSet = 3,
};

// Public Interface ////////////////////////////////////////////////////////////////////////////////////////////////////

@interface RSCard : RSModel

@property (nonatomic, assign) RSCardColor color;
@property (nonatomic, assign) RSCardCount count;
@property (nonatomic, assign) RSCardFill fill;
@property (nonatomic, assign) RSCardShape shape;

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, assign, getter=isInHintSet) BOOL inHintSet;
@property (nonatomic, strong, readonly) NSString *pipName;
@property (nonatomic, assign, getter=isSelected) BOOL selected;

- (id) initWithColor:(RSCardColor)color count:(RSCardCount)count fill:(RSCardFill)fill shape:(RSCardShape)shape;

+ (RSCard*) cardWithColor:(RSCardColor)color count:(RSCardCount)count fill:(RSCardFill)fill shape:(RSCardShape)shape;

+ (NSMutableArray*) fullDeck;

- (BOOL) makesSetWith:(RSCard*)second and:(RSCard*)third;

@end

// Helper Extensions Public Interface //////////////////////////////////////////////////////////////////////////////////

@interface NSMutableArray (RSCard)

- (BOOL) isValidSet;

- (RSCard*) removeTopCard;

@end
