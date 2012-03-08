//
//  NewProjectSTVC.h
//  PhotoStudio
//
//  Created by Xavier BENAVENT on 3/7/12.
//  Copyright (c) 2012 LECB 2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"
#import "ImageHelper.h"

@class NewProjectSTVC;
@protocol NewProjectSTVCDelegate
- (void)projectDidCreate:(Project *)newProject;
@end


@interface NewProjectSTVC : UITableViewController

@property (nonatomic, weak) id <NewProjectSTVCDelegate> delegate;

@end
