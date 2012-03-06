//
//  ElementSTVC.m
//  PhotoStudio
//
//  Created by Xavier BENAVENT on 3/5/12.
//  Copyright (c) 2012 LECB 2. All rights reserved.
//

#import "ElementSTVC.h"

@interface ElementSTVC()

@property (weak, nonatomic) IBOutlet UIImageView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *frontView;


@end

@implementation ElementSTVC

@synthesize delegate=_delegate;
@synthesize groupAndName=_groupAndName;
@synthesize topView;
@synthesize frontView;


- (IBAction)selectButtonDidTap
{
    //Create the element
    Element *newElement=[[Element alloc] init];
    
    newElement.topView=[[ElementView alloc] initWithFrame:CGRectMake(100, 100, 100, 100) andImage:[NSString stringWithFormat:@"%@.top.png",self.groupAndName]];
    newElement.frontView=[[ElementView alloc] initWithFrame:CGRectMake(100, 100, 100, 100) andImage:[NSString stringWithFormat:@"%@.front.png",self.groupAndName]];
    
    //Call delegate with selected element
    [self.delegate elementDidSelect:newElement];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.topView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.top.png",self.groupAndName]];
    self.frontView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.front.png",self.groupAndName]];
    
}

- (void)viewDidUnload
{
    _delegate=nil;
    _groupAndName=nil;
    [self setTopView:nil];
    [self setFrontView:nil];
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}




@end
