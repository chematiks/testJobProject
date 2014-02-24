//
//  CLMDetailViewController.h
//  testJobProject
//
//  Created by chematiks on 23.02.14.
//  Copyright (c) 2014 ChematiksLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class resourse;

@protocol CLMDetailViewControllerDelegate;

@interface CLMDetailViewController : UITableViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>


@property (assign, nonatomic) resourse *employee;
//@property (assign, nonatomic) id<CLMDetailViewControllerDelegate> delegate;
@property (assign, nonatomic) NSInteger row;

@property (strong, nonatomic) NSArray *fieldLabels;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)textFieldDone:(id)sender;

@end
/*
@protocol CLMDetailViewControllerDelegate <NSObject>

- (void)employeeDetailViewController:(CLMDetailViewController *)controller
                   didUpdateemployee:(resourse *)employee;

@end

*/