//
//  NewProjectSTVC.m
//  PhotoStudio
//
//  Created by Xavier BENAVENT on 3/7/12.
//  Copyright (c) 2012 LECB 2. All rights reserved.
//

#import "NewProjectSTVC.h"

@interface NewProjectSTVC() <UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *title;
@property (weak, nonatomic) IBOutlet UITextField *author;
//@property (weak, nonatomic) IBOutlet UITextField *creationDate;
@property (weak, nonatomic) IBOutlet UITextView *details;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITableViewCell *imageCell;

@property (nonatomic, strong) UIPopoverController *myPopoverController;

- (void)textViewButtonDidTap;

@end


@implementation NewProjectSTVC

@synthesize delegate=_delegate;
@synthesize title;
@synthesize author;
//@synthesize creationDate;
@synthesize details;
@synthesize imageView;
@synthesize imageCell;

@synthesize myPopoverController=_myPopoverController;


#pragma mark - UIImagePicker delegate methods -

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    //Dismiss UIImagePickerController
    [self.myPopoverController dismissPopoverAnimated:YES];
    
    //Add image
    //self.imageView.image=[self adaptImage:image forSize:CGSizeMake(100, 80)];
    self.imageView.image=[ImageHelper getImageAndReduceImage:image toCropInView:self.imageView];
}

#pragma mark - Private methods -

- (void)textViewButtonDidTap
{
    //Dismiss the text view when tapping the custom button cretaed
    [self.details resignFirstResponder];
}


- (void)handleTap
{
    //Call UIImagePicker
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]==YES) 
    {
        //Create UIImagePickerController
        UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
        
        //With both to these values we will be able to access any picture at the iPad
        mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        mediaUI.mediaTypes=[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        //Hides the controls for moving & scaling pictures, or for trimming movies. To instead show the controls, use YES.
        mediaUI.allowsEditing = NO;
        
        //Set delegate
        mediaUI.delegate = self;
        
        ////Create the popover controller and show the UIImagePicker from it (mandatory in the iPad)
        self.myPopoverController=[[UIPopoverController alloc] initWithContentViewController:mediaUI];
        [self.myPopoverController presentPopoverFromRect:CGRectMake(100, 100, 200, 200) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}


- (IBAction)createProjectButtonDidTap:(id)sender 
{
    //Create project from fields
    Project *newProject=[[Project alloc] initWithTitle:self.title.text author:self.author.text];
    //newProject.title=self.title.text;
    //newProject.author=self.author.text;
    //newProject.creationDate=self.creationDate.text;
    newProject.details=self.details.text;
    newProject.resultPicture=self.imageView.image;
    //newProject.elements=[NSMutableArray arrayWithCapacity:1];
    
    /*
    // Generate random string of 10 that will be the UPID to store this project
    int randomStringLength=10;
    NSString *chars = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:randomStringLength];
    srand(time(NULL));
    for (int i=0; i<randomStringLength; i++) {
        [randomString appendFormat:@"%c",[chars characterAtIndex:rand()%[chars length]]];
    }
    
    newProject.UPID=randomString;
     */
    
    //Call delegate
    [self.delegate projectDidCreate:newProject];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title.delegate=self;
    self.author.delegate=self;
    self.details.delegate=self;
    
    /*
    //Set current date and time
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    NSDateFormatter *timeFormatter=[[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm"];
    self.creationDate.text=[NSString stringWithFormat:@"%@  %@",[dateFormatter stringFromDate:[NSDate date]],[timeFormatter stringFromDate:[NSDate date]]];
     */
    
    //Add tap gesture recognizer to the image view
    [self.imageCell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)]];
}

- (void)viewDidUnload
{
    _delegate=nil;
    [self setTitle:nil];
    [self setAuthor:nil];
    //[self setCreationDate:nil];
    [self setDetails:nil];
    [self setImageView:nil];
    [self setImageCell:nil];
    _myPopoverController=nil;
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
