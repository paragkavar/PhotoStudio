//
//  LabelElement.m
//  PhotoStudio
//
//  Created by Xavier BENAVENT on 3/9/12.
//  Copyright (c) 2012 LECB 2. All rights reserved.
//

#import "LabelElement.h"

@implementation LabelElement

@synthesize labelText=_labelText;

- (UILabel *)createLabelWithText:(NSString *)text andFrame:(CGRect)frame
{
    UILabel *label=[[UILabel alloc] initWithFrame:frame];
    label.text=text;
    label.font=[UIFont systemFontOfSize:30];
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment=UITextAlignmentCenter;
    
    return label;
}

- (id)initWithFrame:(CGRect)frame andText:(NSString *)text
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //Set property
        self.labelText=text;
        
        //Create the label
        UILabel *label=[self createLabelWithText:text andFrame:frame];
        
        //Set the LabelElement frame to the label frame
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, label.frame.size.width, label.frame.size.height);
        
        //Add as a subview
        [self addSubview:label];  
        
        //Add double tap recognizer
        UITapGestureRecognizer *doubleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired=2;
        [self addGestureRecognizer:doubleTap];        
    }
    return self;
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)gesture
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Edit Text" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    alertView.alertViewStyle=UIAlertViewStylePlainTextInput;
    alertView.tag=102;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==102) {
        if (buttonIndex==0) { //OK
            
            //Set property
            self.labelText=[[alertView textFieldAtIndex:0] text];
            
            //Set label in view text
            [(UILabel *)[self.subviews objectAtIndex:0] setText:self.labelText];
        }
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super initWithCoder:aDecoder]) {
        
        //Get the text
        _labelText=[aDecoder decodeObjectForKey:@"LabelElement.labelText"];
        
        if ([_labelText isEqualToString:@"Void Label"]) { //The label is added to the other view
            
            //Set frame to zero to see nothing
            self.frame=CGRectZero;
        }
        else {
            //Create label with the property text
            UILabel *label=[self createLabelWithText:_labelText andFrame:CGRectMake(0, 0, 150, 40)];
            
            //Set the LabelElement frame to the label frame
            self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, label.frame.size.width, label.frame.size.height);
            
            //Add as a subview
            [self addSubview:label];
            
            //Set center and transform. We use 2 aux properties to store temporaly the values of center and transform because they are decoded in the superclass ElementView
            self.center=self.auxCenter;
            self.transform=self.auxTransform;
            
            //Add double tap recognizer
            UITapGestureRecognizer *doubleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
            doubleTap.numberOfTapsRequired=2;
            [self addGestureRecognizer:doubleTap];             
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.labelText forKey:@"LabelElement.labelText"];
}


@end
