//
//  ImageHelper.m
//  PhotoStudio
//
//  Created by Xavier BENAVENT on 3/8/12.
//  Copyright (c) 2012 LECB 2. All rights reserved.
//

#import "ImageHelper.h"

@implementation ImageHelper


/*
- (IBAction)buttonDidTap:(id)sender 
{
    //Modify the image view dimensions and position to be fit and centered
    UIImageView *resultImageView=[self getImageViewAndReduceImage:self.sourceImageView.image toCropInView:self.resultView];
    
    // Then add image view as a subview
    [self.resultView addSubview:resultImageView];
}
 */




+ (UIImage *)getImageAndReduceImage:(UIImage *)sourceImage toCropInView:(UIView *)destinationSquareView
{
    //NOTE: This method is for a square result view (width=height)
    
    //GOAL: We want to reduce the size of an image scaling it down to fit in a square view (maintaining proportions)
    
    // 1. Get scale factor
    CGFloat resultSide=destinationSquareView.frame.size.width; //(width=height)
    
    //Calculate the frame acccording to the photo dimensions (max frame: 500x700)
    CGFloat scale;
    
    if (sourceImage.size.width>=sourceImage.size.height) {
        scale=resultSide/sourceImage.size.width;
    }
    else {
        scale=resultSide/sourceImage.size.height;
    }
    
    
    if (sourceImage.size.width<resultSide && sourceImage.size.height<resultSide) {
        scale=1.0;
    }
    
    // 2. Set picture image view frame to be exactly as the picture applying the scale factor
    CGRect rectToDraw=CGRectMake(0, 0, scale*sourceImage.size.width, scale*sourceImage.size.height);
    UIImageView* adaptedImageView=[[UIImageView alloc] initWithFrame:rectToDraw];
    
    // 3. Convert image (reducing size: i.e. load)
    UIGraphicsBeginImageContext(rectToDraw.size); // this will crop
    //Draw image
	[sourceImage drawInRect:rectToDraw];
	
	UIImage* adaptedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    // 4. Set picture image view center to be at the center of the frame
    adaptedImageView.center=CGPointMake(resultSide/2, resultSide/2);
    
    // 5. Set the reduced image to the adapted image view
    adaptedImageView.image=adaptedImage;
    
    return adaptedImage;
}



@end
