//
//  ImageHelper.h
//  PhotoStudio
//
//  Created by Xavier BENAVENT on 3/8/12.
//  Copyright (c) 2012 LECB 2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageHelper : NSObject

+ (UIImage *)getImageAndReduceImage:(UIImage *)sourceImage toCropInView:(UIView *)destinationSquareView;


@end
