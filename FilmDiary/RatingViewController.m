//
//  RatingViewController.m
//  FilmDiary
//
//  Created by Yingjia Liu on 7/23/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import "RatingViewController.h"
#import "HubViewController.h"
#import "AzureUserInterface.h"
#import <QuartzCore/QuartzCore.h>
#import "DiaryViewController.h"
#import "SubmitScoreSuccessViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "util.h"

static bool imgSelected[9];
static int imgScore[9];
static int ratingScore = 10;

@interface RatingViewController ()
@property (strong, nonatomic)   AzureUserInterface   *getDiaryService;
@end

@implementation RatingViewController
@synthesize fromWhichView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    self.getDiaryService = [AzureUserInterface defaultService];
    /*
//     Show rating first run only once
    if([stdDefaults boolForKey:RatingKey] == NO)
    {
        [stdDefaults setBool:YES forKey:RatingKey];
        [stdDefaults synchronize];
        [self.FirstRunBtn.layer setZPosition:20];
    }
    else
    {
        [self.FirstRunBtn setHidden:YES];
    }*/
    
	// Do any additional setup after loading the view.
    
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_rest.png"] forState:UIControlStateNormal];
    [self.SubmitScore.layer setCornerRadius:0.0f];
    [self.SubmitScore.layer setBorderColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0].CGColor];
    [self.SubmitScore.layer setBorderWidth:1.0f];
    
    [self.img1.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.img1.layer setBorderWidth:1.0];
    [self.img2.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.img2.layer setBorderWidth:1.0];
    [self.img3.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.img3.layer setBorderWidth:1.0];
    [self.img4.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.img4.layer setBorderWidth:1.0];
    [self.img5.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.img5.layer setBorderWidth:1.0];
    [self.img6.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.img6.layer setBorderWidth:1.0];
    [self.img7.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.img7.layer setBorderWidth:1.0];
    [self.img8.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.img8.layer setBorderWidth:1.0];
    [self.img9.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.img9.layer setBorderWidth:1.0];
    
    [self.img1 setBackgroundImage:[UIImage imageNamed:@"rating_placeholder.png"] forState:UIControlStateNormal];
    [self.img2 setBackgroundImage:[UIImage imageNamed:@"rating_placeholder.png"] forState:UIControlStateNormal];
    [self.img3 setBackgroundImage:[UIImage imageNamed:@"rating_placeholder.png"] forState:UIControlStateNormal];
    [self.img4 setBackgroundImage:[UIImage imageNamed:@"rating_placeholder.png"] forState:UIControlStateNormal];
    [self.img5 setBackgroundImage:[UIImage imageNamed:@"rating_placeholder.png"] forState:UIControlStateNormal];
    [self.img6 setBackgroundImage:[UIImage imageNamed:@"rating_placeholder.png"] forState:UIControlStateNormal];
    [self.img7 setBackgroundImage:[UIImage imageNamed:@"rating_placeholder.png"] forState:UIControlStateNormal];
    [self.img8 setBackgroundImage:[UIImage imageNamed:@"rating_placeholder.png"] forState:UIControlStateNormal];
    [self.img9 setBackgroundImage:[UIImage imageNamed:@"rating_placeholder.png"] forState:UIControlStateNormal];
    
    if (fromWhichView == 0)//From Hub
    {
        NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
        NSString *RatingKey = [[NSString alloc]initWithFormat:@"RATING_FIRST_RUN_%@",self.getDiaryService.username];
        [stdDefaults setBool:YES forKey:RatingKey];
        [stdDefaults synchronize];
        [self.FirstRunBtn setHidden:NO];
        [self.FirstRunBtn.layer setZPosition:20];
        [self ResetImageProperties];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [self.getDiaryService loadRandom9PicsForRate:self.getDiaryService.userid completion:^{
            
            //Older pics gets rated first
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"diarySecondsInterval" ascending:YES];
            
            self.getDiaryService.ratingFilmDiaries = [self.getDiaryService.ratingFilmDiaries sortedArrayUsingDescriptors:@[sortDescriptor]];
            
            [self Load9Images];
            
        }];
    }
    else//From Diary backbutton
    {
        [self.FirstRunBtn setHidden:YES];
        for (int i = 0; i < 9; i++)
        {
            UIImageView *flag = (UIImageView *)[self.view viewWithTag:i + 11];
            UILabel *score = (UILabel *)[self.view viewWithTag:i + 21];
            if (imgScore[i] || imgSelected[i])
            {
                [flag setHidden:NO];
                [score setHidden:NO];
                [score setText:[NSString stringWithFormat:@"%d", imgScore[i]]];
            }
            else
            {
                [flag setHidden:YES];
                [score setHidden:YES];
            }
            
            if (imgSelected[i])
            {
                UIImageView *pic = (UIImageView *)[self.view viewWithTag:i + 1];
                [pic setCenter: CGPointMake(pic.center.x, pic.center.y-7)];
                [score setCenter: CGPointMake(score.center.x, score.center.y-7)];
                [flag setCenter: CGPointMake(flag.center.x, flag.center.y-7)];
                
                // SET rating plus/minus honor
                if (imgScore[i] == 0)
                {
                    self.RatingMinus.enabled = NO;
                    [self.RatingMinus setBackgroundImage:[UIImage imageNamed:@"-_void.png"] forState:UIControlStateNormal];
                }
                else
                {
                    self.RatingMinus.enabled = YES;
                    [self.RatingMinus setBackgroundImage:[UIImage imageNamed:@"-_big.png"] forState:UIControlStateNormal];
                }
                
                if (ratingScore == 0)
                {
                    self.RatingPlus.enabled = NO;
                    [self.RatingPlus setBackgroundImage:[UIImage imageNamed:@"+_void.png"] forState:UIControlStateNormal];
                    [self.rating_bar setImage:[UIImage imageNamed:@"rating_bar_zero"]];
                }
                else
                {
                    self.RatingPlus.enabled = YES;
                    [self.RatingPlus setBackgroundImage:[UIImage imageNamed:@"+_big.png"] forState:UIControlStateNormal];
                }
            }
        }
        [self Load9Images];
    }
    
    [self.ScoreLabel setText:[NSString stringWithFormat:@"%d", ratingScore]];
}

