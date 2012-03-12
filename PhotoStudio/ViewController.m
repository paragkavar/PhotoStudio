//
//  ViewController.m
//  PhotoStudio
//
//  Created by Xavier BENAVENT on 3/3/12.
//  Copyright (c) 2012 LECB 2. All rights reserved.
//

#import "ViewController.h"



@interface ViewController() <UIAlertViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UIPopoverController *popover;
@property (nonatomic, strong) Project *currentProject;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *frontView;
@property (strong,nonatomic) NSMutableArray *topViewElements;
@property (strong,nonatomic) NSMutableArray *frontViewElements;
@property (weak,nonatomic) ElementView *activeElementInTopView;
@property (weak,nonatomic) ElementView *activeElementInFrontView;
@property (weak, nonatomic) IBOutlet UILabel *titleInView;


- (void)setupCurrentProject;
- (void)setupElement:(Element *)element;
- (void)handlePanInTopView:(UIPanGestureRecognizer *)gesture;
- (void)handlePanInFrontView:(UIPanGestureRecognizer *)gesture;
- (void)loadCurrentProject;

@end




@implementation ViewController

@synthesize popover=_popover;
@synthesize currentProject=_currentProject;
@synthesize titleInView=_titleInView;
@synthesize topView=_topView;
@synthesize frontView=_frontView;
@synthesize topViewElements=_topViewElements;
@synthesize frontViewElements=_frontViewElements;
@synthesize activeElementInTopView=_activeElementInTopView;
@synthesize activeElementInFrontView=_activeElementInFrontView;


#pragma mark - IBAction methods -


- (IBAction)trashDidTap
{
    if (self.activeElementInTopView || self.activeElementInFrontView) {
        //Show alert view with delete confirmation
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"ATENTION" message:@"The selected element will be deleted" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        alertView.tag=100;
        [alertView show];
    }
}

- (IBAction)addLabelButtonDidTap
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"New Label Text:" message:nil delegate:self cancelButtonTitle:@"Top" otherButtonTitles:@"Front", nil];
    alertView.alertViewStyle=UIAlertViewStylePlainTextInput;
    alertView.tag=101;
    [alertView show];
    
}


#pragma mark - Segue methods -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Save current project
    [self.currentProject save];
    
    //Get the pointer to the popover to dismiss it in the future
    if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) 
    {
        self.popover=[(UIStoryboardPopoverSegue *)segue popoverController];
    }
    
    if ([segue.identifier isEqualToString:@"Elements"]) 
    {
        UINavigationController *navigationController=(UINavigationController *)segue.destinationViewController;
        GroupsTableViewController *groupsTableViewController=(GroupsTableViewController *)navigationController.topViewController;
        groupsTableViewController.mainViewController=self;
    }
    
    if ([segue.identifier isEqualToString:@"Projects"]) {
        UINavigationController *navigationController=(UINavigationController *)segue.destinationViewController;
        ProjetcsTableViewController *projectsTableViewController=(ProjetcsTableViewController *)navigationController.topViewController;
        projectsTableViewController.delegate=self;
    }
}

#pragma mark - Private Methods -


- (void)loadCurrentProject
{
    //Load current project key from NSUserDEfaults
    NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
    
    //Reset for testing 
    //[userDefaults setObject:@"" forKey:@"ViewController.currentProjectUPID"];
    
    //self.currentProjectKey=[userDefaults objectForKey:@"ViewController.currentProject"];
    NSString *currentprojectUPID=[userDefaults objectForKey:@"ViewController.currentProjectUPID"];
    
    if ([currentprojectUPID length]<1) { //Initial situation with no current project
        
        //Create new project and assign to current
        self.currentProject=[[Project alloc] initForDefaultProject];
                        
        //Save it
        [self.currentProject save];
        
        //Save the current project UPID as the current UPID to NSUserDefaults
        [userDefaults setObject:self.currentProject.UPID forKey:@"ViewController.currentProjectUPID"];
        
        //Create an array with the created UPID and save it to NSUserDefaults
        NSArray *UPIDs=[NSArray arrayWithObject:self.currentProject.UPID];
        [userDefaults setObject:UPIDs forKey:@"UPIDs"];
        [userDefaults synchronize];
        
        //NOTE: Things stored in NSUserDEfaults:
        // 1. @"ViewController.currentProjectUPID"
        // 2. @"UPIDs"
        // 3. Each project where the NSUserDefaults key is the UPID
    }
    else {
        self.currentProject=[Project loadProjectWithUPID:currentprojectUPID];
    }
    
    //Project show and setup
    [self setupCurrentProject];
}


