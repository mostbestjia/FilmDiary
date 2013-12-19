//
//  DataViewController.h
//  FilmDiary
//
//  Created by Yingjia Liu on 4/20/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataViewController : UIViewController

@property (strong, nonatomic) id dataObject;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)nameEditBegin:(id)sender;
- (IBAction)passwordEditBegin:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *uiScrollView;
- (IBAction)nameEditEnd:(id)sender;
- (IBAction)passwordEditEnd:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *errorMsg;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinningDonut;
@property (strong, nonatomic) IBOutlet UIButton *SignUpBtn;
@property (strong, nonatomic) IBOutlet UIButton *AuthBtn;
- (IBAction)pushTermsOfUse:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *TOUBtn;
- (IBAction)pushSignup:(id)sender;
@end
