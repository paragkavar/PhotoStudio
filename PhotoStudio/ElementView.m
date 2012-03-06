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
        
        /*
        //Add rotation gesture recognizer
        [view addGestureRecognizer:[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)]];
        
        //Add pinch gesture recognizer
        [view addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)]]; 
         */
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
        (gesture.state == UIGestureRecognizerStateEnded)) {
        
        //Get the active element because this gesture is recognized by the superview
        [self.delegate getActiveViewForView:self.superview].transform=CGAffineTransformRotate([self.delegate getActiveViewForView:self.superview].transform, gesture.rotation);
    }
    
    [gesture setRotation:0.0];
}

- (void)handlePinch:(UIPinchGestureRecognizer*)gesture 
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        [self.delegate getActiveViewForView:self.superview].transform=CGAffineTransformScale([self.delegate getActiveViewForView:self.superview].transform, gesture.scale, gesture.scale);
        NSLog(@"Scale: %f",gesture.scale);
    }
    
    [gesture setScale:1.0];
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

#pragma mark NSCoding methods -

- (id)initWithCoder:(NSCoder *)aDecoder //Remember thet the delegate is not encoded
{
    if (self=[super init]) { //Maybe init only?
        self.active=[aDecoder decodeBoolForKey:@"ElementView.active"];
        self.imageView=[aDecoder decodeObjectForKey:@"ElementView.imageView"];
        
        //VERY IMPORTANT TO DO THAT
        [self addSubview:self.imageView];
        
        self.imageView.frame=CGRectMake(0, 0, 100, 100); 
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
        
        //Add tap gesture recognizer for activing and deactiving the view
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool:self.active forKey:@"ElementView.active"];
    [aCoder encodeObject:self.imageView forKey:@"ElementView.imageView"];
}




@end
