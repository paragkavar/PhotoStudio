//
//  EditProjectSTVC.m
//  PhotoStudio
//
//  Created by Xavier BENAVENT on 3/7/12.
//  Copyright (c) 2012 LECB 2. All rights reserved.
//

#import "EditProjectSTVC.h"

@interface EditProjectSTVC() <UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *title;
@property (weak, nonatomic) IBOutlet UITextField *author;
@property (weak, nonatomic) IBOutlet UITextField *creationDate;
@property (weak, nonatomic) IBOutlet UITextView *details;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITableViewCell *imageCell;

@property (nonatomic, strong) UIPopoverController *myPopoverController;

- (void)textViewButtonDidTap;
- (void)handleTap;
- (void)showAlertView;
- (void)showImagePicker;

@end

@implementation EditProjectSTVC

@synthesize delegate=_delegate;
@synthesize editingProject=_editingProject;

@synthesize title;
@synthesize author;
@synthesize creationDate;
@synthesize details;
@synthesize imageView;
@synthesize imageCell;

@synthesize myPopoverController=_myPopoverController;


static int imagePickerViewsCount=0;


#pragma mark - UIAlertViewDelegate -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self showImagePicker];
}


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

- (void)showAlertView
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"First time loading Photo Library" message:@"it will take some seconds" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)showImagePicker
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

- (void)handleTap
{
    if (imagePickerViewsCount==0) {
        [self showAlertView];
        imagePickerViewsCount++;
    }
    else {
        [self showImagePicker];
    }
}

- (IBAction)saveProjectButtonDidTap:(id)sender 
{
    //Create project from fields
    self.editingProject.title=self.title.text;
    self.editingProject.author=self.author.text;
    self.editingProject.details=self.details.text;
    self.editingProject.resultPicture=self.imageView.image;
    
    //Call delegate
    [self.delegate projectDidFinishEditing:self.editingProject];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set delegates
    self.title.delegate=self;
    self.author.delegate=self;
    self.details.delegate=self;
    
    //Set data to show
    self.title.text=self.editingProject.title;
    self.author.text=self.editingProject.author;
    self.creationDate.text=self.editingProject.creationDate;
    self.details.text=self.editingProject.details;
    self.imageView.image=self.editingProject.resultPicture;
    
    //Add tap gesture recognizer to the image view
    [self.imageCell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)]];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _delegate=nil;
    _editingProject=nil;
    
    [self setTitle:nil];
    [self setAuthor:nil];
    [self setCreationDate:nil];
    [self setDetails:nil];
    [self setImageView:nil];
    [self setImageCell:nil];
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
