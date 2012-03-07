//
//  ProjetcsTableViewController.m
//  PhotoStudio
//
//  Created by Xavier BENAVENT on 3/7/12.
//  Copyright (c) 2012 LECB 2. All rights reserved.
//

#import "ProjetcsTableViewController.h"
#import "ProjectSTVC.h"


@interface ProjetcsTableViewController() <ProjectSTVCDelegate>

//This array will contain only the picture and the title (project name)
@property (nonatomic, strong) NSMutableArray *projectsMainInfo;
@property (nonatomic, strong) NSMutableArray *UPIDs;

- (void)loadProjects;
- (void)saveUPIDs;

@end

@implementation ProjetcsTableViewController

@synthesize projectsMainInfo=_projectsMainInfo;
@synthesize UPIDs=_UPIDs;

#pragma mark - Private methods -

- (void)loadProjects
{
    //Init array
    self.projectsMainInfo=[NSMutableArray arrayWithCapacity:1];
    
    //Load projects UPIDs from NSUserDefaults
    NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
    self.UPIDs=[NSMutableArray arrayWithArray:(NSArray*)[userDefaults objectForKey:@"UPIDs"]];
    
    //With the projects UPIDs, load the project's main info (little memory footprint)
    for (NSString* projectUPID in self.UPIDs) {
        [self.projectsMainInfo addObject:[Project loadProjectMainInfoWithUPID:projectUPID]];
    }
}

- (void)saveUPIDs
{
    //Save projects UPIDs
    NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.UPIDs forKey:@"UPIDs"];
    [userDefaults synchronize];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"New Project"]) {
        ProjectSTVC *projectSTVC=(ProjectSTVC *)segue.destinationViewController;
        projectSTVC.delegate=self;
    }
}

#pragma mark - ProjectSTVCDelegate

- (void)projectDidCreate:(Project *)newProject
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadProjects];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _projectsMainInfo=nil;
    _UPIDs=nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.projectsMainInfo count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Project Main Info";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Project *projectMainInfo=(Project *)[self.projectsMainInfo objectAtIndex:indexPath.row];
    cell.textLabel.text=projectMainInfo.UPID;
    cell.imageView.frame=CGRectMake(0, 0, 90, 90);
    cell.imageView.image=projectMainInfo.resultPicture;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


@end
