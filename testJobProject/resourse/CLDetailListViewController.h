//
//  CLDetailListViewController.h
//  testJobProject
//
//  Created by Администратор on 9/26/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLDetailListViewController : UIViewController <UITextFieldDelegate>
{
    UILabel * labelDetailTimeFrom;
    UILabel * labelDetailTimeTo;
    UILabel * labelSeatNumber;
    UILabel * labelTypeBuch;
    
    UITextField * fieldDetailTimeFrom;
    UITextField * fieldDetailTimeTo;
    UITextField * fieldSeatNumber;
    UITextField * fieldTypeBuch;
    
    UITextField * currentTextField;
    
    NSDateFormatter * timeFormat;

    UIView * pickerTimeView;
    IBOutlet UIDatePicker * picker;
    IBOutlet UIToolbar * toolbar;
}

-(IBAction)valueChangeTimePicker:(id)sender;
-(IBAction)upTimePicker:(id)sender;
-(IBAction)downTimePicker:(id)sender;

-(IBAction)changeTypeList:(id)sender;

-(IBAction)textFieldDoneEditing:(id)sender;
-(IBAction)textFieldDidEndEditing:(id)sender;
-(IBAction)textFieldDidBeginEditing:(UITextField *)sender;
-(void) initDataInDetailView:(id) object;

@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (retain, nonatomic) IBOutlet UITextField *surnameField;
@property (retain, nonatomic) IBOutlet UITextField *nameLabel;
@property (retain, nonatomic) IBOutlet UITextField *patronymicLabel;
@property (retain, nonatomic) IBOutlet UITextField *salaryLabel;

@end
