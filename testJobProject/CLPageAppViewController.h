//
//  CLPageAppViewController.h
//  testJobProject
//
//  Created by Администратор on 9/24/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLPageAppViewController : UIViewController<UIPageViewControllerDataSource>

@property (nonatomic, strong) IBOutlet UIPageViewController * pageViewController;
@property (nonatomic, strong) NSMutableArray * chapterText;
@property (nonatomic, strong) NSMutableArray * imageArray;
@property (nonatomic) int indexCurrent;
- (IBAction)prevButtonPress:(id)sender;
- (IBAction)nextButtonPress:(id)sender;

@end
