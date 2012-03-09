//
//  ElementView.m
//  PhotoStudio
//
//  Created by Xavier BENAVENT on 3/6/12.
//  Copyright (c) 2012 LECB 2. All rights reserved.
//

#import "ElementView.h"

@interface ElementView()
@end


@implementation ElementView

@synthesize delegate=_delegate;
@synthesize active=_active;
@synthesize imageView=_imageView;

#pragma mark - Setters & getters

//By implementing this setter, we redraw the view every time the element is activated or deactivated. It will add/remove the red frame.
-(void)setActive:(BOOL)active
{
    if (_active != active) {
        _active=active;
        [self setNeedsDisplay];
    }
}


#pragma mark - Initializers -

- (id)initWithFrame:(CGRect)frame //This is the designated initializer (Note: self=[super...])
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andImage:(NSString *)imageName//This is a convenience initializer (Note: self=[self...])
{
    self = [self initWithFrame:frame];
    if (self) {
        //Set to non-active
        self.active=NO;
        self.backgroundColor=[UIColor clearColor];
                
        //Add the imageView as a subview and size it to the same size than the view (self). To do that we get the view size from the CGRect frame passed to create the view
        self.imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        [self addSubview:self.imageView];
        self.imageView.frame=CGRectMake(0, 0, frame.size.width, frame.size.height); 
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
        
        //Add tap gesture recognizer for activing and deactiving the view
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
    }
    return self;
}

#pragma mark - Gesture recognizer handlers -

//Pan and Tap are handled together, and Rotation and Pinch individually

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    //Toggle property. It will force to redraw the view
    self.active=!self.active;
    
    if (self.active) {
        [self.delegate viewDidActive:self];
    }
    else {
        [self.delegate viewDidInactive:self];
    }
    
    //Draw again. To show/hide the red frame?
    [self setNeedsDisplay];
}


- (void)handleRotation:(UIRotationGestureRecognizer*)gesture 
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) 
    {
        //Get active view
        ElementView *activeView=[self.delegate getActiveViewForView:self.superview];
        
        //Save current transform
        CGAffineTransform currentTransform=activeView.transform;
        
        //Apply rotation
        [self.delegate getActiveViewForView:self.superview].transform=CGAffineTransformRotate([self.delegate getActiveViewForView:self.superview].transform, gesture.rotation);
        
        //Return to current orientation if it is outside limits
        if (![activeView isElementBetweenLimits]) {
            activeView.transform=currentTransform;
        }
    }
    
    [gesture setRotation:0.0];
}

- (void)handlePinch:(UIPinchGestureRecognizer*)gesture 
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) 
    {
        //Get active view
        ElementView *activeView=[self.delegate getActiveViewForView:self.superview];
        
        //Save current transform
        CGAffineTransform currentTransform=activeView.transform;
        
        //Apply pinch
        activeView.transform=CGAffineTransformScale(activeView.transform, gesture.scale, gesture.scale);
        
        //Return to current size if it is outside limits
        if (![activeView isElementBetweenLimits]) {
            activeView.transform=currentTransform;
        }
    }
    
    [gesture setScale:1.0];
}

- (BOOL)isElementBetweenLimits
{    
    //Check x axis right limit
    if (self.frame.origin.x + self.frame.size.width > self.superview.bounds.size.width) return NO;
    
    //Check x axis left limit
    if (self.frame.origin.x <0) return NO;
    
    //Check y axis upper limit
    if (self.frame.origin.y <0) return NO;
    
    //Check y axis lower limit
    if (self.frame.origin.y + self.frame.size.height > self.superview.bounds.size.height) return NO;
    
    return YES;
}


- (CGPoint)getCenterInBetweenLimits
{
    //Get the center point for the view
    CGPoint center=self.center;
    
    //Check x axis right limit
    if (self.frame.origin.x + self.frame.size.width > self.superview.bounds.size.width) center.x=(self.superview.bounds.size.width + self.frame.origin.x)/2;
    
    //Check x axis left limit
    if (self.frame.origin.x <0) center.x=self.frame.size.width/2;
    
    //Check y axis upper limit
    if (self.frame.origin.y <0) center.y=self.frame.size.height/2;
    
    //Check y axis lower limit
    if (self.frame.origin.y + self.frame.size.height > self.superview.bounds.size.height) center.y=(self.superview.bounds.size.height + self.frame.origin.y)/2;
    
    return center;
}


#pragma mark - Draw methods -

- (void)drawRect:(CGRect)rect
{
    if (self.active) {        
        //Draw the frame
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 3.0);
        [[UIColor redColor] setStroke];
        CGContextBeginPath(context);
        CGContextAddRect(context, self.bounds);
        CGContextStrokePath(context);
    }
}

#pragma mark - NSCoding methods -

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[[ElementView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) andImage:nil]) //This is the key element: to allocate the ElementView object. It means that we do not actually archive/unarchive the ElementView object, we do that only with the center position and the transform properties.
    {
        //Get the imageView
        self.imageView=[aDecoder decodeObjectForKey:@"Element.imageView"];
        
        //Add the imageView to the topView
        [self addSubview:self.imageView];
        
        //Get the center position
        CGFloat x=[aDecoder decodeFloatForKey:@"Element.center.x"];
        CGFloat y=[aDecoder decodeFloatForKey:@"Element.center.y"];
        
        self.center=CGPointMake(x, y);
        
        //Get the transform values
        CGFloat a=[aDecoder decodeFloatForKey:@"Element.transform.a"];
        CGFloat b=[aDecoder decodeFloatForKey:@"Element.transform.b"];
        CGFloat c=[aDecoder decodeFloatForKey:@"Element.transform.c"];
        CGFloat d=[aDecoder decodeFloatForKey:@"Element.transform.d"];
        CGFloat tx=[aDecoder decodeFloatForKey:@"Element.transform.tx"];
        CGFloat ty=[aDecoder decodeFloatForKey:@"Element.transform.ty"];
        
        self.transform=CGAffineTransformMake(a, b, c, d, tx, ty);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.imageView forKey:@"Element.imageView"];
    
    [aCoder encodeFloat:self.center.x forKey:@"Element.center.x"];
    [aCoder encodeFloat:self.center.y forKey:@"Element.center.y"];
    
    [aCoder encodeFloat:self.transform.a forKey:@"Element.transform.a"];
    [aCoder encodeFloat:self.transform.b forKey:@"Element.transform.b"];
    [aCoder encodeFloat:self.transform.c forKey:@"Element.transform.c"];
    [aCoder encodeFloat:self.transform.d forKey:@"Element.transform.d"];
    [aCoder encodeFloat:self.transform.tx forKey:@"Element.transform.tx"];
    [aCoder encodeFloat:self.transform.ty forKey:@"Element.transform.ty"];
}


@end
