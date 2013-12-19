//
//  UserProfileEditViewController.m
//  FilmDiary
//
//  Created by Yingjia Liu on 9/5/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import "UserProfileEditViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SignUpUser.h"
#import "AzureUserInterface.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserProfileDisplayViewController.h"
#import "util.h"
#import "LocationSelectionViewController.h"


@interface UserProfileEditViewController ()
@property (strong, nonatomic)   AzureUserInterface   *getUserService;
@property (strong, nonatomic) SignUpUser *suu;
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@end

@implementation UserProfileEditViewController


@synthesize ImagePicker;
@synthesize LocationList = _LocationList;


-(NSArray *) LocationList
{
    if(!_LocationList)
    {
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Location" ofType:@"plist"];
        _LocationList = [NSArray arrayWithContentsOfFile:plistPath];
    }
    
    return _LocationList;
}

- (IBAction)pushBackButton_1:(id)sender {
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_rest.png"] forState:UIControlStateNormal];
}

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
    [self.LoadingImageView setHidden:YES];
    [self.LoadingIndicator setHidden:YES];
    self.suu = [SignUpUser getInstance];    
    self.getUserService = [AzureUserInterface defaultService];
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_rest.png"] forState:UIControlStateNormal];
	// Do any additional setup after loading the view.
    [self.ProvinceButton.layer setCornerRadius:0.0f];
    [self.ProvinceButton.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.ProvinceButton setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0]];
    [self.ProvinceButton.layer setBorderWidth:1.0f];
    
    [self.EmailTextField.layer setCornerRadius:0.0f];
    [self.EmailTextField.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.EmailTextField setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0]];
    [self.EmailTextField.layer setBorderWidth:1.0f];
    
    
    [self.SaveChangeBtn.layer setCornerRadius:0.0f];
    [self.SaveChangeBtn.layer setBorderColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0].CGColor];
    [self.SaveChangeBtn.layer setBorderWidth:1.0f];
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer: self.tap];
    [self.DescriptionTextView.layer setCornerRadius:0.0f];
    [self.DescriptionTextView.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.DescriptionTextView setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0]];
    [self.DescriptionTextView.layer setBorderWidth:1.0f];
    
    
    self.DescriptionTextView.delegate = (id)self;
    self.EmailTextEditField.delegate = (id)self;
    
    self.UserName.text = [self.getUserService.loginUser[0] objectForKey:@"name"];
    if (self.suu.userProvinceIndex == -1)
    {
        self.suu.userProvinceIndex = [[self.getUserService.loginUser[0] objectForKey:@"location"] integerValue];
    }
    if ([self.suu.userProvinceString length]== 0)
    {
        if (self.suu.userProvinceIndex != -1)
        {
            self.suu.userProvinceString = [self.LocationList objectAtIndex:self.suu.userProvinceIndex];
            
            [self.ProvinceButton setTitle:[[NSString alloc]initWithFormat:@"   %@",self.suu.userProvinceString] forState:UIControlStateNormal];
        }
        else
        {
            [self.ProvinceButton setTitle:@"   暂未设定" forState:UIControlStateNormal];
        }
    }
    else
    {
        [self.ProvinceButton setTitle:[[NSString alloc]initWithFormat:@"   %@",self.suu.userProvinceString] forState:UIControlStateNormal];
    }
    
    if (self.suu.userProfileImage)
    {
        [self.ProfileImageBtn setImage:self.suu.userProfileImage forState:UIControlStateNormal];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:[self.getUserService.loginUser[0] objectForKey:@"profilePic"]];
        
        SDImageCache *cache = [[SDImageCache alloc]init];
        [cache queryDiskCacheForKey:[url absoluteString] done:^(UIImage *image, SDImageCacheType cacheType) {
            if (image)
            {
                [self.ProfileImageBtn setImage:image forState:UIControlStateNormal];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            }
            else
            {
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                    if (data) {
                        self.ProfileImageBtn.imageView.alpha = 0.0;
                        [UIView animateWithDuration:0.5 animations:^{
                            [self.ProfileImageBtn setImage:[[UIImage alloc] initWithData:data] forState:UIControlStateNormal];  // note the retain count here.
                            self.ProfileImageBtn.imageView.alpha = 1.0;
                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                            [[SDImageCache sharedImageCache]storeImage:self.ProfileImageBtn.imageView.image forKey:[url absoluteString]];
                        }];
                    } else {
                        // handle error
                    }
                }];
            }
        }];
    }
    
    if (self.suu.userDescription)
    {
        [self.DescriptionTextView setText:self.suu.userDescription];
    }
    else
    {
        self.DescriptionTextView.text = [self.getUserService.loginUser[0] objectForKey:@"description"];
    }
    if (self.DescriptionTextView.text.length == 0)
    {
        [self.DescriptionTextView setText:@"目前没有个人说明"];
    }
    
    if (self.suu.useremail)
    {
        [self.EmailTextEditField setText:self.suu.useremail];
    }
    else
    {
        self.EmailTextEditField.text = [self.getUserService.loginUser[0] objectForKey:@"email"];
    }
    if (self.EmailTextEditField.text.length)
    {
        [self.EmailTextField setPlaceholder:@""];
    }
    else
    {
        [self.EmailTextField setPlaceholder:@"   邮箱"];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.suu.userProvinceIndex == -1)
    {
        [self.ProvinceButton setTitle:@"   暂未设定" forState:UIControlStateNormal];
    }
    else
    {
        [self.ProvinceButton setTitle:[[NSString alloc]initWithFormat:@"   %@", self.suu.userProvinceString] forState:UIControlStateNormal];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.ProfileImageBtn setImage:[info objectForKey:UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    CGSize imageSize = self.ProfileImageBtn.imageView.image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat newDimension = MIN(width, height);
    CGFloat widthOffset = (width - newDimension) / 2;
    CGFloat heightOffset = (height - newDimension) / 2;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(newDimension, newDimension), NO, 0.);
    [self.ProfileImageBtn.imageView.image drawAtPoint:CGPointMake(-widthOffset, -heightOffset)
                                            blendMode:kCGBlendModeCopy
                                                alpha:1.];
    self.ProfileImageBtn.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.suu.userProfileImage = self.ProfileImageBtn.imageView.image;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dismissKeyboard
{
    [self.DescriptionTextView endEditing:YES];
    [self.EmailTextEditField endEditing:YES];
    self.uiScrollView.contentSize = CGSizeMake(280, 595);
    [self.uiScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textField {
    if(textField == self.DescriptionTextView) {
        [self.DescriptionTextView becomeFirstResponder];
        //keyboard is 216
        // 542+216
        self.uiScrollView.contentSize = CGSizeMake(280, 595 + 216);
        // 542-216
        [self.uiScrollView setContentOffset:CGPointMake(0, 595 - 216) animated:YES];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return textView.text.length + (text.length - range.length) <= 100;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLayoutSubviews
{
    // Need to set the scroll view content size here
    self.uiScrollView.contentSize = CGSizeMake(280, 595);
}

- (IBAction)pushProfileImageBtn:(id)sender {
    
    ImagePicker = [[UIImagePickerController alloc]init];
    ImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ImagePicker.delegate = (id)self;
    [self presentViewController:ImagePicker animated:YES completion: nil];
    
}

- (IBAction)pushBackButton_0:(id)sender {
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_pressed.png"] forState:UIControlStateNormal];
}

- (IBAction)pushBackButton:(id)sender {
    
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_rest.png"] forState:UIControlStateNormal];
    self.suu.useremail = nil;
    self.suu.userDescription = nil;
    self.suu.userProvinceString = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pushSaveChangeBtn_0:(id)sender {
    [self.SaveChangeBtn.layer setBackgroundColor:[UIColor colorWithRed:229/255.0f green:118/255.0f blue:35/255.0f alpha:1.0].CGColor];
}

- (IBAction)pushSaveChangeBtn:(id)sender {
    [self.SaveChangeBtn.layer setBackgroundColor:[UIColor colorWithRed:251/255.0f green:176/255.0f blue:59/255.0f alpha:1.0].CGColor];
    [self.uiScrollView setContentOffset:CGPointMake(0, 0)];
    
    [self.LoadingImageView setHidden:NO];
    [self.LoadingIndicator setHidden:NO];
    [self.LoadingIndicator startAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.view setUserInteractionEnabled:NO];
    [self.getUserService updateUserLocation:self.suu.userProvinceIndex completion:^{
        [self.getUserService updateUserEmail:self.EmailTextEditField.text completion:^{
            [self.getUserService updateUserDescription:self.DescriptionTextView.text completion:^{
                if (self.suu.userProfileImage)
                {
                    NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString];
                    [self.getUserService getSasUrlForNewBlob:guid forContainer:@"filmdiaryuserprofilepic" withCompletion:^(NSString *sasUrl) {
                        [self.getUserService updateUserProfilePic:[[NSString alloc] initWithFormat: @"http://filmdiarydata.blob.core.windows.net/filmdiaryuserprofilepic/%@", guid] completion:^{
                            
                            
                            NSLog(@"\r\nPUT\r\n\t%@\r\n\t----->\r\n\t%@", guid, sasUrl);
                            

                            CGSize newSize = CGSizeMake(260.f, 260.f);
                            UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
                            [self.suu.userProfileImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
                            NSData *imageData = UIImagePNGRepresentation(UIGraphicsGetImageFromCurrentImageContext());
                            UIGraphicsEndImageContext();
                            
                            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:sasUrl]];
                            [request setHTTPMethod:@"PUT"];
                            [request addValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
                            [request setHTTPBody:imageData];
                            
                            NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                            
                            if (conn) {
                                // Create the NSMutableData to hold the received data.
                                // receivedData is an instance variable declared elsewhere.
                                _receivedData = [[NSMutableData alloc] init];
                                [_receivedData setLength:0];
                                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                [self.LoadingIndicator stopAnimating];
                                [self.LoadingImageView setHidden:YES];
                                [self.LoadingIndicator setHidden:YES];
                                [[SDImageCache sharedImageCache]storeImage:self.suu.userProfileImage forKey:[[NSString alloc] initWithFormat: @"http://filmdiarydata.blob.core.windows.net/filmdiaryuserprofilepic/%@", guid]];
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                        }];
                    }];
                }
                else
                {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    [self.LoadingIndicator stopAnimating];
                    [self.LoadingImageView setHidden:YES];
                    [self.LoadingIndicator setHidden:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }];
    }];
}

- (IBAction)pushSaveChangeBtn_1:(id)sender {
    [self.SaveChangeBtn.layer setBackgroundColor:[UIColor colorWithRed:251/255.0f green:176/255.0f blue:59/255.0f alpha:1.0].CGColor];
}
- (IBAction)EmailTextFieldEditBegin:(id)sender {
    self.uiScrollView.contentSize = CGSizeMake(280, 500 + 216);
    // 542-216
    [self.uiScrollView setContentOffset:CGPointMake(0, 500 - 216) animated:YES];
}

- (IBAction)EmailTextFieldChanged:(id)sender {
    if (self.EmailTextEditField.text.length == 0)
    {
        self.EmailTextField.placeholder = @"   邮箱";
    }
    else
    {
        self.EmailTextField.placeholder = @"";
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.suu.userDescription = self.DescriptionTextView.text;
}

- (IBAction)EmailTextFieldEditEnd:(id)sender {
    self.suu.useremail = self.EmailTextEditField.text;
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