- (void)setupCurrentProject
{
    //Show title and elements of the current project
    self.titleInView.text=self.currentProject.UPID;
    
    //Reset arrays
    [self.topViewElements removeAllObjects];
    [self.frontViewElements removeAllObjects];
    
    //Reset top and front views
    for (UIView *view in self.topView.subviews) {
        [view removeFromSuperview];
    }
    for (UIView *view in self.frontView.subviews) {
        [view removeFromSuperview];
    }
    
    //Add views
    for (Element *element in self.currentProject.elements) {
        [self setupElement:element];
    }
}


- (void)setupElement:(Element *)element
{
    //Set the element properties that couldn't be set in the ElementSTVC
    element.topView.delegate=self;
    element.frontView.delegate=self;
    
    //Add element views to top and front arrays
    [self.topViewElements addObject:element.topView];
    [self.frontViewElements addObject:element.frontView];
    
    //Add element to top and front views
    [self.topView addSubview:element.topView];
    [self.frontView addSubview:element.frontView];
    
    //Add pan gesture recognizer to each view for dragging the view
    [element.topView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanInTopView:)]];
    [element.frontView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanInFrontView:)]];
    
    //Add rotation gesture recognizer to each view (but handled in the ElementView)
    [self.topView addGestureRecognizer:[[UIRotationGestureRecognizer alloc] initWithTarget:element.topView action:@selector(handleRotation:)]];
    [self.frontView addGestureRecognizer:[[UIRotationGestureRecognizer alloc] initWithTarget:element.frontView action:@selector(handleRotation:)]]; 
    
    //Add pinch gesture recognizer (but handled in the ElementView)
    [self.topView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:element.topView action:@selector(handlePinch:)]];
    [self.frontView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:element.frontView action:@selector(handlePinch:)]]; 
}


#pragma mark - ProjectsTableViewControllerDelegate -

-(void)projectDidSelect:(Project *)project
{
    //Do actions only if the selected project is not the current one
    if (![project.UPID isEqualToString:self.currentProject.UPID]) {
        
        //Save current project
        [self.currentProject save];
        
        //Update current project
        self.currentProject=project;
        
        //Show current project
        [self setupCurrentProject];
        
        //Save current project UPID to NSUserDefaults to be the project showed when the app is loaded
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        [userDefaults setValue:self.currentProject.UPID forKey:@"ViewController.currentProjectUPID"];
    }
    
    //Dismiss popover
    [self.popover dismissPopoverAnimated:YES];
}


-(BOOL)projectShouldDelete:(Project *)project
{
    if ([project.UPID isEqualToString:self.currentProject.UPID]) {
        
        //Show alert
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Current Project cannot be deleted" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        return NO;
    }
    else return YES;
}

-(void)projectDidDelete:(Project *)project
{
    
}

#pragma mark - ElementViewDelegate methods -

- (void)viewDidActive:(ElementView *)sender
{
    //Deselect all elements in both views
    for (ElementView *aView in self.topViewElements) {
        aView.active=NO;
    }
    for (ElementView *aView in self.frontViewElements) {
        aView.active=NO;
    }
    
    //Get the index number in the array for the element to select and set the active pointer for both views
    if (sender.superview==self.topView) {
        self.activeElementInTopView=sender;
        self.activeElementInFrontView=[self.frontViewElements objectAtIndex:[self.topViewElements indexOfObject:sender]];
    }
    else {
        self.activeElementInFrontView=sender;
        self.activeElementInTopView=[self.topViewElements objectAtIndex:[self.frontViewElements indexOfObject:sender]];
    }
    
    //Active elements
    self.activeElementInTopView.active=YES;
    self.activeElementInFrontView.active=YES;
}

- (void)viewDidInactive:(ElementView *)sender
{
    //Inactive both
    self.activeElementInTopView.active=NO;
    self.activeElementInFrontView.active=NO;
    
    //Set both pointers to inactive
    self.activeElementInTopView=nil;
    self.activeElementInFrontView=nil;
}

- (ElementView *)getActiveViewForView:(UIView *)superView
{
    //Get the active pointer depending on the element superview
    if (superView==self.topView) {
        return self.activeElementInTopView;
    }
    else {
        return self.activeElementInFrontView;
    }
}

#pragma mark - Pan handlers -

