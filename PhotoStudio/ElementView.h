//
//  ElementView.h
//  PhotoStudio
//
//  Created by Xavier BENAVENT on 3/6/12.
//  Copyright (c) 2012 LECB 2. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ElementView;
@protocol ElementViewDelegate
- (void)viewDidActive:(ElementView *)sender;
- (void)viewDidInactive:(ElementView *)sender;
- (ElementView *)getActiveViewForView:(UIView *)superView;
@end


@interface ElementView:UIView <NSCoding>

@property (nonatomic,weak) id <ElementViewDelegate> delegate;
@property (nonatomic, readwrite) BOOL active;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic, strong) NSString *labelText;

- (id)initWithFrame:(CGRect)frame andImage:(NSString *)imageName;

- (CGPoint)getCenterInBetweenLimits;
- (BOOL)isElementBetweenLimits;

@end
