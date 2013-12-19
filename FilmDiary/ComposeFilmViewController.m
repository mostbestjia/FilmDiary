//
//  ComposeFilmViewController.m
//  FilmDiary
//
//  Created by Yingjia Liu on 7/16/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import "ComposeFilmViewController.h"
#import "AzureUserInterface.h"
#import <QuartzCore/QuartzCore.h>
#import "HubViewController.h"
#import "SubmitDiaryAnimationViewController.h"
#import "util.h"
#import "errorViewController.h"

static bool imagePickerTouched;
static int scrollViewHeight = 542 + 20;
static bool imageSelected = false;
@interface ComposeFilmViewController ()
@property (strong, nonatomic)   AzureUserInterface   *getUserService;
@end

@implementation ComposeFilmViewController

@synthesize ImagePicker, ComposePicBackGround;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    // Need to set the scroll view content size here
//    [self.ComposeScroll.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
//    [self.ComposeScroll.layer setBorderWidth:2.0f];
    self.ComposeScroll.contentSize = CGSizeMake(310, scrollViewHeight);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    imagePickerTouched = false;
    
    [self.LoadingImageView setHidden:YES];
    [self.LoadingIndicator setHidden:YES];
    
    self.DiaryTitle.delegate = (id)self;
    self.DiaryContent.delegate = (id)self;
    self.DiaryContentTextView.delegate = (id)self;
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_rest.png"] forState:UIControlStateNormal];
    [self.CameraButton setBackgroundImage:[UIImage imageNamed:@"camera_big.png"] forState:UIControlStateNormal];
    [self.PhotoButton setBackgroundImage:[UIImage imageNamed:@"alb_big.png"] forState:UIControlStateNormal];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerTapped:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.ComposePicBackGround addGestureRecognizer:singleTap];
    [self.ComposePicBackGround setUserInteractionEnabled:YES];    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer: tap];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardAppear:) name:UIKeyboardWillShowNotification object:nil];
    
    self.getUserService = [AzureUserInterface defaultService];
    
    [self.SubmitButton.layer setCornerRadius:0.0f];
    [self.SubmitButton.layer setBorderColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0].CGColor];
    [self.SubmitButton.layer setBorderWidth:1.0f];
}

-(void)onKeyboardAppear:(NSNotification *)notification
{
    //keyboard will hide
    if (self.DiaryContent.isFirstResponder)
    {
        //keyboard is 216
        // 542+216
        self.ComposeScroll.contentSize = CGSizeMake(310, scrollViewHeight + 216);
        // 542-216
        [self.ComposeScroll setContentOffset:CGPointMake(0, scrollViewHeight - 216) animated:YES];
    }
    else if (self.DiaryTitle.isFirstResponder)
    {
        // 542+216
        self.ComposeScroll.contentSize = CGSizeMake(310, scrollViewHeight + 216);
        // 542-216
        [self.ComposeScroll setContentOffset:CGPointMake(0, scrollViewHeight - 216) animated:YES];
    }
    else if (self.DiaryContentTextView.isFirstResponder)
    {
        //keyboard is 216
        // 542+216
        self.ComposeScroll.contentSize = CGSizeMake(310, scrollViewHeight + 216);
        // 542-216
        [self.ComposeScroll setContentOffset:CGPointMake(0, scrollViewHeight - 216) animated:YES];
    }
}

-(void)dismissKeyboard
{
    [self.ComposeScroll resignFirstResponder];
    [self.ComposeScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    self.ComposeScroll.contentSize = CGSizeMake(310, scrollViewHeight);
    [self.DiaryContent endEditing:YES];
    [self.DiaryTitle endEditing:YES];
    [self.DiaryContentTextView endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.DiaryTitle) {
        [self.DiaryContentTextView becomeFirstResponder];
        //keyboard is 216
        // 542+216
        self.ComposeScroll.contentSize = CGSizeMake(310, scrollViewHeight + 216);
        // 542-216
        [self.ComposeScroll setContentOffset:CGPointMake(0, scrollViewHeight - 216) animated:YES];
    }
    else if(textField == self.DiaryContent) {

    }
    return NO;
}


- (IBAction)pushBackButton_0:(id)sender {
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_pressed.png"] forState:UIControlStateNormal];
}

- (IBAction)pushBackButton:(id)sender {
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_rest.png"] forState:UIControlStateNormal];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"现在退出将会丢失胶片进度哦！"
                                                   delegate:self
                                          cancelButtonTitle:@"确定退出"
                                          otherButtonTitles:@"返回编辑",nil];
    alert.tag = 0;
    [alert show];
}

