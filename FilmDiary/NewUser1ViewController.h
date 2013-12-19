//
//  NewUser1ViewController.h
//  FilmDiary
//
//  Created by Yingjia Liu on 8/16/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AzureUserInterface.h"
#import "SignUpUser.h"

@interface NewUser1ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *SignupConfirm1;
- (IBAction)pushSignupConfirm1:(id)sender;//up
- (IBAction)pushSignupConfirm1_0:(id)sender;//down
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spiningSignup1;
@property (strong, nonatomic) IBOutlet UILabel *passwordNotMatch;
- (IBAction)NiChengEditBegin:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *NiChengTextField;
- (IBAction)NiChengEditEnd:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *Password1TextField;
@property (strong, nonatomic) IBOutlet UITextField *Password2TextField;
- (IBAction)Password1EditBegin:(id)sender;
- (IBAction)Password1EditEnd:(id)sender;
- (IBAction)Password2EditBegin:(id)sender;
- (IBAction)Password2EditEnd:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *NewUserScrollView1;
@property (strong, nonatomic) IBOutlet UILabel *UserAlreadyExists;
- (IBAction)pushSignupConfirm1_1:(id)sender;
- (IBAction)pushReadTOU:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *ReadTOU;
@property (strong, nonatomic) IBOutlet UILabel *TOULabel;

@end
