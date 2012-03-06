//
//  Element.m
//  PhotoStudio
//
//  Created by Xavier BENAVENT on 3/4/12.
//  Copyright (c) 2012 LECB 2. All rights reserved.
//

#import "Element.h"

@implementation Element

@synthesize topView=_topView;
@synthesize frontView=_frontView;
@synthesize fileName=_fileName;

#pragma  mark - NSCoding Methods -

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) 
    {
        //The problem here is that we cannot subclass a UIImageView because I don't know how to override drawRect. Then the solution adopted is to subclass a UIView (ElementView class) and add a @property of type UIImageView. By doing that we have to manually add this UIImageView as a subview of the ElementView class (subclass of UIView).
        
        //
        //topView
        //
        //Allocate a new ElementView and init with the standard frame
        self.topView=[[ElementView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) andImage:nil];
        
        //Get the imageView
        self.topView.imageView=[aDecoder decodeObjectForKey:@"Element.topView.imageView"];
        
        //Add the imageView to the topView
        [self.topView addSubview:self.topView.imageView];
        
        //Get the center position
        CGFloat x=[aDecoder decodeFloatForKey:@"Element.topView.center.x"];
        CGFloat y=[aDecoder decodeFloatForKey:@"Element.topView.center.y"];
        
        self.topView.center=CGPointMake(x, y);
        
        //Get the transform values
        CGFloat a=[aDecoder decodeFloatForKey:@"Element.topView.transform.a"];
        CGFloat b=[aDecoder decodeFloatForKey:@"Element.topView.transform.b"];
        CGFloat c=[aDecoder decodeFloatForKey:@"Element.topView.transform.c"];
        CGFloat d=[aDecoder decodeFloatForKey:@"Element.topView.transform.d"];
        CGFloat tx=[aDecoder decodeFloatForKey:@"Element.topView.transform.tx"];
        CGFloat ty=[aDecoder decodeFloatForKey:@"Element.topView.transform.ty"];
        
        self.topView.transform=CGAffineTransformMake(a, b, c, d, tx, ty);
        
        
        //
        //topView
        //
        //Allocate a new ElementView and init with the standard frame
        self.frontView=[[ElementView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) andImage:nil];
        
        //Get the imageView
        self.frontView.imageView=[aDecoder decodeObjectForKey:@"Element.frontView.imageView"];
        
        //Add the imageView to the topView
        [self.frontView addSubview:self.frontView.imageView];
        
        //Get the center position
        x=[aDecoder decodeFloatForKey:@"Element.frontView.center.x"];
        y=[aDecoder decodeFloatForKey:@"Element.frontView.center.y"];
        
        self.frontView.center=CGPointMake(x, y);
        
        //Get the transform values
        a=[aDecoder decodeFloatForKey:@"Element.frontView.transform.a"];
        b=[aDecoder decodeFloatForKey:@"Element.frontView.transform.b"];
        c=[aDecoder decodeFloatForKey:@"Element.frontView.transform.c"];
        d=[aDecoder decodeFloatForKey:@"Element.frontView.transform.d"];
        tx=[aDecoder decodeFloatForKey:@"Element.frontView.transform.tx"];
        ty=[aDecoder decodeFloatForKey:@"Element.frontView.transform.ty"];
        
        self.frontView.transform=CGAffineTransformMake(a, b, c, d, tx, ty);
        
        self.fileName=[aDecoder decodeObjectForKey:@"Element.fileName"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    //topView
    [aCoder encodeObject:self.topView.imageView forKey:@"Element.topView.imageView"];
    
    [aCoder encodeFloat:self.topView.center.x forKey:@"Element.topView.center.x"];
    [aCoder encodeFloat:self.topView.center.y forKey:@"Element.topView.center.y"];
    
    [aCoder encodeFloat:self.topView.transform.a forKey:@"Element.topView.transform.a"];
    [aCoder encodeFloat:self.topView.transform.b forKey:@"Element.topView.transform.b"];
    [aCoder encodeFloat:self.topView.transform.c forKey:@"Element.topView.transform.c"];
    [aCoder encodeFloat:self.topView.transform.d forKey:@"Element.topView.transform.d"];
    [aCoder encodeFloat:self.topView.transform.tx forKey:@"Element.topView.transform.tx"];
    [aCoder encodeFloat:self.topView.transform.ty forKey:@"Element.topView.transform.ty"];
    
    //FrontView
    [aCoder encodeObject:self.frontView.imageView forKey:@"Element.frontView.imageView"];
    
    [aCoder encodeFloat:self.frontView.center.x forKey:@"Element.frontView.center.x"];
    [aCoder encodeFloat:self.frontView.center.y forKey:@"Element.frontView.center.y"];
    
    [aCoder encodeFloat:self.frontView.transform.a forKey:@"Element.frontView.transform.a"];
    [aCoder encodeFloat:self.frontView.transform.b forKey:@"Element.frontView.transform.b"];
    [aCoder encodeFloat:self.frontView.transform.c forKey:@"Element.frontView.transform.c"];
    [aCoder encodeFloat:self.frontView.transform.d forKey:@"Element.frontView.transform.d"];
    [aCoder encodeFloat:self.frontView.transform.tx forKey:@"Element.frontView.transform.tx"];
    [aCoder encodeFloat:self.frontView.transform.ty forKey:@"Element.frontView.transform.ty"];
    
    //fileName
    [aCoder encodeObject:self.fileName forKey:@"Element.fileName"];
}

@end