- (IBAction)pushCameraButton_0:(id)sender {
    [self.CameraButton setBackgroundImage:[UIImage imageNamed:@"camera_small.png"] forState:UIControlStateNormal];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == 0 && alertView.tag == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (buttonIndex == 1 && alertView.tag == 1)
    {
        [self PostFilmDiary];
    }
}

- (void)PostFilmDiary
{
    NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString];
    
    [self.view setUserInteractionEnabled:NO];
    [self.LoadingImageView setHidden:NO];
    [self.LoadingIndicator setHidden:NO];
    [self.LoadingIndicator startAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.getUserService getSasUrlForNewBlob:guid forContainer:@"filmdiarypic" withCompletion:^(NSString *sasUrl) {
        
        NSLog(@"\r\nPUT\r\n\t%@\r\n\t----->\r\n\t%@", guid, sasUrl);
        if (sasUrl != nil)
        {
            //Upload table entity
            NSDate *currentDate = [NSDate date];
            NSCalendar* calendar = [NSCalendar currentCalendar];
            NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate]; // Get necessary date components
            int year = [components year];
            int month = [components month];
            int day = [components day];
            NSString *submitDateString = [[NSString alloc] initWithFormat:@"%d年%d月%d日",year,month,day ];
            //To convert back, use initWithTimeIntervalSinceReferenceDate
            double secondsInterval = [[NSDate date] timeIntervalSince1970];
            
            __weak typeof(self) weakSelf = self;
            NSDictionary *item = @{
                                   @"userID": [NSNumber numberWithInteger: weakSelf.getUserService.userid],
                                   @"provinceID": [NSNumber numberWithInteger: weakSelf.getUserService.provinceid],
                                   @"username": weakSelf.getUserService.username,
                                   @"diaryTitle" : (weakSelf.DiaryTitle.text.length ==0) ? @"无标题":weakSelf.DiaryTitle.text,
                                   @"diaryContent": (weakSelf.DiaryContentTextView.text.length ==0) ? @"无正文":weakSelf.DiaryContentTextView.text,
                                   @"diaryPicUrl": [[NSString alloc] initWithFormat: @"http://filmdiarydata.blob.core.windows.net/filmdiarypic/%@", guid],
                                   @"diaryDate" : submitDateString,
                                   @"diarySecondsInterval": [NSNumber numberWithDouble:secondsInterval],
                                   @"diaryScore": [NSNumber numberWithInteger:0],
                                   @"diaryViewCount": [NSNumber numberWithInteger:0],
                                   @"diaryFirstWatchListedTime": [NSNumber numberWithInteger:0],
                                   @"diaryRedeemed": @NO,
                                   };
            
            [weakSelf.getUserService updateUserScore:1 completion:^{
                
            }];
            
            [weakSelf.getUserService addFilmDiary:item completion:^{
                //Upload picture
                CGSize newSize = CGSizeMake(290.f, 290.f);
                UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
                [self.ComposePicBackGround.image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
                NSData *imageData = UIImageJPEGRepresentation(UIGraphicsGetImageFromCurrentImageContext(), 1);
                UIGraphicsEndImageContext();
                
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:sasUrl]];
                [request setHTTPMethod:@"PUT"];
//                [request addValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:imageData];
                // Default is 60
                [request setTimeoutInterval:80];
                [request setValue:@"BlockBlob"  forHTTPHeaderField:@"x-ms-blob-type"];
                [request setValue:[NSString stringWithFormat:@"%d", [imageData length]] forHTTPHeaderField:@"Content-Length"];
                
                NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                
                [conn start];
                if (conn) {
                    // Create the NSMutableData to hold the received data.
                    // receivedData is an instance variable declared elsewhere.
                    _receivedData = [[NSMutableData alloc] init];
                    [_receivedData setLength:0];
                    [self.LoadingIndicator stopAnimating];
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    long date = year * 10000 + month * 100 + day;
                    NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
                    NSString *RatingKey = [[NSString alloc]initWithFormat:@"LAST_COMPOSE_%@",self.getUserService.username];
                    [stdDefaults setInteger:date forKey:RatingKey];
                    
                    UIStoryboard *storyboard;
                    if (IS_IPHONE5)
                    {
                        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone5" bundle:nil];
                    }
                    else
                    {
                        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
                    }
                    SubmitDiaryAnimationViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"SubmitDiaryAnimationViewController"];
                    [self presentViewController:viewController animated:YES completion:^{
                        [self.navigationController popViewControllerAnimated:NO];
                    }];
                    
                } else {
                    // Inform the user that the connection failed.
                    [self errorCase];
                }
            }];
        }
        else
        {
            [self errorCase];
        }
    }];
}

