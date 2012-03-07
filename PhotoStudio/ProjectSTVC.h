//
//  ProjectSTVC.h
//  PhotoStudio
//
//  Created by Xavier BENAVENT on 3/7/12.
//  Copyright (c) 2012 LECB 2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"

@class ProjectSTVC;
@protocol ProjectSTVCDelegate
- (void)projectDidCreate:(Project *)newProject;
@end


@interface ProjectSTVC : UITableViewController

@property (nonatomic, weak) id <ProjectSTVCDelegate> delegate;

@end
