//
//  DiaryViewController.m
//  FilmDiary
//
//  Created by Yingjia Liu on 8/8/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import "DiaryViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AzureUserInterface.h"
#import "HistoryDiaryViewController.h"
#import "FavViewController.h"
#import "RankingViewController.h"
#import "RatingViewController.h"
#import "CommentViewController.h"
#import "UserProfileDisplayViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "util.h"

bool imageSaved;

@interface DiaryViewController ()
@property (strong, nonatomic)   AzureUserInterface   *favDiaryService;
@end

@implementation DiaryViewController
@synthesize ComposePicBackGround;
@synthesize fromWhichView;
/*
 0 - history
 1 - fav
 2 - ranking
 3 - rating
 */

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] cleanDisk];
//    [[SDImageCache sharedImageCache] clearDisk];
}

- (void)viewDidLayoutSubviews
{
    // Need to set the scroll view content size here
    //    [self.ComposeScroll.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    //    [self.ComposeScroll.layer setBorderWidth:2.0f];
    self.ComposeScroll.contentSize = CGSizeMake(310, 594);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    [self.DiaryBanner setHidden:YES];
    [self.DiaryBannerText setHidden:YES];
    [self.LaunchAuthorBtn.layer setCornerRadius:0.0f];
    [self.LaunchAuthorBtn.layer setBorderColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0].CGColor];
    [self.LaunchAuthorBtn.layer setBorderWidth:1.0f];
    imageSaved = NO;
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_rest.png"] forState:UIControlStateNormal];
    [self.SaveDiaryButton setBackgroundImage:[UIImage imageNamed:@"save_button_unsaved.png"] forState:UIControlStateNormal];
    imageSaved = false;
    self.favDiaryService = [AzureUserInterface defaultService];
    [self.LaunchAuthorBtn setHidden:YES];
    switch (fromWhichView) {
        case 0://History
            [self.DiaryTopTitle setText:@"以往的胶片"];
            break;
        case 1://Fav
            [self.DiaryTopTitle setText:@"我的收藏"];
            break;
        case 2://Ranking
            [self.DiaryTopTitle setText:@"晒图榜"];
            break;
        case 3://Rating
            [self.DiaryTopTitle setText:@"我来投票"];
            break;
        default:
            break;
    }
    
    // TODO: grab ID from constructor
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.favDiaryService refreshFilmDiaryForID:self.favDiaryService.diaryid completion:^{
        NSInteger userID = [[self.favDiaryService.filmDiary objectForKey:@"userID"] integerValue];
        
        if (userID == self.favDiaryService.userid)
        {
            [self.LaunchAuthorBtn setTitle:@"我的名片" forState:UIControlStateNormal];
        }
        else
        {
            [self.LaunchAuthorBtn setTitle:@"查看名片" forState:UIControlStateNormal];
        }
        [self.LaunchAuthorBtn setHidden:NO];
        [self.DiaryTitle setText:[self.favDiaryService.filmDiary objectForKey:@"diaryTitle"]];
        [self.DiaryContent setText:[self.favDiaryService.filmDiary objectForKey:@"diaryContent"]];
        [self.DiaryDate setText:[self.favDiaryService.filmDiary objectForKey:@"diaryDate"]];

        if (9 == [[self.favDiaryService.filmDiary objectForKey:@"diaryViewCount"] integerValue])
        {
            [self.DiaryBanner setHidden:NO];
            if ([[self.favDiaryService.filmDiary objectForKey:@"diaryRedeemed"] integerValue])
            {
                [self.DiaryBannerText setText:[[NSString alloc]initWithFormat:@"上榜得票%d",[[self.favDiaryService.filmDiary objectForKey:@"diaryScore"] integerValue]]];
            }
            else
            {
                [self.DiaryBannerText setText:[[NSString alloc]initWithFormat:@"最终得票%d",[[self.favDiaryService.filmDiary objectForKey:@"diaryScore"] integerValue]]];
            }
            
            [self.DiaryBannerText setFont:[UIFont fontWithName:@"Heiti SC" size:15.0f]];
            [self.DiaryBannerText setTransform:CGAffineTransformMakeRotation(-M_PI / 4)];
            [self.DiaryBannerText setHidden:NO];
        }
        
        NSString *username = [[NSString alloc] initWithFormat:@"%@", [self.favDiaryService.filmDiary objectForKey:@"username"]];
        
        if (username)
        {
            [self.AuthorName setText:username];
        }
        
        
        NSURL *url = [NSURL URLWithString:[self.favDiaryService.filmDiary objectForKey:@"diaryPicUrl"]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        SDImageCache *cache = [[SDImageCache alloc]init];
        [cache queryDiskCacheForKey:[url absoluteString] done:^(UIImage *image, SDImageCacheType cacheType) {
            if (image)
            {
                [self.ComposePicBackGround setImage:image];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            }
            else
            {
                [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                    if (data) {
                        self.ComposePicBackGround.alpha = 0.0;
                        [UIView animateWithDuration:0.5 animations:^{
                            self.ComposePicBackGround.image = [[UIImage alloc] initWithData:data];  // note the retain count here.
                            self.ComposePicBackGround.alpha = 1.0;
                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                            [[SDImageCache sharedImageCache]storeImage:self.ComposePicBackGround.image forKey:[url absoluteString]];
                        }];
                    } else {
                        // handle error
                    }
                }];
            }
        }];
        
        [self.favDiaryService loadfavStatus:[[self.favDiaryService.filmDiary objectForKey:@"id"]integerValue] userID:[[self.favDiaryService.loginUser[0] objectForKey:@"id"]integerValue] completion:^{
            if (self.favDiaryService.favDiary)
            {
                [self.SaveDiaryButton setBackgroundImage:[UIImage imageNamed:@"save_button_saved.png"] forState:UIControlStateNormal];
                imageSaved = YES;
            }
        }];
        
    }];
}