- (void)errorCase
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.LoadingIndicator stopAnimating];
    [self.LoadingIndicator setHidden:YES];
    [self.LoadingImageView setHidden:YES];
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
    errorViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"errorViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)pushCameraButton:(id)sender {
    [self.CameraButton setBackgroundImage:[UIImage imageNamed:@"camera_big.png"] forState:UIControlStateNormal];
    ImagePicker = [[UIImagePickerController alloc]init];
    ImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    //Create camera overlay
    if (!IS_OS_7_OR_LATER)
    {
        CGRect f = ImagePicker.view.bounds;
        f.size.height -= ImagePicker.navigationBar.bounds.size.height;
        CGFloat barHeight = (f.size.height - f.size.width) / 2;
        UIGraphicsBeginImageContext(f.size);
        [[UIColor colorWithWhite:0 alpha:.66] set];
        UIRectFillUsingBlendMode(CGRectMake(0, 0, f.size.width, barHeight), kCGBlendModeNormal);
        UIRectFillUsingBlendMode(CGRectMake(0, f.size.height - barHeight, f.size.width, barHeight), kCGBlendModeNormal);
        UIImage *overlayImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIImageView *overlayIV = [[UIImageView alloc] initWithFrame:f];
        overlayIV.image = overlayImage;
        [ImagePicker.cameraOverlayView addSubview:overlayIV];
        
    }
    
    ImagePicker.delegate = (id)self;
    [self presentViewController:ImagePicker animated:YES completion: nil];

}

- (IBAction)pushPhotoButton_0:(id)sender {
    [self.PhotoButton setBackgroundImage:[UIImage imageNamed:@"alb_small.png"] forState:UIControlStateNormal];
}

- (IBAction)pushPhotoButton:(id)sender {
    [self.PhotoButton setBackgroundImage:[UIImage imageNamed:@"alb_big.png"] forState:UIControlStateNormal];
    ImagePicker = [[UIImagePickerController alloc]init];
    ImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ImagePicker.delegate = (id)self;
    [self presentViewController:ImagePicker animated:YES completion: nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *uiImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.ComposePicBackGround.image = uiImage;
    
    imagePickerTouched = true;
    [self.CameraButton setHidden:YES];
    [self.PhotoButton setHidden:YES];
    
    imageSelected = true;
    
    //Crop the image to a square
    CGSize imageSize = self.ComposePicBackGround.image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat newDimension = MIN(width, height);
    CGFloat widthOffset = (width - newDimension) / 2;
    CGFloat heightOffset = (height - newDimension) / 2;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(newDimension, newDimension), NO, 0.);
    [self.ComposePicBackGround.image drawAtPoint:CGPointMake(-widthOffset, -heightOffset)
                                       blendMode:kCGBlendModeCopy
                                           alpha:1.];
    self.ComposePicBackGround.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)bannerTapped:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"%@", [gestureRecognizer view]);
    if(!imagePickerTouched)
    {
        imagePickerTouched = true;
        [self.CameraButton setHidden:YES];
        [self.PhotoButton setHidden:YES];
    }
    else
    {
        imagePickerTouched = false;
        [self.CameraButton setHidden:NO];
        [self.PhotoButton setHidden:NO];
        self.CameraButton.alpha = 0.8; //Alpha runs from 0.0 to 1.0
        self.PhotoButton.alpha = 0.8; //Alpha runs from 0.0 to 1.0

    }
}

- (IBAction)EditDiaryTitleBegin:(id)sender {
    //keyboard is 216
    // 542+216
    self.ComposeScroll.contentSize = CGSizeMake(310, scrollViewHeight + 216);
    // 542-216
    [self.ComposeScroll setContentOffset:CGPointMake(0, scrollViewHeight - 216) animated:YES];}

