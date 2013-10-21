//
//  CLServiceController.h
//  testJobProject
//
//  Created by Администратор on 9/23/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLServiceController : UIViewController

@property (nonatomic, retain) NSMutableArray * arrayNote;

@property (retain, nonatomic) IBOutlet UITextView *textView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *trobber;

-(void) loadDataXml;
-(void) showText;

@end
