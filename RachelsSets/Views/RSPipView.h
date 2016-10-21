//
//  RSPipView.h
//  rachels-sets
//
//  Created by Andrew Miner on 10/24/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

#import "RSCard.h"

// Public Interface ////////////////////////////////////////////////////////////////////////////////////////////////////

@interface RSPipView : UIView

@property (nonatomic, assign) RSCardColor color;

@property (nonatomic, assign) RSCardFill fill;

@property (nonatomic, assign) RSCardShape shape;

+ (NSArray*) pipViewsForCard:(RSCard*)card;

- (id) initWithColor:(RSCardColor)color fill:(RSCardFill)fill shape:(RSCardShape)shape;

@end