- (IBAction)EditDiaryTitleEnd:(id)sender {
    [self.ComposeScroll setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (IBAction)EditDiaryBodyBegin:(id)sender {
}

- (IBAction)EditDiaryBodyEnd:(id)sender {
    [self.ComposeScroll setContentOffset:CGPointMake(0, 0) animated:YES];
}


+(NSString *)getUUID
{
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    NSString * uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    CFRelease(newUniqueId);
    
    return uuidString;
}

-(void)connection:(NSConnection*)conn didReceiveResponse:
(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ([httpResponse statusCode] >= 400) {
        NSLog(@"Status Code: %i", [httpResponse statusCode]);
        NSLog(@"Remote url returned error %d %@",[httpResponse statusCode],[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
    }
    else {
        NSLog(@"Safe Response Code: %i", [httpResponse statusCode]);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:
(NSData *)data
{
    [_receivedData appendData:data];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:
(NSError *)error
{
    //We should do something more with the error handling here
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:
           NSURLErrorFailingURLStringErrorKey]);
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *txt = [[NSString alloc] initWithData:_receivedData encoding: NSASCIIStringEncoding];
    NSLog(@"%@", txt);
    //pop the current view
    [self.navigationController popViewControllerAnimated:YES];
    //Posting message to refresh containers
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshBlobs" object:nil];
}

- (IBAction)pushSubmit_0:(id)sender {
    [self.SubmitButton.layer setBackgroundColor:[UIColor colorWithRed:229/255.0f green:118/255.0f blue:35/255.0f alpha:1.0].CGColor];
}

- (IBAction)pushSubmit:(id)sender {
    [self.SubmitButton.layer setBackgroundColor:[UIColor colorWithRed:251/255.0f green:176/255.0f blue:59/255.0f alpha:1.0].CGColor];
    
    self.ComposeScroll.contentSize = CGSizeMake(310, scrollViewHeight);
    [self.ComposeScroll setContentOffset:CGPointMake(0, 0)];
    
    if (self.DiaryTitle.text.length != 0 && self.DiaryContentTextView.text.length != 0 && imageSelected)
    {
        [self PostFilmDiary];
    }
    else if (!imageSelected)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"胶片不能没有照片哦！"
                                                       delegate:self
                                              cancelButtonTitle:@"返回编辑"
                                              otherButtonTitles:nil,nil];
        alert.tag = 3;
        [alert show];
    }
    else if(self.DiaryTitle.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"胶片不能没有标题哦！"
                                                       delegate:self
                                              cancelButtonTitle:@"返回编辑"
                                              otherButtonTitles:nil,nil];
        alert.tag = 2;
        [alert show];
    }
    else if(self.DiaryContentTextView.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"添加正文会让你的胶片更加精彩！"
                                                       delegate:self
                                              cancelButtonTitle:@"返回编辑"
                                              otherButtonTitles:@"确定发布",nil];
        alert.tag = 1;
        [alert show];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self.TextLimit setText: [NSString stringWithFormat:@"%d/100", self.DiaryContentTextView.text.length]];
}

- (IBAction)ContentTextChanged:(id)sender {
    if (self.DiaryContent.text.length >= 100)
    {
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == self.DiaryContentTextView)
    {
        [self.DiaryContent setPlaceholder:@""];
        //keyboard is 216
        // 542+216
        self.ComposeScroll.contentSize = CGSizeMake(310, scrollViewHeight + 216);
        // 542-216
        [self.ComposeScroll setContentOffset:CGPointMake(0, scrollViewHeight - 216) animated:YES];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.ComposeScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    if (textView == self.DiaryContentTextView && textView.text.length == 0)
    {
        [self.DiaryContent setPlaceholder:@"                   正文(100字以内)"];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return textView.text.length + (text.length - range.length) <= 100;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)text
{
    if (textField == self.DiaryTitle)
    {
        return textField.text.length + (text.length - range.length) <= 20;
    }
    else
    {
        return YES;
    }
}

- (IBAction)pushSubmit_1:(id)sender {
    [self.SubmitButton.layer setBackgroundColor:[UIColor colorWithRed:251/255.0f green:176/255.0f blue:59/255.0f alpha:1.0].CGColor];
}

- (IBAction)pushBackButton_1:(id)sender {
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_rest.png"] forState:UIControlStateNormal];
}
- (IBAction)pushComposeFirstRunBtn:(id)sender {
    [self.ComposeFirstRunBtn setHidden: YES];
}
@end
