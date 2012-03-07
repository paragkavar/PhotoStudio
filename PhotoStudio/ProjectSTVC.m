//
//  ProjectSTVC.m
//  PhotoStudio
//
//  Created by Xavier BENAVENT on 3/7/12.
//  Copyright (c) 2012 LECB 2. All rights reserved.
//

#import "ProjectSTVC.h"

@interface ProjectSTVC() <UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *title;
@property (weak, nonatomic) IBOutlet UITextField *author;
@property (weak, nonatomic) IBOutlet UITextField *creationDate;
@property (weak, nonatomic) IBOutlet UITextView *details;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITableViewCell *imageCell;

- (void)textViewButtonDidTap;


@end


@implementation ProjectSTVC

@synthesize delegate=_delegate;
@synthesize title;
@synthesize author;
@synthesize creationDate;
@synthesize details;
@synthesize imageView;
@synthesize imageCell;

#pragma mark - Private methods -

- (void)textViewButtonDidTap
{
    //Dismiss the text view when tapping the custom button cretaed
    [self.details resignFirstResponder];
}

- (void)handleTap
{
    //Call picture manager
}

- (IBAction)createProjectButtonDidTap:(id)sender 
{
    //Create project from fields
    Project *newProject=[[Project alloc] init];
    
    
    //Call delegate
    [self.delegate projectDidCreate:newProject];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title.delegate=self;
    self.author.delegate=self;
    //self.creationDate.delegate=self;
    self.details.delegate=self;
    
    //Set current date and time
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    NSDateFormatter *timeFormatter=[[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm"];
    self.creationDate.text=[NSString stringWithFormat:@"%@  %@",[dateFormatter stringFromDate:[NSDate date]],[timeFormatter stringFromDate:[NSDate date]]];
    
    //Add tap gesture recognizer to the image view
    [self.imageCell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)]];
}

- (void)viewDidUnload
{
    _delegate=nil;
    [self setTitle:nil];
    [self setAuthor:nil];
    [self setCreationDate:nil];
    [self setDetails:nil];
    [self setImageView:nil];
    [self setImageCell:nil];
    [super viewDidUnload];
}


#pragma mark - UITextFieldDelegate -

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - UITextViewDelegate -

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    //Create the input accessory view. It will be a custom button
    UIButton *doneButton=[UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame=CGRectMake(0, 0, 320, 40);
    doneButton.backgroundColor=[UIColor colorWithRed:186/255.0 green:222/255.0 blue:251/255.0 alpha:1.0]; //Change color
    [doneButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [doneButton setTitle:@"Pulsar aquí al finalizar edición" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(textViewButtonDidTap) forControlEvents:UIControlEventTouchUpInside];
    
    //Set the text view property to show the custom button
    textView.inputAccessoryView=doneButton;
    
    return YES;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


@end
