//
//  ViewController.m
//  PhotoStudio
//
//  Created by Xavier BENAVENT on 3/3/12.
//  Copyright (c) 2012 LECB 2. All rights reserved.
//

#import "ViewController.h"


@interface ViewController() 

@property (nonatomic, strong) UIPopoverController *popover;

@end

@implementation ViewController

@synthesize popover=_popover;


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
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
}

- (void)elementDidSelect:(Element *)element
{
    //Dismiss popover
    [self.popover dismissPopoverAnimated:YES];
#warning TO DO
}


- (void)viewDidUnload
{
    _popover=nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
