//
//  DiaryViewController.h
//  FilmDiary
//
//  Created by Yingjia Liu on 8/8/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiaryViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *ComposeScroll;
@property (strong, nonatomic) IBOutlet UIImageView *ComposePicBackGround;
@property (strong, nonatomic) IBOutlet UIButton *BackButton;
- (IBAction)pushBackButton_0:(id)sender;
- (IBAction)pushBackButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *SaveDiaryButton;
- (IBAction)pushSaveDiaryButton:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *AuthorName;
@property (strong, nonatomic) IBOutlet UILabel *DiaryTitle;
@property (strong, nonatomic) IBOutlet UITextView *DiaryContent;
@property (strong, nonatomic) IBOutlet UILabel *DiaryDate;
@property(nonatomic) NSInteger fromWhichView;
- (IBAction)pushSeeComment:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *DiaryTopTitle;
- (IBAction)LaunchAuthor:(id)sender;
- (IBAction)LaunchAuthor_0:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *LaunchAuthorBtn;
@property (strong, nonatomic) IBOutlet UIImageView *DiaryBanner;
@property (strong, nonatomic) IBOutlet UILabel *DiaryBannerText;
- (IBAction)pushSeeAuthor_1:(id)sender;
- (IBAction)pushBackButton_1:(id)sender;
- (IBAction)pushReportSpam:(id)sender;


@end
