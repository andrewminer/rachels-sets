//
//  RSRoundRectView.h
//  rachels-sets
//
//  Created by Andrew Miner on 10/22/13.
//  Copyright (c) 2013 Andrew Miner. All rights reserved.
//

// Public Interface ////////////////////////////////////////////////////////////////////////////////////////////////////

@interface RSRoundRectView : UIView

@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, assign) CGFloat borderThickness;

@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic, strong) UIColor *fillColor;

@end
