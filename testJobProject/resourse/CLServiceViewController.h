//
//  CLServiceViewController.h
//  testJobProject
//
//  Created by Admin on 06.11.13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLServiceViewController : UIViewController <UITableViewDataSource>

@property (nonatomic, retain) NSMutableArray * arrayNote;

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *trobber;

-(void) loadDataXml;

@end
