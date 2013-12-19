//
//  RatingViewController.h
//  FilmDiary
//
//  Created by Yingjia Liu on 7/23/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatingViewController : UIViewController<UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *RatingPlus;
@property (strong, nonatomic) IBOutlet UIButton *RatingMinus;

- (IBAction)pushRatingPlus_0:(id)sender;
- (IBAction)pushRatingPlus:(id)sender;
- (IBAction)pushRatingMinus_0:(id)sender;
- (IBAction)pushRatingMinus:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *FirstRunBtn;
- (IBAction)PushFirstRunBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *ScoreLabel;
@property (strong, nonatomic) IBOutlet UIButton *img1;
@property (strong, nonatomic) IBOutlet UIButton *img2;
@property (strong, nonatomic) IBOutlet UIImageView *rating_bar;
@property (strong, nonatomic) IBOutlet UIButton *img3;
@property (strong, nonatomic) IBOutlet UIButton *img4;
@property (strong, nonatomic) IBOutlet UIButton *img5;
@property (strong, nonatomic) IBOutlet UIButton *img6;
@property (strong, nonatomic) IBOutlet UIButton *img7;
@property (strong, nonatomic) IBOutlet UIButton *img8;
@property (strong, nonatomic) IBOutlet UIButton *img9;

- (IBAction)img1Touch:(id)sender;
- (IBAction)img2Touch:(id)sender;
- (IBAction)img3Touch:(id)sender;
- (IBAction)img4Touch:(id)sender;
- (IBAction)img5Touch:(id)sender;
- (IBAction)img6Touch:(id)sender;
- (IBAction)img7Touch:(id)sender;
- (IBAction)img8Touch:(id)sender;
- (IBAction)img9Touch:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *SubmitScore;
- (IBAction)pushSubmitScore_0:(id)sender;
- (IBAction)pushSubitScore:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *BackButton;
- (IBAction)pushBackButton_0:(id)sender;
- (IBAction)pushBackButton:(id)sender;
- (IBAction)pushSubmitScore_1:(id)sender;
- (IBAction)pushBackButton_1:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *flag1;
@property (strong, nonatomic) IBOutlet UIImageView *flag2;
@property (strong, nonatomic) IBOutlet UIImageView *flag3;
@property (strong, nonatomic) IBOutlet UIImageView *flag4;
@property (strong, nonatomic) IBOutlet UIImageView *flag5;
@property (strong, nonatomic) IBOutlet UIImageView *flag6;
@property (strong, nonatomic) IBOutlet UIImageView *flag7;
@property (strong, nonatomic) IBOutlet UIImageView *flag8;
@property (strong, nonatomic) IBOutlet UIImageView *flag9;

@property (strong, nonatomic) IBOutlet UILabel *score1;
@property (strong, nonatomic) IBOutlet UILabel *score2;
@property (strong, nonatomic) IBOutlet UILabel *score3;
@property (strong, nonatomic) IBOutlet UILabel *score4;
@property (strong, nonatomic) IBOutlet UILabel *score5;
@property (strong, nonatomic) IBOutlet UILabel *score6;
@property (strong, nonatomic) IBOutlet UILabel *score7;
@property (strong, nonatomic) IBOutlet UILabel *score8;
@property (strong, nonatomic) IBOutlet UILabel *score9;

@property (strong, nonatomic) IBOutlet UILabel *title1;
@property (strong, nonatomic) IBOutlet UILabel *title2;
@property (strong, nonatomic) IBOutlet UILabel *title3;
@property (strong, nonatomic) IBOutlet UILabel *title4;
@property (strong, nonatomic) IBOutlet UILabel *title5;
@property (strong, nonatomic) IBOutlet UILabel *title6;
@property (strong, nonatomic) IBOutlet UILabel *title7;
@property (strong, nonatomic) IBOutlet UILabel *title8;
@property (strong, nonatomic) IBOutlet UILabel *title9;
@property(nonatomic) NSInteger fromWhichView;

@end
