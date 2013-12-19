//
//  UserProfileDisplayViewController.h
//  FilmDiary
//
//  Created by Yingjia Liu on 8/9/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileDisplayViewController : UIViewController<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *uiScrollView;
@property (strong, nonatomic) IBOutlet UIButton *BackButton;
- (IBAction)pushBackButton_0:(id)sender;
- (IBAction)pushBackButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *seeAllDiaries;
- (IBAction)pushSeeAllDiaries_0:(id)sender;
- (IBAction)pushSeeAllDiaries:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *UserProfileImage;
@property (strong, nonatomic) IBOutlet UILabel *UserName;
@property (strong, nonatomic) IBOutlet UILabel *UserProvinceString;
@property (strong, nonatomic) IBOutlet UILabel *UserTitle;
@property (strong, nonatomic) IBOutlet UILabel *UserScore;
@property (strong, nonatomic) IBOutlet UITextView *UserDescription;
@property (strong, nonatomic) NSArray *LocationList;
@property (strong, nonatomic) IBOutlet UIButton *LogOff;
- (IBAction)pushLogOff_0:(id)sender;
- (IBAction)pushLogOff:(id)sender;
@property (nonatomic) NSInteger fromWhichUser;
@property (strong, nonatomic) IBOutlet UIButton *EditProfile;
- (IBAction)pushEditProfile_0:(id)sender;
- (IBAction)pushEditProfile:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *UserScoreBarBackground;
- (IBAction)pushEditProfile_1:(id)sender;
- (IBAction)pushBackButton_1:(id)sender;
- (IBAction)pushSeeAllDiaries_1:(id)sender;
- (IBAction)pushLogOff_1:(id)sender;

@end