- (void)Load9Images
{
    [self loadImage:0 ForImageViewN:self.img1 ForLabelViewN:self.title1];
    [self loadImage:1 ForImageViewN:self.img2 ForLabelViewN:self.title2];
    [self loadImage:2 ForImageViewN:self.img3 ForLabelViewN:self.title3];
    [self loadImage:3 ForImageViewN:self.img4 ForLabelViewN:self.title4];
    [self loadImage:4 ForImageViewN:self.img5 ForLabelViewN:self.title5];
    [self loadImage:5 ForImageViewN:self.img6 ForLabelViewN:self.title6];
    [self loadImage:6 ForImageViewN:self.img7 ForLabelViewN:self.title7];
    [self loadImage:7 ForImageViewN:self.img8 ForLabelViewN:self.title8];
    [self loadImage:8 ForImageViewN:self.img9 ForLabelViewN:self.title9];
}

- (void)ResetImageProperties
{
    ratingScore = 10;
    self.RatingMinus.enabled = NO;
    self.RatingPlus.enabled = NO;
    [self.RatingMinus setBackgroundImage:[UIImage imageNamed:@"-_void.png"] forState:UIControlStateNormal];
    [self.RatingPlus setBackgroundImage:[UIImage imageNamed:@"+_void.png"] forState:UIControlStateNormal];
    for (int i = 0; i< 9; i++)
    {
        imgScore[i] = 0;
        imgSelected[i] = NO;
        UIImageView *flag = (UIImageView *)[self.view viewWithTag:i + 11];
        UILabel *score = (UILabel *)[self.view viewWithTag:i + 21];
        [flag setHidden:YES];
        [score setHidden:YES];
    }
}

- (void) loadImage:(NSInteger)index
     ForImageViewN:(UIButton *)img
     ForLabelViewN:(UILabel *)lab
{
    if (index < self.getDiaryService.ratingFilmDiaries.count)
    {
        lab.text = [self.getDiaryService.ratingFilmDiaries[index] objectForKey:@"diaryTitle"];
        NSURL *url = [NSURL URLWithString:[self.getDiaryService.ratingFilmDiaries[index] objectForKey:@"diaryPicUrl"]];
        
        SDImageCache *cache = [[SDImageCache alloc]init];
        [cache queryDiskCacheForKey:[url absoluteString] done:^(UIImage *image, SDImageCacheType cacheType) {
            if (image)
            {
                [img setBackgroundImage:image forState:UIControlStateNormal];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            }
            else
            {
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                    if (data) {
                        img.alpha = 0.0;
                        [UIView animateWithDuration:0.5 animations:^{
                            [img setBackgroundImage:[[UIImage alloc] initWithData:data] forState:UIControlStateNormal];  // note the retain count here.
                            img.alpha = 1.0;
                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                            [[SDImageCache sharedImageCache]storeImage:img.currentBackgroundImage forKey:[url absoluteString]];
                        }];
                    } else {
                        // handle error
                    }
                }];}
        }];
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] cleanDisk];
//    [[SDImageCache sharedImageCache] clearDisk];

}

