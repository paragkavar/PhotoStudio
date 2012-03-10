//
//  ImageElement.m
//  PhotoStudio
//
//  Created by Xavier BENAVENT on 3/9/12.
//  Copyright (c) 2012 LECB 2. All rights reserved.
//

#import "ImageElement.h"

@implementation ImageElement

@synthesize imageView=_imageView;

- (id)initWithFrame:(CGRect)frame andImage:(NSString *)imageName
{
    self = [super initWithFrame:frame];
    if (self) {                
        //Add the imageView as a subview and size it to the same size than the view (self). To do that we get the view size from the CGRect frame passed to create the view
        
        //Create the image view
        self.imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        
        //Add the imageview as a subview (We do not subclass a UIImageView due to the problems with the drawRect: method9
        [self addSubview:self.imageView];
        
        //Set the image view size to the same as self
        self.imageView.frame=CGRectMake(0, 0, frame.size.width, frame.size.height); 
        
        //Set the content mode to maintain the image aspect ratio
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super initWithCoder:aDecoder]) {
        
        //Get the imageView
        self.imageView=[aDecoder decodeObjectForKey:@"ImageElement.imageView"];
        
        //Set the image view size to the same as self
        self.frame=CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.width, self.imageView.frame.size.height); //VERY IMPORTANT to restore the self.frame
                
        //Add the imageView to the topView
        [self addSubview:self.imageView];
        
        //Set center and transform. We use 2 aux properties to store temporaly the values of center and transform because they are decoded in the superclass ElementView
        self.center=self.auxCenter;
        self.transform=self.auxTransform;
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.imageView forKey:@"ImageElement.imageView"];
}

@end
