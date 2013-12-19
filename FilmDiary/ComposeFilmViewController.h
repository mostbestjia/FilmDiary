//
//  ComposeFilmViewController.h
//  FilmDiary
//
//  Created by Yingjia Liu on 7/16/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ComposeFilmViewController : UIViewController <UINavigationBarDelegate, UIImagePickerControllerDelegate, NSURLConnectionDelegate, UITextViewDelegate, UITextFieldDelegate>
{
    NSMutableData* _receivedData;
}


@property (strong, nonatomic) IBOutlet UIScrollView *ComposeScroll;
@property (strong, nonatomic) IBOutlet UIImageView *ComposePicBackGround;
@property (strong, nonatomic) IBOutlet UIButton *BackButton;
@property (strong, nonatomic) UIImagePickerController *ImagePicker;
- (IBAction)pushBackButton_0:(id)sender;
- (IBAction)pushBackButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *CameraButton;
@property (strong, nonatomic) IBOutlet UIButton *PhotoButton;
- (IBAction)pushCameraButton_0:(id)sender;
- (IBAction)pushCameraButton:(id)sender;
- (IBAction)pushPhotoButton_0:(id)sender;
- (IBAction)pushPhotoButton:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *DiaryTitle;
- (IBAction)EditDiaryTitleBegin:(id)sender;
- (IBAction)EditDiaryTitleEnd:(id)sender;
- (IBAction)EditDiaryBodyBegin:(id)sender;
- (IBAction)EditDiaryBodyEnd:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *SubmitButton;
- (IBAction)pushSubmit_0:(id)sender;
- (IBAction)pushSubmit:(id)sender;
- (IBAction)ContentTextChanged:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *TextLimit;
@property (strong, nonatomic) IBOutlet UITextField *DiaryContent;
- (IBAction)pushSubmit_1:(id)sender;
- (IBAction)pushBackButton_1:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *DiaryContentTextView;
@property (strong, nonatomic) IBOutlet UIImageView *LoadingImageView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *LoadingIndicator;
@property (strong, nonatomic) IBOutlet UIButton *ComposeFirstRunBtn;
- (IBAction)pushComposeFirstRunBtn:(id)sender;

@end
