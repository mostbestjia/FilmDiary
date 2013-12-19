//
//  RankingViewController.m
//  FilmDiary
//
//  Created by Yingjia Liu on 8/5/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import "RankingViewController.h"
#import "AzureUserInterface.h"
#import <QuartzCore/QuartzCore.h>
#import "DiaryViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "util.h"

static NSInteger RankingNum = 0;
static NSInteger Iphone5Shift = 0;
static float LastOffset = 0.0;

@interface RankingViewController ()
@property (strong, nonatomic)   AzureUserInterface   *getRankingService;
@end

@implementation RankingViewController
@synthesize fromWhichView;
/*
 0 - HubView
 1 - DiaryView
 */
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
    [self.CloudParallex.layer setZPosition:-5];
    self.CloudParallex.contentSize = CGSizeMake(1906, 226);
    UIImageView *Cloud = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clouds.png"]];
    Cloud.contentMode = UIViewContentModeScaleToFill;
    Cloud.frame = CGRectMake(0, 0, 1906, 226);
    [self.CloudParallex addSubview:Cloud];
    self.RankingScrollView.delegate = (id)self;
}

- (void) loadImage:(NSInteger)index
     ForImageViewN:(UIImageView *)img
     ForLabelViewN:(UILabel *)lab
{
    if (index < self.getRankingService.rankingFilmDiaries.count)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        lab.text = [self.getRankingService.rankingFilmDiaries[index] objectForKey:@"diaryTitle"];
        NSURL *url = [NSURL URLWithString:[self.getRankingService.rankingFilmDiaries[index] objectForKey:@"diaryPicUrl"]];
        SDImageCache *cache = [[SDImageCache alloc]init];
        [cache queryDiskCacheForKey:[url absoluteString] done:^(UIImage *image, SDImageCacheType cacheType) {
            if (image)
            {
                [img setImage:image];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            }
            else
            {
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                    if (data) {
                        img.alpha = 0.0;
                        [UIView animateWithDuration:0.5 animations:^{
                            [img setImage:[[UIImage alloc] initWithData:data]];  // note the retain count here.
                            img.alpha = 1.0;
                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                            [[SDImageCache sharedImageCache]storeImage:img.image forKey:[url absoluteString]];
                        }];
                    } else {
                        // handle error
                    }
                }];}
        }];
    }
}

