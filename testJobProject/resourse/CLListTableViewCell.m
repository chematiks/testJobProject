//
//  CLListTableViewCell.m
//  testJobProject
//
//  Created by Администратор on 9/27/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import "CLListTableViewCell.h"
#import "constants.h"

@implementation CLListTableViewCell

@synthesize surnameNameLabel=_surnameNameLabel;
@synthesize salaryLabel=_salaryLabel;
@synthesize hourLabel=_hourLabel;
@synthesize numberWorkPlaceLabel=_numberWorkPlaceLabel;
@synthesize typeBookkeepingLabel=_typeBookkeepingLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // create all element in cell
        _mainViewCell=[[UIView alloc] initWithFrame:CGRectMake(0,0,320,rowHeigth)];
        
        _surnameNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, 2, 300, 15)];
        _surnameNameLabel.font=[UIFont systemFontOfSize:13];
        _surnameNameLabel.textColor=[UIColor blackColor];
        
        _salaryLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, 18, 100, 15)];
        _salaryLabel.font=[UIFont systemFontOfSize:11];
        _salaryLabel.textColor=[UIColor blackColor];
        
        _hourLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, 33, 300, 15)];
        _hourLabel.font=[UIFont systemFontOfSize:11];
        _hourLabel.textColor=[UIColor blackColor];
        
        _numberWorkPlaceLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, 33, 300, 15)];
        _numberWorkPlaceLabel.font=[UIFont systemFontOfSize:11];
        _numberWorkPlaceLabel.textColor=[UIColor blackColor];
        _numberWorkPlaceLabel.textAlignment=NSTextAlignmentRight;
        
        _typeBookkeepingLabel=[[UILabel alloc] initWithFrame:CGRectMake(150, 18, 300, 15)];
        _typeBookkeepingLabel.font=[UIFont systemFontOfSize:11];
        _typeBookkeepingLabel.textColor=[UIColor blackColor];
        _typeBookkeepingLabel.textAlignment=NSTextAlignmentRight;

        [_mainViewCell addSubview:_surnameNameLabel];
        [_mainViewCell addSubview:_salaryLabel];
        [_mainViewCell addSubview:_hourLabel];
        [_mainViewCell addSubview:_numberWorkPlaceLabel];
        [_mainViewCell addSubview:_typeBookkeepingLabel];
        [self addSubview:_mainViewCell];
    }
    return self;
}

//if style cell = editing, then shift all element rigth to 45 pixels
-(void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    int dRigth=50;
    int dLeft=5;
    if (editing)
    {
        CGRect rect=_surnameNameLabel.frame;
        rect.origin.x=dRigth;
        _surnameNameLabel.frame=rect;
        rect=_salaryLabel.frame;
        rect.origin.x=dRigth;
        _salaryLabel.frame=rect;
        rect=_hourLabel.frame;
        rect.origin.x=dRigth;
        _hourLabel.frame=rect;
        rect=_numberWorkPlaceLabel.frame;
        rect.origin.x=dRigth;
        _numberWorkPlaceLabel.frame=rect;
        rect=_typeBookkeepingLabel.frame;
        rect.origin.x=dRigth;
        _typeBookkeepingLabel.frame=rect;
    }
    else
    {
        CGRect rect=_surnameNameLabel.frame;
        rect.origin.x=dLeft;
        _surnameNameLabel.frame=rect;
        rect=_salaryLabel.frame;
        rect.origin.x=dLeft;
        _salaryLabel.frame=rect;
        rect=_hourLabel.frame;
        rect.origin.x=dLeft;
        _hourLabel.frame=rect;
        rect=_numberWorkPlaceLabel.frame;
        rect.origin.x=dLeft;
        _numberWorkPlaceLabel.frame=rect;
        rect=_typeBookkeepingLabel.frame;
        rect.origin.x=dLeft;
        _typeBookkeepingLabel.frame=rect;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