- (IBAction)pushRatingPlus_0:(id)sender {
    [self.RatingPlus setBackgroundImage:[UIImage imageNamed:@"+_pressed.png"] forState:UIControlStateNormal];
}

- (IBAction)pushRatingPlus:(id)sender {
    [self.RatingPlus setBackgroundImage:[UIImage imageNamed:@"+_big.png"] forState:UIControlStateNormal];
    ratingScore--;
    if (ratingScore == 0)
    {
        [self.rating_bar setImage:[UIImage imageNamed:@"rating_bar_zero"]];
    }
    [self.ScoreLabel setText:[NSString stringWithFormat:@"%d", ratingScore]];
    if (ratingScore == 0)
    {
        self.RatingPlus.enabled = NO;
        [self.RatingPlus setBackgroundImage:[UIImage imageNamed:@"+_void.png"] forState:UIControlStateNormal];
    }
    if (!self.RatingMinus.enabled)
    {
        self.RatingMinus.enabled = YES;
        [self.RatingMinus setBackgroundImage:[UIImage imageNamed:@"-_big.png"] forState:UIControlStateNormal];
    }
    for (int i = 0; i < 9; i++)
    {
        if (imgSelected[i])
        {
            if (imgScore[i] == 10)
            {
                self.RatingPlus.enabled = NO;
                [self.RatingPlus setBackgroundImage:[UIImage imageNamed:@"+_void.png"] forState:UIControlStateNormal];
            }
            else{
                imgScore[i] ++;
                UILabel *score = (UILabel *)[self.view viewWithTag:i + 21];
                [score setText:[NSString stringWithFormat:@"%d", imgScore[i]]];
                break;
            }
        }
    }
}

- (IBAction)pushRatingMinus_0:(id)sender {
    [self.RatingMinus setBackgroundImage:[UIImage imageNamed:@"-_pressed.png"] forState:UIControlStateNormal];
}

- (IBAction)pushRatingMinus:(id)sender {
    [self.RatingMinus setBackgroundImage:[UIImage imageNamed:@"-_big.png"] forState:UIControlStateNormal];
    ratingScore++;
    if (ratingScore == 1)
    {
        [self.rating_bar setImage:[UIImage imageNamed:@"rating_bar"]];
    }
    [self.ScoreLabel setText:[NSString stringWithFormat:@"%d", ratingScore]];
    if (ratingScore == 10)
    {
        self.RatingMinus.enabled = NO;
        [self.RatingMinus setBackgroundImage:[UIImage imageNamed:@"-_void.png"] forState:UIControlStateNormal];
        [self.SubmitScore setEnabled:NO];
    }
    else
    {
        [self.SubmitScore setEnabled:YES];
    }
    if (!self.RatingPlus.enabled)
    {
        self.RatingPlus.enabled = YES;
        [self.RatingPlus setBackgroundImage:[UIImage imageNamed:@"+_big.png"] forState:UIControlStateNormal];
    }
    for (int i = 0; i < 9; i++)
    {
        if (imgSelected[i])
        {
            if (imgScore[i] == 0)
            {
                self.RatingMinus.enabled = NO;
                [self.RatingMinus setBackgroundImage:[UIImage imageNamed:@"-_void.png"] forState:UIControlStateNormal];
            }
            else
            {
                imgScore[i] --;
                UILabel *score = (UILabel *)[self.view viewWithTag:i + 21];
                [score setText:[NSString stringWithFormat:@"%d", imgScore[i]]];
                break;
            }
        }
    }
}

- (void)selectPicN:(NSInteger)index{
    UIImageView *pic = (UIImageView *)[self.view viewWithTag:index + 0];
    UIImageView *flag = (UIImageView *)[self.view viewWithTag:index + 10];
    UILabel *score = (UILabel *)[self.view viewWithTag:index + 20];
    
    imgSelected[index - 1] = YES;
    [score setHidden:NO];
    [flag setHidden:NO];
    [pic setCenter: CGPointMake(pic.center.x
                                , pic.center.y-7)];
    
    [score setCenter: CGPointMake(score.center.x
                                  , score.center.y-7)];
    
    [flag setCenter: CGPointMake(flag.center.x
                                 , flag.center.y-7)];
    for (int i = 1; i <= 9; i++)
    {
        if (i != index && imgSelected[i-1])
        {
            [self UnselectPicN:i];
        }
    }
    
    if (imgScore[index-1] == 10 || ratingScore == 0)
    {
        self.RatingPlus.enabled = NO;
        [self.RatingPlus setBackgroundImage:[UIImage imageNamed:@"+_void.png"] forState:UIControlStateNormal];
    }
    else
    {
        self.RatingPlus.enabled = YES;
        [self.RatingPlus setBackgroundImage:[UIImage imageNamed:@"+_big.png"] forState:UIControlStateNormal];
    }
    if (imgScore[index-1] == 0 || ratingScore == 10)
    {
        self.RatingMinus.enabled = NO;
        [self.RatingMinus setBackgroundImage:[UIImage imageNamed:@"-_void.png"] forState:UIControlStateNormal];
    }
    else
    {
        self.RatingMinus.enabled = YES;
        [self.RatingMinus setBackgroundImage:[UIImage imageNamed:@"-_big.png"] forState:UIControlStateNormal];
    }
    [score setText:[NSString stringWithFormat:@"%d", imgScore[index-1]]];
}

