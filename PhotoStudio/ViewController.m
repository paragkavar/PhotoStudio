//
//  ViewController.m
//  PhotoStudio
//
//  Created by Xavier BENAVENT on 3/3/12.
//  Copyright (c) 2012 LECB 2. All rights reserved.
//

#import "ViewController.h"


@implementation ViewController


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Elements"]) {
        UINavigationController *navigationController=(UINavigationController *)segue.destinationViewController;
        GroupsTableViewController *groupsTableViewController=(GroupsTableViewController *)navigationController.topViewController;
        groupsTableViewController.mainViewController=self;
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
