//
//  ListViewController.h
//  testJobProject
//
//  Created by Администратор on 10/13/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLDataBaseDelegate.h"
#import "constants.h"

@interface ListViewController : UITableViewController <UITableViewDataSource,NSFetchedResultsControllerDelegate>
{
    NSDateFormatter * timeFormat;
}


@end
