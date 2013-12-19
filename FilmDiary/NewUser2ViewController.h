//
//  NewUser2ViewController.h
//  FilmDiary
//
//  Created by Yingjia Liu on 8/16/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SignUpUser.h"

@interface NewUser2ViewController : UIViewController<UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *SignupConfirm2;
- (IBAction)pushSignupConfirm2_0:(id)sender;//up
- (IBAction)pushSignupConfirm2:(id)sender;//down
@property (strong, nonatomic) IBOutlet UIButton *ProfileImage;
- (IBAction)pushProfileImage_0:(id)sender;
- (IBAction)pushProfileImage:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *EmailTextField;
@property (strong, nonatomic) IBOutlet UIButton *LocationString;
@property (strong, nonatomic) IBOutlet UIScrollView *NewUserScrollView2;
- (IBAction)EmailEditBegin:(id)sender;
- (IBAction)EmailEditEnd:(id)sender;
@property (strong, nonatomic) UIImagePickerController *ImagePicker;
- (IBAction)pushSignupConfirm2_1:(id)sender;
- (IBAction)pushSelectLocation:(id)sender;
@end