- (void)UnselectPicN:(NSInteger)index{
    UIImageView *pic = (UIImageView *)[self.view viewWithTag:index + 0];
    UIImageView *flag = (UIImageView *)[self.view viewWithTag:index + 10];
    UILabel *score = (UILabel *)[self.view viewWithTag:index + 20];
    
    imgSelected[index - 1] = NO;
    [pic setCenter: CGPointMake(pic.center.x
                                , pic.center.y+7)];
    
    [score setCenter: CGPointMake(score.center.x
                                  , score.center.y+7)];
    
    [flag setCenter: CGPointMake(flag.center.x
                                 , flag.center.y+7)];
    if (imgScore[index-1] == 0)
    {
        [score setHidden:YES];
        [flag setHidden:YES];
    }
}

- (void)LaunchDiaryN:(NSInteger)index {
    self.getDiaryService.diaryid = [[self.getDiaryService.ratingFilmDiaries[index - 1] objectForKey:@"id"] integerValue];
    UIStoryboard *storyboard;
    if (IS_IPHONE5)
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone5" bundle:nil];
    }
    else
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    }
    DiaryViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"DiaryViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)img1Touch:(id)sender {
    if (!imgSelected[0])
    {
        [self selectPicN:1];
    }
    else if (self.getDiaryService.ratingFilmDiaries.count < 1)
    {
        [self UnselectPicN:1];
    }
    else
    {
        [self LaunchDiaryN:1];
    }
}

- (IBAction)img2Touch:(id)sender {
    if (!imgSelected[1])
    {
        [self selectPicN:2];
    }
    else if (self.getDiaryService.ratingFilmDiaries.count < 2)
    {
        [self UnselectPicN:2];
    }
    else
    {
        [self LaunchDiaryN:2];
    }
}

- (IBAction)img3Touch:(id)sender {
    if (!imgSelected[2])
    {
        [self selectPicN:3];
    }
    else if (self.getDiaryService.ratingFilmDiaries.count < 3)
    {
        [self UnselectPicN:3];
    }
    else
    {
        [self LaunchDiaryN:3];
    }
}

- (IBAction)img4Touch:(id)sender {
    if (!imgSelected[3])
    {
        [self selectPicN:4];
    }
    else if (self.getDiaryService.ratingFilmDiaries.count < 4)
    {
        [self UnselectPicN:4];
    }
    else
    {
        [self LaunchDiaryN:4];
    }
}

- (IBAction)img5Touch:(id)sender {
    if (!imgSelected[4])
    {
        [self selectPicN:5];
    }
    else if (self.getDiaryService.ratingFilmDiaries.count < 5)
    {
        [self UnselectPicN:5];
    }
    else
    {
        [self LaunchDiaryN:5];
    }
}

- (IBAction)img6Touch:(id)sender {
    if (!imgSelected[5])
    {
        [self selectPicN:6];
    }
    else if (self.getDiaryService.ratingFilmDiaries.count < 6)
    {
        [self UnselectPicN:6];
    }
    else
    {
        [self LaunchDiaryN:6];
    }
}

- (IBAction)img7Touch:(id)sender {
    if (!imgSelected[6])
    {
        [self selectPicN:7];
    }
    else if (self.getDiaryService.ratingFilmDiaries.count < 7)
    {
        [self UnselectPicN:7];
    }
    else
    {
        [self LaunchDiaryN:7];
    }
}

- (IBAction)img8Touch:(id)sender {
    if (!imgSelected[7])
    {
        [self selectPicN:8];
    }
    else if (self.getDiaryService.ratingFilmDiaries.count < 8)
    {
        [self UnselectPicN:8];
    }
    else
    {
        [self LaunchDiaryN:8];
    }
}

