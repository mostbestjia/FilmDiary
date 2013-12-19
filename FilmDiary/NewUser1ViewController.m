//
//  NewUser1ViewController.m
//  FilmDiary
//
//  Created by Yingjia Liu on 8/16/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import "NewUser1ViewController.h"
#import "NewUser2ViewController.h"
#import "util.h"
#import "TermsOfUseViewController.h"

@interface NewUser1ViewController ()

// Private properties
@property (strong, nonatomic)   AzureUserInterface   *addUserService;
@property (strong, nonatomic) SignUpUser *suu;
@end

static bool TOURead = YES;

@implementation NewUser1ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
	// Do any additional setup after loading the view.
    
    [self.SignupConfirm1.layer setCornerRadius:0.0f];
    [self.SignupConfirm1.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.SignupConfirm1.layer setBorderWidth:1.0f];
    [self.spiningSignup1 setHidden:YES];
    [self.passwordNotMatch setHidden:YES];
    [self.UserAlreadyExists setHidden:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer: tap];
    self.suu = [SignUpUser getInstance];
    self.addUserService = [AzureUserInterface defaultService];
    
    self.NiChengTextField.delegate = (id)self;
    self.Password2TextField.delegate = (id)self;
    self.Password1TextField.delegate = (id)self;
    [self.TOULabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap)];
    [self.TOULabel addGestureRecognizer:tapGesture];

}

-(void)labelTap
{
    UIStoryboard *storyboard;
    if (IS_IPHONE5)
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone5" bundle:nil];
    }
    else
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    }
    TermsOfUseViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"TermsOfUseViewController"];
    [self presentViewController:viewController animated:YES completion:^{}];
}

-(void)dismissKeyboard
{
    [self.NiChengTextField endEditing:YES];
    [self.Password1TextField endEditing:YES];
    [self.Password2TextField endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushSignupConfirm1:(id)sender {//up
    [self.SignupConfirm1 setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.SignupConfirm1.layer setCornerRadius:0.0f];
    [self.SignupConfirm1.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.SignupConfirm1 setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0]];
    [self.SignupConfirm1.layer setBorderWidth:1.0f];

    [self.passwordNotMatch setHidden:YES];
    
    //Check password
    if (![self.Password1TextField.text isEqualToString: self.Password2TextField.text])
    {
        [self.passwordNotMatch setHidden:NO];
        [self.spiningSignup1 stopAnimating];
        [self.spiningSignup1 setHidden:YES];
    }
    else
    {
        self.suu.username=self.NiChengTextField.text;
        //Check user existence
        [self.view setUserInteractionEnabled:NO];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [self.addUserService refreshUser:self.suu.username completion:^(NSArray *results)
         {
             __weak typeof(self) weakSelf = self;
             if (results.count > 0)
             {
                 //Error
                 [weakSelf.UserAlreadyExists setHidden:NO];
                 [weakSelf.spiningSignup1 stopAnimating];
                 [weakSelf.spiningSignup1 setHidden:YES];
                 [self.view setUserInteractionEnabled:YES];
             }
             else if (self.Password2TextField.text.length == 0)
             {
                 [self.spiningSignup1 stopAnimating];
                 [self.spiningSignup1 setHidden:YES];
                 [self.view setUserInteractionEnabled:YES];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:@"密码不可为空"
                                                                delegate:self
                                                       cancelButtonTitle:@"返回编辑"
                                                       otherButtonTitles:nil,nil];
                 alert.tag = 0;
                 [alert show];
             }

             else if (self.NiChengTextField.text.length == 0)
             {
                 [self.spiningSignup1 stopAnimating];
                 [self.spiningSignup1 setHidden:YES];
                 [self.view setUserInteractionEnabled:YES];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:@"昵称不可为空"
                                                                delegate:self
                                                       cancelButtonTitle:@"返回编辑"
                                                       otherButtonTitles:nil,nil];
                 alert.tag = 1;
                 [alert show];
             }
             else if (!TOURead)
             {
                 [self.spiningSignup1 stopAnimating];
                 [self.spiningSignup1 setHidden:YES];
                 [self.view setUserInteractionEnabled:YES];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:@"请先接受使用条款和隐私政策"
                                                                delegate:self
                                                       cancelButtonTitle:@"返回"
                                                       otherButtonTitles:nil,nil];
                 alert.tag = 2;
                 [alert show];
             }
             else
             {
                 self.suu.userpassword=self.Password2TextField.text;
                 //Go to page 2
                 NSDictionary *item = @{ @"name" : weakSelf.suu.username,
                                         @"email": @"",
                                         @"password": weakSelf.suu.userpassword,
                                         @"location" : [NSNumber numberWithInteger:-1],
                                         @"profilePic": @"",
                                         @"description": @"",
                                         @"score": [NSNumber numberWithInteger:0]};
                 [weakSelf.addUserService addUser:item completion:^{
                     [weakSelf.addUserService refreshUser:weakSelf.suu.username completion:^(NSArray *results){
                         [weakSelf.spiningSignup1 stopAnimating];
                         [weakSelf.spiningSignup1 setHidden:YES];
                         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                         [self.view setUserInteractionEnabled:YES];
                         UIStoryboard *storyboard;
                         if (IS_IPHONE5)
                         {
                             storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone5" bundle:nil];
                         }
                         else
                         {
                             storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
                         }
                         NewUser2ViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"NewUserController2"];
                         [self.navigationController pushViewController:viewController animated:YES];
                      }];
                 }];
             }
         }];
    }
}

