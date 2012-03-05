//
//  GroupsTableViewController.m
//  PhotoStudio
//
//  Created by Xavier BENAVENT on 3/3/12.
//  Copyright (c) 2012 LECB 2. All rights reserved.
//

#import "GroupsTableViewController.h"
#import "ElementsTableViewController.h"

@interface GroupsTableViewController()

@property (nonatomic, strong) NSArray *groups;

@end


@implementation GroupsTableViewController

@synthesize mainViewController=_mainViewController;
@synthesize groups=_groups;




#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    //Load groups from Elements.plist
    NSString* path=[[NSBundle mainBundle] pathForResource:@"Elements" ofType:@"plist"];
    NSArray* allGroups=[NSArray arrayWithContentsOfFile:path];
    
    //Extract groups name (it is the first element of each array)
    NSMutableArray* groupsName=[NSMutableArray arrayWithCapacity:1];
    for (NSArray* group in allGroups) {
        [groupsName addObject:[group objectAtIndex:0]];
    }
    
    //Assign to self.groups
    self.groups=[NSArray arrayWithArray:groupsName];    
    
    self.navigationItem.title=@"Groups";
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    if ([segue.identifier isEqualToString:@"Group"]) 
    {
        //Data to pass: mainViewController (delegate), group (NSString), elements (NSArray)
        ElementsTableViewController *destinationViewController=(ElementsTableViewController *)segue.destinationViewController;
        destinationViewController.mainViewController=self.mainViewController;
        destinationViewController.group=[self.groups objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        destinationViewController.navigationItem.title=destinationViewController.group;
        
        //Load corresponding elements group from NSUserDefaults (.plist)
        //
        //Load groups from Elements.plist
        NSString* path=[[NSBundle mainBundle] pathForResource:@"Elements" ofType:@"plist"];
        NSArray* allGroups=[NSArray arrayWithContentsOfFile:path];
        
        //Extract elements name (all except the first element of each array that is the group name)
        NSMutableArray* groupNameAndElementsArray=[NSMutableArray arrayWithArray:[allGroups objectAtIndex:self.tableView.indexPathForSelectedRow.row]];
        
        //Remove first element
        [groupNameAndElementsArray removeObjectAtIndex:0];
        
        //Pass elements group
        destinationViewController.elements=[NSArray arrayWithArray:groupNameAndElementsArray];        
    }
}



#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.groups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Group";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString* groupName=(NSString*)[self.groups objectAtIndex:indexPath.row];
    cell.textLabel.text=groupName;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (void)viewDidUnload
{
    _mainViewController=nil;
    _groups=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (UIInterfaceOrientationIsLandscape(interfaceOrientation));
}


@end
