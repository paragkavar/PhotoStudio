//
//  ProjetcsTableViewController.m
//  PhotoStudio
//
//  Created by Xavier BENAVENT on 3/7/12.
//  Copyright (c) 2012 LECB 2. All rights reserved.
//

#import "ProjetcsTableViewController.h"
#import "NewProjectSTVC.h"
#import "EditProjectSTVC.h"
#import "ImageHelper.h"


@interface ProjetcsTableViewController() <NewProjectSTVCDelegate,EditProjectSTVCDelegate>

//This array will contain only the picture and the title (project name)
@property (nonatomic, strong) NSMutableArray *projectsMainInfo;
@property (nonatomic, strong) NSMutableArray *UPIDs;
@property (nonatomic, readwrite) int rowEdited;

- (void)loadProjects;
- (void)saveUPIDs;

@end

@implementation ProjetcsTableViewController

@synthesize delegate=_delegate;
@synthesize projectsMainInfo=_projectsMainInfo;
@synthesize UPIDs=_UPIDs;
@synthesize rowEdited=_rowEdited;

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
        [self.projectsMainInfo addObject:[Project loadProjectWithUPID:projectUPID]];
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
        NewProjectSTVC *newProjectSTVC=(NewProjectSTVC *)segue.destinationViewController;
        newProjectSTVC.delegate=self;
    }
    
    if ([segue.identifier isEqualToString:@"Edit Project"]) {
        EditProjectSTVC *editprojectSTVC=(EditProjectSTVC *)segue.destinationViewController;
        editprojectSTVC.delegate=self;
        
        //Get and store the selected row
        //self.rowEdited=self.tableView.indexPathForSelectedRow.row;
        
        NSLog(@"Row edited: %d",self.rowEdited);
        
        //Load the full project, getting the UPID from the project at the selected row
        editprojectSTVC.editingProject=[Project loadProjectWithUPID:[(Project *)[self.projectsMainInfo objectAtIndex:self.rowEdited] UPID]];
    }
}

#pragma mark - NewProjectSTVCDelegate

- (void)projectDidCreate:(Project *)newProject
{
    //Dismiss NewProjectSTVC
    [self.navigationController popViewControllerAnimated:YES];
    
    //Save project
    [newProject save];
    
    //Add project UPID to UPIDs array
    [self.UPIDs addObject:newProject.UPID];
    
    //Save UPIDs
    [self saveUPIDs];
    
    //Add new project to projects array
    [self.projectsMainInfo addObject:newProject];
    
    //Update tabe view
    [self.tableView reloadData];
}

#pragma mark - EditProjectSTVCDelegate -

- (void)projectDidFinishEditing:(Project *)project
{
    //Dismiss EditProjectSTVC
    [self.navigationController popViewControllerAnimated:YES];
    
    //Save project
    //The images are saved being croped to 250x150 aprox
    [project save];
    
    //Replace project in projects array
    [self.projectsMainInfo replaceObjectAtIndex:self.rowEdited withObject:project];
    
    //Update table view
    [self.tableView reloadData];
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
    _delegate=nil;
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
    
    UILabel *projectTitle=(UILabel *)[cell viewWithTag:101];
    UILabel *projectUPID=(UILabel *)[cell viewWithTag:102];
    UIImageView *projectImageView=(UIImageView *)[cell viewWithTag:100];
    
    projectTitle.text=projectMainInfo.title;
    projectUPID.text=projectMainInfo.UPID;
    
    
    //The images are croped by the method to 100x100, but we NEVER save this size. we ONLY save the image when the project is created or edited (250x150)
    projectImageView.image=[ImageHelper getImageAndReduceImage:projectMainInfo.resultPicture toCropInView:projectImageView];
        
    return cell;
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //Get project to delete
        Project* project=(Project*)[self.projectsMainInfo objectAtIndex:indexPath.row];
        
        //Check whether it can be deleted through the delegate
        if ([self.delegate projectShouldDelete:project]) 
        {
            //Delete the project from the projects array
            [self.projectsMainInfo removeObjectAtIndex:indexPath.row];
            
            //Delete the project UPID from the UPIDs array
            [self.UPIDs removeObjectAtIndex:indexPath.row];
            
            //Save to NSUserDefaults the updated UPIDs array
            [self saveUPIDs];
            
            // Delete the row from the data source
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }   
}

-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate projectDidSelect:[self.projectsMainInfo objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"IndexPath.row = %d",indexPath.row);
    self.rowEdited=indexPath.row;
    [self performSegueWithIdentifier:@"Edit Project" sender:self];
}

@end
