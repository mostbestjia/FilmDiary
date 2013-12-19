//
//  NewUser2ViewController.m
//  FilmDiary
//
//  Created by Yingjia Liu on 8/16/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import "NewUser2ViewController.h"
#import "NewUser3ViewController.h"
#import "util.h"
#import "LocationSelectionViewController.h"

@interface NewUser2ViewController ()

@property (strong, nonatomic) SignUpUser *suu;
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@end

@implementation NewUser2ViewController
@synthesize ImagePicker;

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
    self.suu = [SignUpUser getInstance];
    
    [self.SignupConfirm2.layer setCornerRadius:0.0f];
    [self.SignupConfirm2.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.SignupConfirm2.layer setBorderWidth:1.0f];  
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer: self.tap];
    
    self.EmailTextField.delegate = (id)self;
    
    [self.ProfileImage setBackgroundImage:[UIImage imageNamed:@"wrist_big.png"] forState:UIControlStateNormal];
    
    if (self.suu.userProfileImage)
    {
        [self.ProfileImage setBackgroundImage: self.suu.userProfileImage forState:UIControlStateNormal];
    }
    else
    {
        self.suu.userProfileImage = self.ProfileImage.currentBackgroundImage;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([self.suu.userProvinceString length]== 0)
    {
        [self.LocationString setTitle:@"省份" forState:UIControlStateNormal];
    }
    else
    {
        [self.LocationString setTitle:self.suu.userProvinceString forState:UIControlStateNormal];
    }
}

-(void)dismissKeyboard
{
    [self.EmailTextField endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)pushSignupConfirm2_0:(id)sender {//down
    [self.SignupConfirm2 setTitleColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.SignupConfirm2 setBackgroundColor:[UIColor colorWithRed:251/255.0f green:175/255.0f blue:29/255.0f alpha:1.0]];
    [self.SignupConfirm2.layer setBorderWidth:0.0f];
}

- (IBAction)pushSignupConfirm2:(id)sender {//up
    [self.SignupConfirm2 setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.SignupConfirm2.layer setCornerRadius:0.0f];
    [self.SignupConfirm2.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.SignupConfirm2 setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0]];
    [self.SignupConfirm2.layer setBorderWidth:1.0f];
    self.suu.useremail = self.EmailTextField.text;
    self.suu.userProfileImage = self.ProfileImage.currentBackgroundImage;
    
    UIStoryboard *storyboard;
    if (IS_IPHONE5)
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone5" bundle:nil];
    }
    else
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    }
    NewUser3ViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"NewUserController3"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)pushProfileImage_0:(id)sender {
    [self.ProfileImage setBackgroundImage:[UIImage imageNamed:@"wrist_small.png"] forState:UIControlStateNormal];
}

- (IBAction)pushProfileImage:(id)sender {
    [self.ProfileImage setBackgroundImage:[UIImage imageNamed:@"wrist_big.png"] forState:UIControlStateNormal];
    
    ImagePicker = [[UIImagePickerController alloc]init];
    ImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ImagePicker.delegate = (id)self;
    [self presentViewController:ImagePicker animated:YES completion: nil];
}

- (IBAction)EmailEditBegin:(id)sender {
    [self.NewUserScrollView2 setContentOffset:CGPointMake(0, 160)];
}

- (IBAction)EmailEditEnd:(id)sender {
    [self.NewUserScrollView2 setContentOffset:CGPointMake(0, 0)];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    [self.ProfileImage setImage:[info objectForKey:UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
    [self.ProfileImage setBackgroundImage:[info objectForKey:UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    CGSize imageSize = self.ProfileImage.imageView.image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat newDimension = MIN(width, height);
    CGFloat widthOffset = (width - newDimension) / 2;
    CGFloat heightOffset = (height - newDimension) / 2;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(newDimension, newDimension), NO, 0.);
    [self.ProfileImage.imageView.image drawAtPoint:CGPointMake(-widthOffset, -heightOffset)
                                         blendMode:kCGBlendModeCopy
                                             alpha:1.];
    self.ProfileImage.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.suu.userProfileImage = self.ProfileImage.currentBackgroundImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.EmailTextField) {
        [self dismissKeyboard];
        self.suu.useremail = self.EmailTextField.text;
        self.suu.userProfileImage = self.ProfileImage.currentBackgroundImage;
        
        UIStoryboard *storyboard;
        if (IS_IPHONE5)
        {
            storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone5" bundle:nil];
        }
        else
        {
            storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        }
        NewUser3ViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"NewUserController3"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    return NO;
}
- (IBAction)pushSignupConfirm2_1:(id)sender {
    [self.SignupConfirm2 setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.SignupConfirm2.layer setCornerRadius:0.0f];
    [self.SignupConfirm2.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.SignupConfirm2 setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0]];
    [self.SignupConfirm2.layer setBorderWidth:1.0f];
}

- (IBAction)pushSelectLocation:(id)sender {
    
    UIStoryboard *storyboard;
    if (IS_IPHONE5)
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone5" bundle:nil];
    }
    else
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    }
    LocationSelectionViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"LocationSelectionViewController"];
    [self presentViewController:viewController animated:YES completion:^{}];
}
@end
