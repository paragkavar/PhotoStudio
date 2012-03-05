//
//  ElementsTableViewController.m
//  PhotoStudio
//
//  Created by Xavier BENAVENT on 3/4/12.
//  Copyright (c) 2012 LECB 2. All rights reserved.
//

#import "ElementsTableViewController.h"
#import "ElementSTVC.h"

@interface ElementsTableViewController()

@property (nonatomic, strong) NSArray *thumbnails;

-(NSArray*)loadImageElementsAndMakeThumbnails;

@end

@implementation ElementsTableViewController

@synthesize group=_group;
@synthesize elements=_elements;
@synthesize mainViewController=_mainViewController;

@synthesize thumbnails=_thumbnails;


#pragma mark - Private methods -

-(NSArray*)loadImageElementsAndMakeThumbnails
{
    NSMutableArray* thumbnailsArray=[NSMutableArray arrayWithCapacity:1];
    
    //Get the file name: "groupName.elementName.png"
    for (NSString* elementName in self.elements) {
        UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.%@.top.png",self.group,elementName]];
        NSString *assertMessage=[NSString stringWithFormat:@"\n**********\nThere is a problem loading image %@.%@\n**********",self.group,elementName];
        NSAssert(image, assertMessage , nil);
        [thumbnailsArray addObject:image];
    }
    
    //Convert to right size (crop)
#warning TO DO
    
    return [NSArray arrayWithArray:thumbnailsArray];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Element"]) 
    {
        ElementSTVC *elementsSTVC=(ElementSTVC *)segue.destinationViewController;
        elementsSTVC.groupAndName=[NSString stringWithFormat:@"%@.%@",self.group,(NSString *)[self.elements objectAtIndex:self.tableView.indexPathForSelectedRow.row]];
        elementsSTVC.delegate=self.mainViewController;
    }
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Load group elements images
    self.thumbnails=[self loadImageElementsAndMakeThumbnails];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _group=nil;
    _elements=nil;
    _mainViewController=nil;
}



#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.elements count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Element";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString* groupName=(NSString*)[self.elements objectAtIndex:indexPath.row];
    cell.textLabel.text=groupName;
    
    UIImage* elementThumbnail=(UIImage*)[self.thumbnails objectAtIndex:indexPath.row];
    cell.imageView.image=elementThumbnail;
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (UIInterfaceOrientationIsLandscape(interfaceOrientation));
}


@end