- (IBAction)pushSignupConfirm1_0:(id)sender {//down
    [self.SignupConfirm1 setTitleColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.SignupConfirm1 setBackgroundColor:[UIColor colorWithRed:251/255.0f green:175/255.0f blue:29/255.0f alpha:1.0]];
    [self.SignupConfirm1.layer setBorderWidth:0.0f];
    [self.spiningSignup1 setHidden:NO];
    [self.passwordNotMatch setHidden:YES];
    [self.spiningSignup1 startAnimating];
}

- (IBAction)NiChengEditBegin:(id)sender {
    [self.NewUserScrollView1 setContentOffset:CGPointMake(0, 125) animated:YES];
    
}
- (IBAction)NiChengEditEnd:(id)sender {
    [self.NewUserScrollView1 setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (IBAction)Password1EditBegin:(id)sender {
    [self.Password1TextField setSecureTextEntry:YES];
    [self.NewUserScrollView1 setContentOffset:CGPointMake(0, 125) animated:YES];
}

- (IBAction)Password1EditEnd:(id)sender {
    if (![self.Password1TextField.text length])
    {
        //iOS bug here
        //        [self.Password1TextField setSecureTextEntry:NO];
        //        [self.Password1TextField setText:@"密码"];
    }
    [self.NewUserScrollView1 setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (IBAction)Password2EditBegin:(id)sender {
    [self.NewUserScrollView1 setContentOffset:CGPointMake(0, 125) animated:YES];
    [self.Password2TextField setSecureTextEntry:YES];
}

- (IBAction)Password2EditEnd:(id)sender {
    if (![self.Password2TextField.text length])
    {
        //iOS bug here
        //        [self.Password2TextField setSecureTextEntry:NO];
        //        [self.Password2TextField setText:@"确认密码"];
    }
    [self.NewUserScrollView1 setContentOffset:CGPointMake(0, 0) animated:YES];
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    textField.secureTextEntry = YES;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.NiChengTextField) {
        [self.Password1TextField becomeFirstResponder];
    }
    else if(textField == self.Password1TextField) {
        [self.Password2TextField becomeFirstResponder];        
    }
    else if(textField == self.Password2TextField) {
        [self dismissKeyboard];
        //Check password
        if (![self.Password1TextField.text isEqualToString: self.Password2TextField.text])
        {
            [self.passwordNotMatch setHidden:NO];
            [self.spiningSignup1 stopAnimating];
            [self.spiningSignup1 setHidden:YES];
        }
        else
        {
            self.suu.username=self.NiChengTextField.text;
            //Check user existence
            [self.view setUserInteractionEnabled:NO];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            [self.addUserService refreshUser:self.suu.username completion:^(NSArray *results)
             {
                 __weak typeof(self) weakSelf = self;
                 if (results.count > 0)
                 {
                     //Error
                     [weakSelf.UserAlreadyExists setHidden:NO];
                     [weakSelf.spiningSignup1 stopAnimating];
                     [weakSelf.spiningSignup1 setHidden:YES];
                     [self.view setUserInteractionEnabled:YES];
                 }
                 else if (self.Password2TextField.text.length == 0)
                 {
                     [self.spiningSignup1 stopAnimating];
                     [self.spiningSignup1 setHidden:YES];
                     [self.view setUserInteractionEnabled:YES];
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                     message:@"密码不可为空"
                                                                    delegate:self
                                                           cancelButtonTitle:@"返回编辑"
                                                           otherButtonTitles:nil,nil];
                     alert.tag = 0;
                     [alert show];
                 }
                 
                 else if (self.NiChengTextField.text.length == 0)
                 {
                     [self.spiningSignup1 stopAnimating];
                     [self.spiningSignup1 setHidden:YES];
                     [self.view setUserInteractionEnabled:YES];
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                     message:@"昵称不可为空"
                                                                    delegate:self
                                                           cancelButtonTitle:@"返回编辑"
                                                           otherButtonTitles:nil,nil];
                     alert.tag = 1;
                     [alert show];
                 }
                 else if (!TOURead)
                 {
                     [self.spiningSignup1 stopAnimating];
                     [self.spiningSignup1 setHidden:YES];
                     [self.view setUserInteractionEnabled:YES];
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                     message:@"请先接受使用条款和隐私政策"
                                                                    delegate:self
                                                           cancelButtonTitle:@"返回"
                                                           otherButtonTitles:nil,nil];
                     alert.tag = 2;
                     [alert show];
                 }
                 else
                 {
                     self.suu.userpassword=self.Password2TextField.text;
                     //Go to page 2
                     NSDictionary *item = @{ @"name" : weakSelf.suu.username,
                                             @"email": @"",
                                             @"password": weakSelf.suu.userpassword,
                                             @"location" : [NSNumber numberWithInteger:-1],
                                             @"profilePic": @"",
                                             @"description": @"",
                                             @"score": [NSNumber numberWithInteger:0]};
                     [weakSelf.addUserService addUser:item completion:^{
                         [weakSelf.addUserService refreshUser:weakSelf.suu.username completion:^(NSArray *results){
                             [weakSelf.spiningSignup1 stopAnimating];
                             [weakSelf.spiningSignup1 setHidden:YES];
                             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                             [self.view setUserInteractionEnabled:YES];
                             UIStoryboard *storyboard;
                             if (IS_IPHONE5)
                             {
                                 storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone5" bundle:nil];
                             }
                             else
                             {
                                 storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
                             }
                             NewUser2ViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"NewUserController2"];
                             [self.navigationController pushViewController:viewController animated:YES];
                         }];
                     }];
                 }
             }];
        }
    }
    return NO;
}

- (IBAction)pushSignupConfirm1_1:(id)sender {
    [self.SignupConfirm1 setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.SignupConfirm1.layer setCornerRadius:0.0f];
    [self.SignupConfirm1.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.SignupConfirm1 setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0]];
    [self.SignupConfirm1.layer setBorderWidth:1.0f];
}

- (IBAction)pushReadTOU:(id)sender {
    TOURead = !TOURead;
    if (TOURead)
    {
        [self.ReadTOU setBackgroundImage: [UIImage imageNamed:@"clicked.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.ReadTOU setBackgroundImage: [UIImage imageNamed:@"unclicked.png"] forState:UIControlStateNormal];
    }
}
@end
