//
//  CLMDetailViewController.m
//  testJobProject
//
//  Created by chematiks on 23.02.14.
//  Copyright (c) 2014 ChematiksLabs. All rights reserved.
//

#import "CLMDetailViewController.h"
#import "resourse.h"
#import "Direction.h"
#import "Worker.h"
#import "Bookkeeping.h"

#define kNumberOfEditableRows         4
#define kNameRowIndex                 0
#define kFromYearRowIndex             1
#define kToYearRowIndex               2
#define kPartyIndex                   3

#define kLabelTag                     2048
#define kTextFieldTag                 4094

#define kIndexEmployee 0
#define kIndexDirection 1
#define kIndexWorker 2
#define kIndexBookkeeping 3

@interface CLMDetailViewController ()

@end

@implementation CLMDetailViewController{
   // NSString *initialText;
    BOOL hasChanges;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
        
        NSArray * employeeFieldLabel = @[@"Surname:", @"Name:", @"Patronical:", @"Salary:"];
        NSArray * directionFieldLabel = @[@"To:", @"From:"];
        NSArray * workerFieldLabel = @[@"Seat number:"];
        NSArray * bookkeepingFieldLabel = @[@"Seat number:",@"Type bookkeeping:"];
        
        
        self.fieldLabels = @[ employeeFieldLabel, directionFieldLabel, workerFieldLabel, bookkeepingFieldLabel];
        
        self.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                      target:self
                                                      action:@selector(cancel:)];
        self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                      target:self
                                                      action:@selector(save:)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.allowsSelection = NO;
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_employee isMemberOfClass:[Direction class]]) {
        return 2;
    }else
        return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        NSArray * array = [self.fieldLabels objectAtIndex:kIndexEmployee];
        return array.count;
    }else
        if (section == 1) {
            return 2;
        }else
            if (section == 2) {
                if ([_employee isMemberOfClass:[Worker class]]) {
                    NSArray * array = self.fieldLabels[kIndexWorker];
                    return array.count;
                }else{
                    NSArray * array = self.fieldLabels[kIndexBookkeeping];
                    return array.count;
                }
            }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 125, 25)];
        label.tag = kLabelTag;
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont boldSystemFontOfSize:14];
        [cell.contentView addSubview:label];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:
                                  CGRectMake(140, 12, 200, 25)];
        textField.tag = kTextFieldTag;
        textField.clearsOnBeginEditing = NO;
        textField.delegate = self;
        [textField addTarget:self action:@selector(textFieldDone:)
            forControlEvents:UIControlEventEditingDidEndOnExit];
        [cell.contentView addSubview:textField];
    }
    
    UILabel *label = (id)[cell viewWithTag:kLabelTag];
    if (indexPath.section < 2) {
        label.text = self.fieldLabels[indexPath.section][indexPath.row];
    }else
        if ([_employee isMemberOfClass:[Worker class]]) {
            label.text = self.fieldLabels[indexPath.section][indexPath.row];
        }else
            label.text = self.fieldLabels[indexPath.section+1][indexPath.row];
    
    UITextField *textField = (id)[cell viewWithTag:kTextFieldTag];
    
  /*  textField.superview.tag = indexPath.row;
    switch (indexPath.row) {
        case kNameRowIndex:
            textField.text = self.employee.name;
            break;
        case kFromYearRowIndex:
            textField.text = self.employee.patronymic;
            break;
        case kToYearRowIndex:
            textField.text = self.employee.surname;
            break;
        case kPartyIndex:
            textField.text = [self.employee.salary stringValue];
            break;
        default:
            break;
    }*/
    return cell;
}


- (void)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save:(id)sender
{
    /*[self.view endEditing:YES];
    if (hasChanges) {
        [self.delegate presidentDetailViewController:self
                                  didUpdatePresident:self.president];
    }
    [self.navigationController popViewControllerAnimated:YES];*/
}

- (void)textFieldDone:(id)sender
{
    [sender resignFirstResponder];
    UITextField *senderField = sender;
    NSInteger nextRow = (senderField.superview.tag + 1) % kNumberOfEditableRows;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:nextRow
                                                inSection:0];
    UITableViewCell *nextCell = [self.tableView cellForRowAtIndexPath:indexPath];
    UITextField *nextField = (id)[nextCell viewWithTag:kTextFieldTag];
    [nextField becomeFirstResponder];
}

/*

 - (void)textFieldDidBeginEditing:(UITextField *)textField
 {
 initialText = textField.text;
 }
 
 
 - (void)textFieldDidEndEditing:(UITextField *)textField
 {
 if (![textField.text isEqualToString:initialText]) {
 hasChanges = YES;
 switch (textField.superview.tag) {
 case kNameRowIndex:
 self.president.name = textField.text;
 break;
 case kFromYearRowIndex:
 self.president.fromYear = textField.text;
 break;
 case kToYearRowIndex:
 self.president.toYear = textField.text;
 break;
 case kPartyIndex:
 self.president.party = textField.text;
 break;
 default:
 break;
 }
 }
 }
 
 
 @end

*/

@end