- (IBAction)img9Touch:(id)sender {
    if (!imgSelected[8])
    {
        [self selectPicN:9];
    }
    else if (self.getDiaryService.ratingFilmDiaries.count < 9)
    {
        [self UnselectPicN:9];
    }
    else
    {
        [self LaunchDiaryN:9];
    }
}

- (void)SubmitScoreHelper
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    for (int i = 0; i < MIN(self.getDiaryService.ratingFilmDiaries.count, 9); i++)
    {
        int index = i;
        [self.getDiaryService refreshFilmDiaryForID:[[self.getDiaryService.ratingFilmDiaries[index] objectForKey:@"id"] integerValue]  completion:^{
            [self.getDiaryService submitFilmDiaryScore:imgScore[index] completion:^{
                NSLog(@"SCORE=%D",imgScore[index]);
                if (imgScore[index] != 0)
                {
                    NSDictionary *item = @{@"userID": [NSNumber numberWithInteger: self.getDiaryService.userid],
                                           @"filmID":[NSNumber numberWithInteger: [[self.getDiaryService.ratingFilmDiaries[index] objectForKey:@"id"] integerValue]],
                                           @"FilmDiaryScore": [NSNumber numberWithInteger:imgScore[index]],
                                           @"Redeemed": @NO,
                                           };
                    [self.getDiaryService submitFilmDiaryUserScore:item completion:^{
                        
                        NSDate *currentDate = [NSDate date];
                        NSCalendar* calendar = [NSCalendar currentCalendar];
                        NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate]; // Get necessary date components
                        int year = [components year];
                        int month = [components month];
                        int day = [components day];
                        long date = year * 10000 + month * 100 + day;
                        NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
                        NSString *RatingKey = [[NSString alloc]initWithFormat:@"LAST_RATE_%@",self.getDiaryService.username];
                        [stdDefaults setInteger:date forKey:RatingKey];
                        [self ResetImageProperties];
                    }];
                }
            }];
        }];
    }
    
    [self.getDiaryService updateUserScore:1 completion:^{}];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    UIStoryboard *storyboard;
    if (IS_IPHONE5)
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone5" bundle:nil];
    }
    else
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    }
    SubmitScoreSuccessViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"SubmitScoreSuccessViewController"];
    [self presentViewController:viewController animated:YES completion:^{
        [self.navigationController popViewControllerAnimated:NO];
    }];
}

- (IBAction)pushSubmitScore_0:(id)sender {
    [self.SubmitScore.layer setBackgroundColor:[UIColor colorWithRed:229/255.0f green:118/255.0f blue:35/255.0f alpha:1.0].CGColor];
}

- (IBAction)pushSubitScore:(id)sender {
    [self.SubmitScore.layer setBackgroundColor:[UIColor colorWithRed:251/255.0f green:176/255.0f blue:59/255.0f alpha:1.0].CGColor];
    if (ratingScore == 0)
    {
        [self SubmitScoreHelper];
    }
    else if (ratingScore == 10)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"对不起，你还没有给任何一张胶片投票"
                                                       delegate:self
                                              cancelButtonTitle:@"返回"
                                              otherButtonTitles:nil,nil];
        alert.tag = 1;
        [alert show];
    }
    else if (ratingScore != 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"你还有选票没有给出哦"
                                                       delegate:self
                                              cancelButtonTitle:@"继续投票"
                                              otherButtonTitles:@"确定提交",nil];
        alert.tag = 2;
        [alert show];
    }
}

- (IBAction)pushBackButton_0:(id)sender {
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_pressed.png"] forState:UIControlStateNormal];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if(buttonIndex == 0 && alertView.tag == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (alertView.tag == 1)
    {
        // Submit empty score
    }
    else if(buttonIndex == 1 && alertView.tag == 2)
    {
        [self SubmitScoreHelper];
    }
}

- (IBAction)pushBackButton:(id)sender {
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_rest.png"] forState:UIControlStateNormal];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"点击确定，当前投票记录将会丢失"
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:@"取消",nil];
    alert.tag = 0;
    [alert show];
}

- (IBAction)pushSubmitScore_1:(id)sender {
    [self.SubmitScore.layer setCornerRadius:0.0f];
    [self.SubmitScore.layer setBorderColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0].CGColor];
    [self.SubmitScore.layer setBorderWidth:1.0f];
}

- (IBAction)pushBackButton_1:(id)sender {
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_rest.png"] forState:UIControlStateNormal];
}

- (IBAction)PushFirstRunBtn:(id)sender {
    [self.FirstRunBtn setHidden:YES];
}
@end