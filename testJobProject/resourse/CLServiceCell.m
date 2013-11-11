//
//  CLServiceCell.m
//  testJobProject
//
//  Created by Admin on 07.11.13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import "CLServiceCell.h"

@implementation CLServiceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UILabel * number=[[UILabel alloc] initWithFrame:CGRectMake(3, 1, 154, 8)];
        self.numberLabel=number;
        [number release];
        UILabel * date=[[UILabel alloc] initWithFrame:CGRectMake(157, 1, 154, 8)];
        self.dateLabel=date;
        [date release];
        
        UIFont * font=[UIFont boldSystemFontOfSize:10];
        self.numberLabel.font=font;
        self.numberLabel.textColor=[UIColor grayColor];
        
        self.dateLabel.font=font;
        self.dateLabel.textColor=[UIColor grayColor];
        self.dateLabel.textAlignment=NSTextAlignmentRight;
       
        [self addSubview:self.numberLabel];
        [self addSubview:self.dateLabel];
    
   }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
