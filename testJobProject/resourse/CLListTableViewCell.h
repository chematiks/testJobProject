//
//  CLListTableViewCell.h
//  testJobProject
//
//  Created by Администратор on 9/27/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLListTableViewCell : UITableViewCell
{
    UIView * _mainViewCell;
    UILabel * _surnameNameLabel;
    UILabel * _salaryLabel;
    UILabel * _hourLabel;
    UILabel * _numberWorkPlaceLabel;
    UILabel * _typeBookkeeping;
}

@property (nonatomic,assign) UILabel * surnameNameLabel;
@property (nonatomic,assign) UILabel * salaryLabel;
@property (nonatomic,assign) UILabel * hourLabel;
@property (nonatomic,assign) UILabel * numberWorkPlaceLabel;
@property (nonatomic,assign) UILabel * typeBookkeepingLabel;

@end