-(void)tapDetected:(UITapGestureRecognizer *)gr {
    
    if (self.RankingFirstRunBtn.isHidden)
    {
        UIImageView *theTappedImageView = (UIImageView *)gr.view;
        NSInteger tag = theTappedImageView.tag;
        
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
        
        viewController.fromWhichView = 2;
        
        NSInteger index = [[self.getRankingService.rankingFilmDiaries[tag - 300] objectForKey:@"id"] integerValue];
        
        LastOffset = self.RankingScrollView.contentOffset.x;
        
        self.getRankingService.diaryid = index;
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else
    {
        [self.RankingFirstRunBtn setHidden:YES];
    }
}

- (void)DrawViewBasedOnData
{
    if (RankingNum > 10)
    {
        for (int i = 10; i < RankingNum; i++)
        {
            if (
                [self.getRankingService.rankingFilmDiaries[i] objectForKey:@"diaryScore"]
                !=
                [self.getRankingService.rankingFilmDiaries[9] objectForKey:@"diaryScore"]
                )
            {
                RankingNum = i;
                break;
            }
        }
    }
    
    
    self.RankingScrollView.contentSize = CGSizeMake(59 + 255 * RankingNum, 416);
    
    UIImageView *BoltFront = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"boltFront.png"]];
    
    UIImageView *BoltEnd = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"boltEnd.png"]];
    
    UIImageView *BoltBar = [[UIImageView alloc]  initWithFrame:CGRectMake(59.0/2, Iphone5Shift + 33.0 + 55.0/4 - 3.0/2, 255 * RankingNum, 3)];
    
    [BoltBar setBackgroundColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0]];
    
    BoltFront.frame = CGRectMake(0.0, Iphone5Shift + 33.0, 59.0/2, 55.0/2);
    
    BoltEnd.frame = CGRectMake(59 + 255 * RankingNum - 59.0/2, Iphone5Shift + 33.0, 59.0/2, 55.0/2);
    
    [self.RankingScrollView addSubview:BoltFront];
    [self.RankingScrollView addSubview:BoltEnd];
    [self.RankingScrollView addSubview:BoltBar];
    
    UIImageView *ClipView [RankingNum*2];
    UIImageView *RankingFrame [RankingNum];    
    UILabel *RankingLabel [RankingNum];
    UIImageView *RankingPic [RankingNum];
    UIImageView *RankingScore [RankingNum];
    UILabel *RankTitle[RankingNum];
    
    for (int i = 0; i < RankingNum; i++)
    {
        RankingFrame[i] = [[UIImageView alloc] init];
        RankingFrame[i].frame = CGRectMake(59.0/2 + 255.0 * i + 45.0/2 - 10, Iphone5Shift + 53.0, 230, 254.0);
        [RankingFrame[i].layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
        [RankingFrame[i].layer setBorderWidth:1.0];
        [RankingFrame[i] setBackgroundColor: [UIColor whiteColor]];
        [self.RankingScrollView addSubview:RankingFrame[i]];
        
        RankingPic[i] = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ranking_placeholder.png"]];
        RankingPic[i].frame = CGRectMake(59.0/2 + 255.0 * i + 45.0 / 2, Iphone5Shift + 63.0, 210.0, 210.0);
        [self.RankingScrollView addSubview:RankingPic[i]];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
        singleTap.numberOfTapsRequired = 1;
        RankingPic[i].userInteractionEnabled = YES;
        [RankingPic[i] addGestureRecognizer:singleTap];
        RankingPic[i].tag = RankingNum - i - 1 + 300;
        
        RankingLabel[i] = [[UILabel alloc] init];
        RankingLabel[i].text = [[NSString alloc]initWithFormat:@"第%d名 %d票", RankingNum - i, [[self.getRankingService.rankingFilmDiaries[RankingNum - i - 1] objectForKey:@"diaryScore"] integerValue]];
        [RankingLabel[i] setFont:[UIFont fontWithName:@"Heiti SC" size:15.0f]];
        RankingLabel[i].frame = CGRectMake(59.0/2 + 255.0 * i + 45.0/2 - 22, Iphone5Shift + 41.0, 209.0/2, 209.0/2);
        [RankingLabel[i] setTextAlignment:NSTextAlignmentCenter];
        [RankingLabel[i] setTransform:CGAffineTransformMakeRotation(-M_PI / 4)];
        [RankingLabel[i].layer setZPosition:20];
        [RankingLabel[i] setBackgroundColor:[UIColor clearColor]];
        [RankingLabel[i] setTextColor:[UIColor whiteColor]];
        [self.RankingScrollView addSubview:RankingLabel[i]];
        
        
        RankTitle[i] = [[UILabel alloc] init];
        RankTitle[i].frame = CGRectMake(59.0/2 + 255.0 * i + 45.0/2 - 10.0 + 2, Iphone5Shift + 275, 226.0, 30.0);
        //[RankTitle[i].layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
        //[RankTitle[i].layer setBorderWidth:1.0];
        [RankTitle[i] setText:[self.getRankingService.rankingFilmDiaries[RankingNum - i - 1] objectForKey:@"diaryTitle"]];

        [RankTitle[i] setTextColor:[UIColor colorWithRed:90/255.0f green:90/255.0f blue:90/255.0f alpha:1.0]];
        [RankTitle[i] setFont:[UIFont fontWithName:@"Heiti SC" size:14.0f]];
        [RankTitle[i] setTextAlignment:NSTextAlignmentCenter];
        [self.RankingScrollView addSubview:RankTitle[i]];
        
        RankingScore[i] = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner_red.png"]];
        RankingScore[i].frame = CGRectMake(59.0/2 + 255.0 * i + 45.0/2 - 10, Iphone5Shift + 53.0, 209.0/2, 209.0/2);
        [self.RankingScrollView addSubview:RankingScore[i]];
        [self loadImage:RankingNum - i - 1 ForImageViewN:RankingPic[i] ForLabelViewN:RankTitle[i]];
        
        ClipView[i*2] = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clip.png"]];
        ClipView[i*2].frame = CGRectMake(59.0/2 + 255.0 * i + 26.0, Iphone5Shift + 25.0, 37.0/2, 97.0/2);
        [self.RankingScrollView addSubview:ClipView[i*2]];
        
        ClipView[i*2 + 1] = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clip.png"]];
        ClipView[i*2 + 1].frame = CGRectMake(59.0/2 + 255.0 * (i+1) - 37.0 / 2 - 26.0, Iphone5Shift + 25.0, 37.0/2, 97.0/2);
        [self.RankingScrollView addSubview:ClipView[i*2 + 1]];
        
        NSInteger index = RankingNum - i - 1;
        //Update score for myself
        if ([[self.getRankingService.rankingFilmDiaries[index] objectForKey:@"userID"] integerValue] == self.getRankingService.userid)
        {
            int score = [[self.getRankingService.rankingFilmDiaries[index] objectForKey:@"diaryScore"] integerValue] / 2;
            if (score == 0)
            {
                score = 1;
            }
            UILabel *IWasOnRanked;
            IWasOnRanked = [[UILabel alloc]init];
            IWasOnRanked.frame = CGRectMake(59.0/2 + 255.0 * i + 45.0/2 - 10.0 + 2, Iphone5Shift + 325, 226.0, 30.0);
            [IWasOnRanked setText:[[NSString alloc]initWithFormat:@"恭喜你的胶片上榜!你获得%d经验值", score]];
            [IWasOnRanked setBackgroundColor:[UIColor clearColor]];
            [IWasOnRanked setTextColor:[UIColor colorWithRed:90/255.0f green:90/255.0f blue:90/255.0f alpha:1.0]];
            [IWasOnRanked setFont:[UIFont fontWithName:@"Heiti SC" size:12.0f]];
            [IWasOnRanked setTextAlignment:NSTextAlignmentCenter];
            [self.RankingScrollView addSubview:IWasOnRanked];
            if(![[self.getRankingService.rankingFilmDiaries[index] objectForKey:@"diaryRedeemed"]integerValue])
            {
                [self.getRankingService updateUserScore:score completion:^{
                    [self.getRankingService updateUserRedeem:self.getRankingService.rankingFilmDiaries[index] completion:^{}];
                }];
            }
        }
        
        [self.getRankingService loadDiaryScoreFromUser:self.getRankingService.userid:[[self.getRankingService.rankingFilmDiaries[index] objectForKey:@"id"] integerValue]completion:^(NSArray *results){
            if (results.count > 0)
            {
                int SubmittedScore = [[results[0] objectForKey:@"FilmDiaryScore"] integerValue];
                int score = (RankingNum - index) * SubmittedScore / 4;
                if (score == 0)
                {
                    score = 1;
                }
                UILabel *SheWasOnRanked;
                SheWasOnRanked = [[UILabel alloc]init];
                SheWasOnRanked.frame = CGRectMake(59.0/2 + 255.0 * i + 45.0/2 - 10.0 + 2, Iphone5Shift + 325, 226.0, 30.0);
                [SheWasOnRanked setText:[[NSString alloc]initWithFormat:@"你曾为此胶片投过%d票,你获得%d经验值",SubmittedScore, score]];
                [SheWasOnRanked setBackgroundColor:[UIColor clearColor]];
                [SheWasOnRanked setTextColor:[UIColor colorWithRed:90/255.0f green:90/255.0f blue:90/255.0f alpha:1.0]];
                [SheWasOnRanked setFont:[UIFont fontWithName:@"Heiti SC" size:12.0f]];
                [SheWasOnRanked setTextAlignment:NSTextAlignmentCenter];
                [self.RankingScrollView addSubview:SheWasOnRanked];
                if(![[results[0] objectForKey:@"Redeemed"] integerValue])
                {
                    [self.getRankingService updateUserScore:score completion:^{                        
                        [self.getRankingService updateFriendUserRedeem:results[0] completion:^{}];
                    }];
                }

            }
        }];
    }
    [self.RankingScrollView setContentOffset:CGPointMake(LastOffset, 0) animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IS_IPHONE5)
    {
        Iphone5Shift = 40;
    }
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    self.getRankingService = [AzureUserInterface defaultService];
    NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
    NSString *RatingKey = [[NSString alloc]initWithFormat:@"RANKING_FIRST_RUN_%@",self.getRankingService.username];
    if([stdDefaults boolForKey:RatingKey] == NO)
    {
        [stdDefaults setBool:YES forKey:RatingKey];
        [stdDefaults synchronize];
        [self.RankingFirstRunBtn.layer setZPosition:20];
    }
    else
    {
        [self.RankingFirstRunBtn setHidden:YES];
    }
    
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_rest.png"] forState:UIControlStateNormal];
    
    LastOffset = 0.0;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.getRankingService loadRankingForGlobal:^{
        RankingNum = self.getRankingService.rankingFilmDiaries.count;
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (RankingNum != 0)
        {
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"diaryScore" ascending:NO];
            
            self.getRankingService.rankingFilmDiaries = [self.getRankingService.rankingFilmDiaries sortedArrayUsingDescriptors:@[sortDescriptor]];
            [self DrawViewBasedOnData];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] cleanDisk];
//    [[SDImageCache sharedImageCache] clearDisk];
}

- (IBAction)pushBackButton_0:(id)sender {
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_pressed.png"] forState:UIControlStateNormal];
}

- (IBAction)pushBackButton:(id)sender {
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_rest.png"] forState:UIControlStateNormal];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)pushFirstRunBtn:(id)sender {    
    [self.RankingFirstRunBtn setHidden:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.RankingScrollView) {        
        [self.CloudParallex setContentOffset:CGPointMake(1410 * self.RankingScrollView.contentOffset.x/(59 + 255 * RankingNum), 0)];
    }
}
- (IBAction)pushBackButton_1:(id)sender {
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_rest.png"] forState:UIControlStateNormal];
}
@end