- (void)handlePanInTopView:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) 
    {
        //Get translation
        CGPoint translation = [gesture translationInView:self.topView];
        
        //Set new position for the element in each view (top & front)
        self.activeElementInTopView.center=CGPointMake(self.activeElementInTopView.center.x + translation.x, 
                                                       self.activeElementInTopView.center.y + translation.y);
        
        self.activeElementInFrontView.center=CGPointMake(self.activeElementInFrontView.center.x + translation.x, 
                                                         self.activeElementInFrontView.center.y);
        
        //Maintain center in between limits
        self.activeElementInTopView.center=[self.activeElementInTopView getCenterInBetweenLimits];
        self.activeElementInFrontView.center=[self.activeElementInFrontView getCenterInBetweenLimits];
        
        //Reset gesture recognizer
        [gesture setTranslation:CGPointZero inView:self.topView];
    }
}

- (void)handlePanInFrontView:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) 
    {
        
        //Get translation
        CGPoint translation = [gesture translationInView:self.frontView];
        
        //Set new position for the element in each view (top & front)
        self.activeElementInTopView.center=CGPointMake(self.activeElementInTopView.center.x + translation.x, 
                                                       self.activeElementInTopView.center.y);
        
        self.activeElementInFrontView.center=CGPointMake(self.activeElementInFrontView.center.x + translation.x, 
                                                         self.activeElementInFrontView.center.y + translation.y);
        
        //Maintain center in between limits
        self.activeElementInTopView.center=[self.activeElementInTopView getCenterInBetweenLimits];
        self.activeElementInFrontView.center=[self.activeElementInFrontView getCenterInBetweenLimits];
        
        //Reset gesture recognizer
        [gesture setTranslation:CGPointZero inView:self.frontView];
    }
}


#pragma mark - ElementSTVCDelegate methods -

- (void)elementDidSelect:(Element *)element
{
    //Dismiss popover
    [self.popover dismissPopoverAnimated:YES];
    
    //Add element to elements array
    [self.currentProject.elements addObject:element];
        
    [self setupElement:element];
    
    //Save updated current project
    [self.currentProject save];
}


#pragma mark - UIAlertViewDelegate methods -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==101) { //Add label
        
        if ([[[alertView textFieldAtIndex:0] text] length]>0) { //Check that the text is not void
            
            //This element will have a visible view only in one view
            
            //Create the element
            Element *newElement=[[Element alloc] init];
            
            if (buttonIndex==0) { //Add only to top view
                newElement.topView=[[LabelElement alloc] initWithFrame:CGRectMake(0, 0, 150, 40) andText:[[alertView textFieldAtIndex:0] text]];
                newElement.frontView=[[LabelElement alloc] initWithFrame:CGRectZero andText:@"Void Label"];
            }
            if (buttonIndex==1) { //Add only to front view
                newElement.topView=[[LabelElement alloc] initWithFrame:CGRectZero andText:@"Void Label"];
                newElement.frontView=[[LabelElement alloc] initWithFrame:CGRectMake(0, 0, 150, 40) andText:[[alertView textFieldAtIndex:0] text]];
            }
             
            //Add element to elements array
            [self.currentProject.elements addObject:newElement];
            
            [self setupElement:newElement];
            
            //Save updated current project
            [self.currentProject save];       
        }        
    }
    
    if (alertView.tag==100) { 
        if (buttonIndex==0) { //Remove element
            
            //Delete selected element from views
            [self.activeElementInTopView removeFromSuperview];
            [self.activeElementInFrontView removeFromSuperview];
            
            //Delete selected element from arrays
            [self.topViewElements removeObject:self.activeElementInTopView];
            [self.frontViewElements removeObject:self.activeElementInFrontView];
            
            //Delete Element from project
            //In order to do that, we have to get first the element that holds the active topView
            for (Element *element in self.currentProject.elements) {
                if (element.topView==self.activeElementInTopView) {
                    [self.currentProject.elements removeObject:element];
                    break;
                }
            }
            
            //Set actice elements to nil
            self.activeElementInTopView=nil;
            self.activeElementInFrontView=nil;
            
            //Save current project
            [self.currentProject save];
        }
    }
}

#pragma mark - UITextFieldDelegate -

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - View life cycle methods -

- (void)viewDidLoad
{
    //Init arrays
    self.topViewElements=[NSMutableArray arrayWithCapacity:1];
    self.frontViewElements=[NSMutableArray arrayWithCapacity:1];
    
    //Init project elements array
    self.currentProject.elements=[NSMutableArray arrayWithCapacity:1];
    
    [self loadCurrentProject];
}

//CAUTION here when returning from the popover (Projects or elements)
//CHECKED: This method is not called when dismissing the popover
- (void)viewDidAppear:(BOOL)animated
{
    //[super viewDidAppear:NO];
    
    //Load current project
    //[self loadCurrentProject];
}

- (void)viewDidUnload
{
    [self setTitleInView:nil];
    _popover=nil;
    _currentProject=nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