- (IBAction)pushBackButton_0:(id)sender {
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_pressed.png"] forState:UIControlStateNormal];

}

- (IBAction)pushBackButton:(id)sender {
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_rest.png"] forState:UIControlStateNormal];
        [self.navigationController popViewControllerAnimated:YES];
}

// ranking 320x32, 12.5
- (IBAction)pushSaveDiaryButton:(id)sender {
    
        if (!imageSaved)
    {
        [self.SaveDiaryButton setBackgroundImage:[UIImage imageNamed:@"save_button_saved.png"] forState:UIControlStateNormal];
        imageSaved = YES;
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"已将该胶片加入“经典收藏”"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil,nil];
        [alert show];
        NSDictionary *item = @{ @"userID": [NSNumber numberWithInteger: self.favDiaryService.userid],
                                @"diaryID": [NSNumber numberWithInteger:self.favDiaryService.diaryid]};
        [self.view setUserInteractionEnabled:NO];
        [self.favDiaryService favDiary:item completion:^{
            [self.view setUserInteractionEnabled:YES];
        }];
    }
    else
    {
        [self.SaveDiaryButton setBackgroundImage:[UIImage imageNamed:@"save_button_unsaved.png"] forState:UIControlStateNormal];
        imageSaved = NO;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"已将该胶片从“经典收藏”删除"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil,nil];
        [alert show];
        NSDictionary *item = @{
                               @"id": [self.favDiaryService.favDiary objectForKey:@"id"],
                               @"userID": [NSNumber numberWithInteger: self.favDiaryService.userid],
                                @"diaryID": [NSNumber numberWithInteger:self.favDiaryService.diaryid]};
        [self.view setUserInteractionEnabled:NO];
        [self.favDiaryService unFavDiary:item completion:^{
            [self.view setUserInteractionEnabled:YES];
        }];
    }
}

- (IBAction)pushSeeComment:(id)sender {
    UIStoryboard *storyboard;
    if (IS_IPHONE5)
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone5" bundle:nil];
    }
    else
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    }
    CommentViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"CommentViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)LaunchAuthor:(id)sender {
    [self.LaunchAuthorBtn.layer setBackgroundColor:[UIColor colorWithRed:251/255.0f green:176/255.0f blue:59/255.0f alpha:1.0].CGColor];
    
    UIStoryboard *storyboard;
    if (IS_IPHONE5)
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone5" bundle:nil];
    }
    else
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    }
    UserProfileDisplayViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"UserProfileDisplayViewController"];
    viewController.fromWhichUser = [[self.favDiaryService.filmDiary objectForKey:@"userID"] integerValue];
    
    [self.navigationController pushViewController:viewController animated:YES];
}
- (IBAction)LaunchAuthor_0:(id)sender {
    [self.LaunchAuthorBtn.layer setBackgroundColor:[UIColor colorWithRed:229/255.0f green:118/255.0f blue:35/255.0f alpha:1.0].CGColor];
}

- (IBAction)pushSeeAuthor_1:(id)sender {
    [self.LaunchAuthorBtn.layer setBackgroundColor:[UIColor colorWithRed:251/255.0f green:176/255.0f blue:59/255.0f alpha:1.0].CGColor];
}

- (IBAction)pushBackButton_1:(id)sender {
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_rest.png"] forState:UIControlStateNormal];
}

- (IBAction)pushReportSpam:(id)sender {
    NSDictionary *item = @{
                           @"diaryID": [NSNumber numberWithInteger: [[self.favDiaryService.filmDiary objectForKey:@"id"] integerValue]],
                           @"userID": [NSNumber numberWithInteger: [[self.favDiaryService.filmDiary objectForKey:@"userID"] integerValue]],
                           };
    [self.favDiaryService reportSpam:item completion:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"感谢您的举报，我们会尽快处理"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil,nil];
        [alert show];
    }];
}
@end
