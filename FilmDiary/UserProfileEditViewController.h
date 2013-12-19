//
//  UserProfileEditViewController.h
//  FilmDiary
//
//  Created by Yingjia Liu on 9/5/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileEditViewController : UIViewController<UIImagePickerControllerDelegate>
{
    NSMutableData* _receivedData;
}
@property (strong, nonatomic) IBOutlet UIButton *ProvinceButton;
@property (strong, nonatomic) IBOutlet UITextField *EmailTextField;
@property (strong, nonatomic) IBOutlet UIScrollView *uiScrollView;
@property (strong, nonatomic) IBOutlet UITextView *DescriptionTextView;
@property (strong, nonatomic) IBOutlet UIButton *ProfileImageBtn;
- (IBAction)pushProfileImageBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *BackButton;
- (IBAction)pushBackButton_0:(id)sender;
- (IBAction)pushBackButton:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *UserName;
@property (strong, nonatomic) NSArray *LocationList;
- (IBAction)pushBackButton_1:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *SaveChangeBtn;
- (IBAction)pushSaveChangeBtn_0:(id)sender;
- (IBAction)pushSaveChangeBtn:(id)sender;
- (IBAction)pushSaveChangeBtn_1:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *EmailTextEditField;
@property (strong, nonatomic) UIImagePickerController *ImagePicker;
- (IBAction)EmailTextFieldEditBegin:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *LoadingImageView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *LoadingIndicator;
- (IBAction)EmailTextFieldChanged:(id)sender;
- (IBAction)EmailTextFieldEditEnd:(id)sender;
- (IBAction)pushSelectLocation:(id)sender;

@end
