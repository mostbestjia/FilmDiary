//
//  HubViewController.m
//  FilmDiary
//
//  Created by Yingjia Liu on 7/14/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import "HubViewController.h"
#import "RatingViewController.h"
#import "ComposeFilmViewController.h"
#import "AzureUserInterface.h"
#import "util.h"
#import "UserProfileDisplayViewController.h"
#import "HistoryDiaryViewController.h"
#import "FavViewController.h"
#import "HelpViewController.h"
#import "AboutUsViewController.h"
#import "RankingViewController.h"

@interface HubViewController ()
@property (strong, nonatomic)   AzureUserInterface   *getRankingService;
@end


@implementation HubViewController
static NSTimer *timer;
static BOOL animated;

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if (timer == nil)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(transitionPhotos) userInfo:nil repeats:YES];
    }
    self.TeamLogo.alpha = 0.5;
    animated = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        self.edgesForExtendedLayout=NO;
    }

    self.getRankingService = [AzureUserInterface defaultService];
    [self.ShaiTuBang setBackgroundImage:[UIImage imageNamed:@"shai_big.png"] forState:UIControlStateNormal];
    [self.JingDianShouCang setBackgroundImage:[UIImage imageNamed:@"feature_big.png"] forState:UIControlStateNormal];
    [self.WoLaiDianPing setBackgroundImage:[UIImage imageNamed:@"env_big.png"] forState:UIControlStateNormal];
    [self.ChuangZuoJinTian setBackgroundImage:[UIImage imageNamed:@"imp_big.png"] forState:UIControlStateNormal];
    [self.ChaKanYiWang setBackgroundImage:[UIImage imageNamed:@"his_big.png"] forState:UIControlStateNormal];
    
    UINavigationController *navController = [[UINavigationController alloc]init];
    self.view.window.rootViewController = navController;
}

-(void)transitionPhotos{
//    NSLog(@"%d-->%f", animated, self.TeamLogo.alpha);
    if (self.TeamLogo.alpha < 1 && animated == NO)
    {
        self.TeamLogo.alpha += 0.02;
    }
    if (self.TeamLogo.alpha >= 1)
    {
        animated = YES;
    }
    if (animated && self.TeamLogo.alpha > 0.5)
    {
        self.TeamLogo.alpha -= 0.02;
    }
    if (animated && self.TeamLogo.alpha <= 0.5)
    {
        [timer invalidate];
        timer = nil;
        animated = NO;
    }
}

- (IBAction)pushShaiTuBang_0:(id)sender {
    [self.ShaiTuBang setBackgroundImage:[UIImage imageNamed:@"shai_small.png"] forState:UIControlStateNormal];
}

- (IBAction)pushShaiTuBang:(id)sender {
    [self.ShaiTuBang setBackgroundImage:[UIImage imageNamed:@"shai_big.png"] forState:UIControlStateNormal];
    UIStoryboard *storyboard;
    if (IS_IPHONE5)
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone5" bundle:nil];
    }
    else
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    }
    RankingViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"RankingViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)pushWoLaiDianPing_0:(id)sender {
    [self.WoLaiDianPing setBackgroundImage:[UIImage imageNamed:@"env_small.png"] forState:UIControlStateNormal];
}

- (IBAction)pushWoLaiDianPing:(id)sender {
    [self.WoLaiDianPing setBackgroundImage:[UIImage imageNamed:@"env_big.png"] forState:UIControlStateNormal];
    
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate]; // Get necessary date components
    int year = [components year];
    int month = [components month];
    int day = [components day];
    long date = year * 10000 + month * 100 + day;
    
    NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
    NSString *RatingKey = [[NSString alloc]initWithFormat:@"LAST_RATE_%@",self.getRankingService.username];
    
    if([stdDefaults integerForKey:RatingKey] == date)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"你今天已经评过分啦，请明日再参与！"
                                                       delegate:self
                                              cancelButtonTitle:@"返回"
                                              otherButtonTitles:nil,nil];
        alert.tag = 0;
        [alert show];
    }
    else
    {
        UIStoryboard *storyboard;
        if (IS_IPHONE5)
        {
            storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone5" bundle:nil];
        }
        else
        {
            storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        }
        RatingViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"RatingViewController"];
        viewController.fromWhichView = 0;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (IBAction)pushJingDianShouCang_0:(id)sender {
    [self.JingDianShouCang setBackgroundImage:[UIImage imageNamed:@"feature_small.png"] forState:UIControlStateNormal];
}

- (IBAction)pushJingDianShouCang:(id)sender {
    [self.JingDianShouCang setBackgroundImage:[UIImage imageNamed:@"feature_big.png"] forState:UIControlStateNormal];
    UIStoryboard *storyboard;
    if (IS_IPHONE5)
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone5" bundle:nil];
    }
    else
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    }
    FavViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"FavViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}
- (IBAction)pushChuangZuoJinTian_0:(id)sender {
    [self.ChuangZuoJinTian setBackgroundImage:[UIImage imageNamed:@"imp_small.png"] forState:UIControlStateNormal];
}

- (IBAction)pushChuangZuoJinTian:(id)sender {
    [self.ChuangZuoJinTian setBackgroundImage:[UIImage imageNamed:@"imp_big.png"] forState:UIControlStateNormal];
    
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate]; // Get necessary date components
    int year = [components year];
    int month = [components month];
    int day = [components day];
    long date = year * 10000 + month * 100 + day;
    
    NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *RatingKey = [[NSString alloc]initWithFormat:@"LAST_COMPOSE_%@",self.getRankingService.username];
    if([stdDefaults integerForKey:RatingKey] == date)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"你今天已经创作过胶片，请明日再参与吧！"
                                                       delegate:self
                                              cancelButtonTitle:@"返回"
                                              otherButtonTitles:nil,nil];
        alert.tag = 0;
        [alert show];
    }
    else
    {
        UIStoryboard *storyboard;
        if (IS_IPHONE5)
        {
            storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone5" bundle:nil];
        }
        else
        {
            storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        }
        ComposeFilmViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ComposeFilmViewController"];
        viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (IBAction)pushChaKanYiWang_0:(id)sender {
    [self.ChaKanYiWang setBackgroundImage:[UIImage imageNamed:@"his_small.png"] forState:UIControlStateNormal];
}

- (IBAction)pushChaKanYiWang:(id)sender {
    [self.ChaKanYiWang setBackgroundImage:[UIImage imageNamed:@"his_big.png"] forState:UIControlStateNormal];
    UIStoryboard *storyboard;
    if (IS_IPHONE5)
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone5" bundle:nil];
    }
    else
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    }
    HistoryDiaryViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"HistoryDiaryViewController"];
    viewController.fromWhichUser = self.getRankingService.userid;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)pushWodeMingPian:(id)sender {
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
    viewController.fromWhichUser = self.getRankingService.userid;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)pushHelp:(id)sender {
    UIStoryboard *storyboard;
    if (IS_IPHONE5)
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone5" bundle:nil];
    }
    else
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    }
    HelpViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"HelpViewController"];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)pushAboutUs:(id)sender {
    UIStoryboard *storyboard;
    if (IS_IPHONE5)
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone5" bundle:nil];
    }
    else
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    }
    AboutUsViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"AboutUsViewController"];
    
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
