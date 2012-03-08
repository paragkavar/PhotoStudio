//
//  ProjetcsTableViewController.h
//  PhotoStudio
//
//  Created by Xavier BENAVENT on 3/7/12.
//  Copyright (c) 2012 LECB 2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"

@protocol ProjectsTableViewControllerDelegate

-(void)projectDidSelect:(Project*)project;
-(BOOL)projectShouldDelete:(Project*)project;
-(void)projectDidDelete:(Project*)project;

@end

@interface ProjetcsTableViewController : UITableViewController

@property (nonatomic, weak) id <ProjectsTableViewControllerDelegate> delegate;

@end
