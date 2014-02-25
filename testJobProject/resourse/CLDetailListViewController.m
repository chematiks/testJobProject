//
//  CLDetailListViewController.m
//  testJobProject
//
//  Created by Администратор on 9/26/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import "CLDetailListViewController.h"
#import "CLDataBaseDelegate.h"
#import "resourse.h"
#import "Direction.h"
#import "Worker.h"
#import "Bookkeeping.h"
#import "constants.h"

#define directionIndex 0
#define workerIndex 1
#define bookkeepingIndex 2
#define pickerUpX pickerDownX-49-162
#define pickerDownX [[UIScreen mainScreen]bounds].size.height
#define animation UIViewAnimationOptionAllowAnimatedContent


@interface CLDetailListViewController ()

@property (retain, nonatomic) resourse * staff;

@end

@implementation CLDetailListViewController

//customize interface
-(void) initInterfaceLabelAndField
{
    timeFormat=[[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm"];
    
    [labelDetailTimeFrom removeFromSuperview];
    [labelSeatNumber removeFromSuperview];
    [fieldSeatNumber removeFromSuperview];
    [labelTypeBuch removeFromSuperview];
    [fieldTypeBuch removeFromSuperview];
    
    labelDetailTimeFrom=[[UILabel alloc] initWithFrame:CGRectMake(20.0, 285.0, 120.0, 21.0)];
    labelDetailTimeFrom.font=[UIFont systemFontOfSize:14];
    labelDetailTimeFrom.textColor=[UIColor blackColor];
    
    labelDetailTimeTo=[[UILabel alloc] initWithFrame:CGRectMake(220.0, 285.0, 30.0, 21.0)];
    labelDetailTimeTo.font=[UIFont systemFontOfSize:14];
    labelDetailTimeTo.textColor=[UIColor blackColor];
    labelDetailTimeTo.text=@"до:";
    
    fieldDetailTimeFrom=[[UITextField alloc] initWithFrame:CGRectMake(135, 281, 60, 30)];
    fieldDetailTimeFrom.borderStyle=UITextBorderStyleRoundedRect;
    fieldDetailTimeFrom.font=[UIFont systemFontOfSize:14];
    fieldDetailTimeFrom.delegate=self;

    fieldDetailTimeTo=[[UITextField alloc] initWithFrame:CGRectMake(245, 281, 60, 30)];
    fieldDetailTimeTo.borderStyle=UITextBorderStyleRoundedRect;
    fieldDetailTimeTo.font=[UIFont systemFontOfSize:14];
    fieldDetailTimeTo.delegate=self;
    
    [self.view addSubview:labelDetailTimeTo];
    [self.view addSubview:fieldDetailTimeFrom];
    [self.view addSubview:fieldDetailTimeTo];
    
    labelSeatNumber=[[UILabel alloc] initWithFrame:CGRectMake(20.0, 320.0, 180.0, 21.0)];
    labelSeatNumber.font=[UIFont systemFontOfSize:14];
    labelSeatNumber.textColor=[UIColor blackColor];
    labelSeatNumber.text=@"Номер рабочего места:";
    fieldSeatNumber=[[UITextField alloc] initWithFrame:CGRectMake(205, 316, 100, 30)];
    fieldSeatNumber.borderStyle=UITextBorderStyleRoundedRect;
    fieldSeatNumber.font=[UIFont systemFontOfSize:14];
    fieldSeatNumber.autocorrectionType=UITextAutocorrectionTypeNo;
    fieldSeatNumber.keyboardType=UIKeyboardTypeNumberPad;
    [fieldSeatNumber addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [fieldSeatNumber addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [fieldSeatNumber addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    
    labelTypeBuch=[[UILabel alloc] initWithFrame:CGRectMake(20.0, 355.0, 180.0, 21.0)];
    labelTypeBuch.font=[UIFont systemFontOfSize:14];
    labelTypeBuch.textColor=[UIColor blackColor];
    labelTypeBuch.text=@"Тип бухгалтера:";
    fieldTypeBuch=[[UITextField alloc] initWithFrame:CGRectMake(205, 351, 100, 30)];
    fieldTypeBuch.borderStyle=UITextBorderStyleRoundedRect;
    fieldTypeBuch.font=[UIFont systemFontOfSize:14];
    fieldTypeBuch.autocorrectionType=UITextAutocorrectionTypeNo;
    [fieldTypeBuch addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [fieldTypeBuch addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [fieldTypeBuch addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    
    [self.navigationItem setTitle:@"Detail"];
    
    [self.view addSubview:labelDetailTimeFrom];
    [self.view addSubview:labelSeatNumber];
    [self.view addSubview:fieldSeatNumber];
    [self.view addSubview:labelTypeBuch];
    [self.view addSubview:fieldTypeBuch];
    [self createPicker];
    
    _surnameField.tag = 0;
    _nameLabel.tag = 1;
    _patronymicLabel.tag = 2;
    _salaryLabel.tag = 3;
    fieldDetailTimeFrom.tag = 4;
    fieldDetailTimeTo.tag = 5;
    fieldSeatNumber.tag = 6;
    fieldTypeBuch.tag = 7;
    
}

//hidden all keyboards
-(BOOL) textFieldShouldBeginEditing:(UITextField *) textField
{
    if (textField==fieldDetailTimeFrom || textField==fieldDetailTimeTo)
    {
        [self.surnameField resignFirstResponder];
        [self.nameLabel resignFirstResponder];
        [self.patronymicLabel resignFirstResponder];
        [fieldSeatNumber resignFirstResponder];
        [fieldTypeBuch resignFirstResponder];
        [self upTimePicker:textField];
        return NO;
    }
    return YES;
}

//if press button return, switch to next textField
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self nextButtonPress:nil];
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.surnameField.delegate=self;
    self.nameLabel.delegate=self;
    self.patronymicLabel.delegate=self;
    self.salaryLabel.delegate=self;
    fieldDetailTimeFrom.delegate=self;
    fieldDetailTimeTo.delegate=self;
    fieldSeatNumber.delegate=self;
    fieldTypeBuch.delegate=self;

    //add button to navigation bar
    UIBarButtonItem * editButton=[[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(unlockInterface:)];
    [self.navigationItem setRightBarButtonItem:editButton];
    
}

//load default data
-(void) initDataInDetailView:(id) object
{
    [self initInterfaceLabelAndField];
    [self modeInterface:NO];
    [self setBasicField:object];
    if ([object class]==[Direction class])
    {
        [self setDirectionData:object];
    }
    else
        if ([object class]==[Worker class])
        {
            [self setWorkerData:object];
        }
        else
            if ([object class]==[Bookkeeping class])
            {
                [self setBookkeepingData:object];
            }
            else
            {
                [self unlockInterface:nil];
            }
    [self changeTypeList:self.segmentControl];
}

-(void) setBasicField:(resourse *)object
{
    self.surnameField.text=object.surname;
    self.nameLabel.text=object.name;
    self.patronymicLabel.text=object.patronymic;
    self.salaryLabel.text=[object.salary stringValue];
}

-(void) setDirectionData:(Direction *)object
{
    self.segmentControl.selectedSegmentIndex=directionIndex;
    fieldDetailTimeFrom.text=[timeFormat stringFromDate:object.businessHourStart];
    fieldDetailTimeTo.text=[timeFormat stringFromDate:object.businessHourFinish];
}

-(void) setWorkerData:(Worker *)object
{
    self.segmentControl.selectedSegmentIndex=workerIndex;
    fieldSeatNumber.text=[object.seatNumber stringValue];
    fieldDetailTimeFrom.text=[timeFormat stringFromDate:object.dinnerTimeStart];
    fieldDetailTimeTo.text=[timeFormat stringFromDate:object.dinnerTimeFinish];
}

-(void) setBookkeepingData:(Bookkeeping *)object
{
    self.segmentControl.selectedSegmentIndex=bookkeepingIndex;
    fieldSeatNumber.text=[object.seatNumber stringValue];
    fieldTypeBuch.text=object.typeBookkeeping;
    fieldDetailTimeFrom.text=[timeFormat stringFromDate:object.dinnerTimeStart];
    fieldDetailTimeTo.text=[timeFormat stringFromDate:object.dinnerTimeFinish];
}

//method lock and unlock interface
-(void) unlockInterface:(id)sender
{
    [self modeInterface:YES];
}

-(void) modeInterface:(BOOL)lock
{
    for (int i=0; i<9; i++) {
        UIControl * currentObject = (id)[self.view viewWithTag:i];
        currentObject.enabled = lock;
    }
    if (lock) {
        UIBarButtonItem * saveButton=[[UIBarButtonItem alloc]
                                      initWithTitle:@"Save"
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(saveButtonPress:)];
        [self.navigationItem setRightBarButtonItem:saveButton];
    }
}


//method save data
-(void) saveButtonPress:(id)sender
{
    NSString * currentEntity;
    NSMutableArray * objects=[NSMutableArray arrayWithObjects:self.surnameField.text,
                       self.nameLabel.text,
                       self.patronymicLabel.text,
                       [NSNumber numberWithInt:[self.salaryLabel.text intValue]],
                       [timeFormat dateFromString:fieldDetailTimeFrom.text],
                       [timeFormat dateFromString:fieldDetailTimeTo.text], nil];
    NSMutableArray * keys=[NSMutableArray arrayWithObjects:kSurname,
                    kName,
                    kPatronymic,
                    kSalary, nil];
    if (self.segmentControl.selectedSegmentIndex==directionIndex)
    {
        currentEntity=eDirection;
        [keys addObject:kBusinessHourStart];
        [keys addObject:kBusinessHourFinish];
    }
    else
    {
        currentEntity=eWorker;
        [objects addObject:[NSNumber numberWithInt:[fieldSeatNumber.text intValue]]];
        [keys addObject:kDinnerTimeStart];
        [keys addObject:kDinnerTimeFinish];
        [keys addObject:kSeatNumber];
        if (self.segmentControl.selectedSegmentIndex==bookkeepingIndex)
        {
            currentEntity=eBookkeepping;
            [objects addObject:fieldTypeBuch.text];
            [keys addObject:kTypeBookkeeping];
        }
    }
    [objects addObject:currentEntity];
    [keys addObject:kCategory];
    
    if ([objects count]<[keys count])
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"Внимание!"
                                                       message:@"Заполните пожалуйста все поля"
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
    NSDictionary * currentObject=[NSDictionary dictionaryWithObjects:objects forKeys:keys];
    [[CLDataBaseDelegate sharedDB] createEntytiWithClassName:currentEntity attributesDictionary:currentObject];
    
    if ([[CLDataBaseDelegate sharedDB] getCurrentObject])
    {
        [[CLDataBaseDelegate sharedDB] deleteEntity:[[CLDataBaseDelegate sharedDB] getCurrentObject]];
    }
    [[CLDataBaseDelegate sharedDB] saveDataInManagedContext];
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//init element interface at change selected segment controll
- (IBAction)changeTypeList:(id)sender
{
    NSInteger selectedSegment=self.segmentControl.selectedSegmentIndex;
    if (selectedSegment==directionIndex)
        [self addDirectionDetail];
    if (selectedSegment==workerIndex)
        [self addWorkerDetail];
    if (selectedSegment==bookkeepingIndex)
        [self addBookkeeperDetail];
}

-(void) addDirectionDetail
{
    labelDetailTimeFrom.text=@"Часы приема с:";
    fieldTypeBuch.hidden=YES;
    labelTypeBuch.hidden=YES;
    labelSeatNumber.hidden=YES;
    fieldSeatNumber.hidden=YES;
}

-(void) addWorkerDetail
{
    labelDetailTimeFrom.text=@"Время обеда с:";
    fieldTypeBuch.hidden=YES;
    labelTypeBuch.hidden=YES;
    labelSeatNumber.hidden=NO;
    fieldSeatNumber.hidden=NO;
}

-(void) addBookkeeperDetail
{
    [self addWorkerDetail];
    fieldTypeBuch.hidden=NO;
    labelTypeBuch.hidden=NO;
    labelSeatNumber.hidden=NO;
    fieldSeatNumber.hidden=NO;
}

- (void)dealloc
{
    [_segmentControl release];
    [_nameLabel release];
    [_patronymicLabel release];
    [_salaryLabel release];
    [super dealloc];
}

//resign keyboard after press button done
-(IBAction)textFieldDoneEditing:(id)sender
{
    currentTextField=nil;
    [sender resignFirstResponder];
    [self textFieldDidEndEditing:nil];
}

//moving main view to default coordination
- (IBAction)textFieldDidEndEditing:(UITextField *)sender
{
    [self.salaryLabel resignFirstResponder];
    [fieldSeatNumber resignFirstResponder];
    [UIView transitionWithView:self.view
                      duration:0.5f
                       options:animation
                    animations:^{
                        CGRect rect=self.view.frame;
                        rect.origin.y=[self getDeltaY:currentTextField];
                        self.view.frame=rect;
                        rect=pickerTimeView.frame;
                        rect.origin.y=pickerDownX;
                        pickerTimeView.frame=rect;
                    }
                    completion:NULL];
}

//moving main view up
- (IBAction)textFieldDidBeginEditing:(UITextField *)sender
{
    fieldDetailTimeFrom.backgroundColor=[UIColor whiteColor];
    fieldDetailTimeTo.backgroundColor=[UIColor whiteColor];
    currentTextField=sender;
    [UIView transitionWithView:self.view
                      duration:0.5f
                       options:animation
                    animations:^{
                        CGRect rect=self.view.frame;
                        rect.origin.y=[self getDeltaY:sender];
                        if (currentTextField==fieldSeatNumber || currentTextField==self.salaryLabel)
                            [self upToolbarWithNumberPad:currentTextField];
                        self.view.frame=rect;
                    }
                    completion:NULL];
}

//get delta Y
-(float) getDeltaY:(UITextField *) sender
{
    float deltaY=0;
    if (sender==_salaryLabel)
        deltaY=-(10+44);
    if (sender==fieldDetailTimeFrom||sender==fieldDetailTimeTo)
        deltaY=-44.f;
    if (sender==fieldSeatNumber)
        deltaY=-(85+44);
    if (sender==fieldTypeBuch)
        deltaY=-120.f;
    if ([[UIScreen mainScreen]bounds].size.height==568)
        deltaY=deltaY+88;
    if (deltaY>0)
        deltaY=0;
    return deltaY;
}

//create toolbar
-(void) createToolbar
{
    pickerTimeView=[[UIView alloc] initWithFrame:CGRectMake(0,pickerDownX,320,142)];
    pickerTimeView.backgroundColor=[UIColor colorWithRed:0.73 green:0.835 blue:0.992 alpha:0.9];
    
    toolbar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.barStyle=UIBarStyleBlackTranslucent;
    toolbar.backgroundColor=[UIColor colorWithRed:0.73 green:0.835 blue:0.992 alpha:0.9];
    toolbar.barTintColor=[UIColor colorWithRed:0.73 green:0.835 blue:0.992 alpha:0.9];
    [toolbar sizeToFit];
    
    UIBarButtonItem * buttonDone=[[UIBarButtonItem alloc]
                                  initWithTitle:@"Done"
                                  style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(doneButtonPress:)];
    UIBarButtonItem * buttonNext=[[UIBarButtonItem alloc]
                                  initWithTitle:@"Next"
                                  style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(nextButtonPress:)];
    UIBarButtonItem * buttonPrev=[[UIBarButtonItem alloc]
                                  initWithTitle:@"Prev"
                                  style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(prevButtonPress:)];
    
    UIBarButtonItem * spaceItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [spaceItem setWidth:50];
    NSArray * toolbarItems=[[NSArray alloc] initWithObjects:buttonPrev,buttonNext,spaceItem,buttonDone, nil];
    
    [buttonNext release];
    [buttonPrev release];
    [buttonDone release];
   // [buttonValueChange release];
    [spaceItem release];
    [toolbar setItems:toolbarItems];
    
    [toolbarItems release];
}

-(void) nextButtonPress:(id)sender
{
    NSInteger tag = currentTextField.tag;
    tag++;
    if (tag ==8) {
        tag = 0;
    }
    currentTextField = (UITextField *)[self.view viewWithTag:tag];

    UIResponder * nextResponder=currentTextField;
    [nextResponder becomeFirstResponder];
}

-(void) prevButtonPress:(id)sender
{
    NSInteger tag = currentTextField.tag;
    tag--;
    if (tag == -1) {
        tag = 7;
    }
    currentTextField = (UITextField *)[self.view viewWithTag:tag];
    
    UIResponder * prevResponder=currentTextField;
    [prevResponder becomeFirstResponder];
}

//if press button done, shift focus to next textfield
-(void) doneButtonPress:(id)sender
{
    [currentTextField resignFirstResponder];
    [self downTimePicker:currentTextField];
    [self downToolbarWithNumberPad:currentTextField];
    currentTextField = nil;
}

//create picker
-(void) createPicker
{
    [self createToolbar];
    picker=[[UIDatePicker alloc] initWithFrame:CGRectMake(70, -10, 250, 162)];
    [picker addTarget:self action:nil forControlEvents:UIControlEventValueChanged];
    picker.datePickerMode=UIDatePickerModeCountDownTimer;
    
    [pickerTimeView addSubview:picker];
    [pickerTimeView addSubview:toolbar];
    
    [self.view addSubview:pickerTimeView];
}

//if press button save in toolbar
-(IBAction)valueChangeTimePicker:(id)sender
{
    currentTextField.text=[timeFormat stringFromDate:[picker date]];
    [self downTimePicker:nil];
}

//up toolbar for salary and seat number text field
-(IBAction) upToolbarWithNumberPad:(id) sender
{
    [self showTimePicker:NO];
    currentTextField=sender;
    [UIView transitionWithView:pickerTimeView
                      duration:0.5f
                       options:animation
                    animations:^{
                        CGRect rect=pickerTimeView.frame;
                        rect.origin.y=pickerUpX-[self getDeltaY:currentTextField]-49;
                        pickerTimeView.frame=rect;
                    }
                    completion:NULL];
}

//down toolbar for salary and seat number text field
-(IBAction) downToolbarWithNumberPad:(id)sender
{
    currentTextField=nil;
    [self textFieldDidEndEditing:currentTextField];
    [self showTimePicker:YES];
}

//show and hidden picker
-(void) showTimePicker:(BOOL) show
{
    picker.hidden=!show;
}

//up moving toolbar with time picker
-(IBAction)upTimePicker:(id)sender
{
    if (currentTextField)
        currentTextField.backgroundColor=[UIColor whiteColor];
    [self.salaryLabel resignFirstResponder];
    [fieldSeatNumber resignFirstResponder];
    [self showTimePicker:YES];
    currentTextField=sender;
    [self textFieldDidBeginEditing:currentTextField];
    currentTextField.backgroundColor=[UIColor lightGrayColor];
    if (![currentTextField.text isEqualToString:@""])
        [picker setDate:[timeFormat dateFromString:currentTextField.text]];
    [UIView transitionWithView:pickerTimeView
                      duration:0.5f
                       options:animation
                    animations:^{
                        CGRect rect=pickerTimeView.frame;
                        rect.origin.y=pickerUpX-[self getDeltaY:currentTextField];
                        pickerTimeView.frame=rect;
                    }
                    completion:NULL];
}

//down moving toolbar with time picker
-(IBAction)downTimePicker:(id)sender
{
    fieldDetailTimeFrom.backgroundColor=[UIColor whiteColor];
    fieldDetailTimeTo.backgroundColor=[UIColor whiteColor];
    
    [UIView transitionWithView:pickerTimeView
                      duration:0.5f
                       options:animation
                    animations:^{
                        CGRect rect=pickerTimeView.frame;
                        rect.origin.y=pickerDownX;
                        pickerTimeView.frame=rect;
                    }
                    completion:NULL];
    [self textFieldDidEndEditing:currentTextField];
}

@end
