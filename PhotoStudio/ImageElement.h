//
//  ImageElement.h
//  PhotoStudio
//
//  Created by Xavier BENAVENT on 3/9/12.
//  Copyright (c) 2012 LECB 2. All rights reserved.
//

#import "ElementView.h"

@interface ImageElement : ElementView <NSCoding>

@property (nonatomic,strong) UIImageView *imageView;

- (id)initWithFrame:(CGRect)frame andImage:(NSString *)imageName;

@end
