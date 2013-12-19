//
//  UserProfileDisplayViewController.m
//  FilmDiary
//
//  Created by Yingjia Liu on 8/9/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import "UserProfileDisplayViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AzureUserInterface.h"
#import "HistoryDiaryViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "util.h"
#import "SignUpUser.h"
#import "DataViewController.h"
#import "UserProfileEditViewController.h"

@interface UserProfileDisplayViewController ()
@property (strong, nonatomic)   AzureUserInterface   *getUserService;
@property (strong, nonatomic) SignUpUser *suu;
@end

NSString *titleArray[10] = {
    @"摄影小精灵",
    @"小马识图",
    @"胶片达人",
    @"晒图发烧友",
    @"独立制片人",
    @"伯乐爷",
    @"火眼金睛",
    @"人民艺术家",
    @"业界泰斗",
    @"众神之神",
};

NSInteger titleScore[10]= {
    0,
    10,
    50,
    90,
    140,
    200,
    270,
    350,
    440,
    540,
};

@implementation UserProfileDisplayViewController

@synthesize fromWhichUser;
/*
 0 - Me
 1 - Others
 */
@synthesize LocationList = _LocationList;

-(NSArray *) LocationList
{
    if(!_LocationList)
    {
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Location" ofType:@"plist"];
        _LocationList = [NSArray arrayWithContentsOfFile:plistPath];
    }
    
    return _LocationList;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    self.suu = [SignUpUser getInstance];
    [self.EditProfile.layer setCornerRadius:0.0f];
    [self.EditProfile.layer setBorderColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0].CGColor];
    [self.EditProfile.layer setBorderWidth:1.0f];
    
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_rest.png"] forState:UIControlStateNormal];
	// Do any additional setup after loading the view.
    [self.seeAllDiaries.layer setCornerRadius:0.0f];
    [self.seeAllDiaries.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.seeAllDiaries.layer setBorderWidth:1.0f];
    [self.UserScoreBarBackground.layer setZPosition:20];
    
    [self.LogOff.layer setCornerRadius:0.0f];
    [self.LogOff.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.LogOff.layer setBorderWidth:1.0f];
    
    self.getUserService = [AzureUserInterface defaultService];
    self.uiScrollView.delegate = (id)self;
    
    //    self.UserDescription.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"text_back.png"]];
    
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame: self.UserDescription.frame];
    
    [imgView setFrame:CGRectMake(0, 0, 256, 208)];
    imgView.image = [UIImage imageNamed: @"text_big.png"];
    [self.UserDescription addSubview: imgView];
    [self.UserDescription sendSubviewToBack: imgView];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if (self.getUserService.userid == fromWhichUser || fromWhichUser == 0)
    {
        // This is ME
        [self.getUserService refreshUser:self.getUserService.username completion:^(NSArray *results){
            self.UserName.text = [results[0] objectForKey:@"name"];
            self.UserDescription.text = [results[0] objectForKey:@"description"];
            self.suu.userDescription = self.UserDescription.text;
            if (self.UserDescription.text.length == 0)
            {
                [self.UserDescription setText:@"你目前没有个人说明"];
            }
            
            [self.seeAllDiaries setTitle:@"查看我的胶片" forState:UIControlStateNormal];
            NSInteger currScore = [[results[0] objectForKey:@"score"] integerValue];
            NSInteger nextLevelScore;
            for (int i = 0; ; i++)
            {
                if (currScore < titleScore[i])
                {
                    nextLevelScore = titleScore[i];
                    [self.UserTitle setText:titleArray[i-1]];
                    break;
                }
            }
            self.UserScore.text = [[NSString alloc]initWithFormat:@"%d/%d", currScore, nextLevelScore];
            UIImageView *scoreBar;
            scoreBar = [[UIImageView alloc]initWithFrame:CGRectMake(22, 402, 240 * currScore / nextLevelScore, 10)];
            [scoreBar setBackgroundColor:[UIColor colorWithRed:41/255.f green:171/255.f blue:226/255.f alpha:1.0]];
            [self.uiScrollView addSubview:scoreBar];
            NSInteger location = [[self.getUserService.loginUser[0] objectForKey:@"location"] integerValue];
            if (location != -1)
            {
                self.UserProvinceString.text = [self.LocationList objectAtIndex:location];
                self.suu.userProvinceIndex = location;
            }
            else
            {
                self.UserProvinceString.text = @"暂未设定";
            }
            if (self.suu.userProfileImage)
            {
                self.UserProfileImage.image = self.suu.userProfileImage;
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            }
            else
            {
                NSURL *url = [NSURL URLWithString:[self.getUserService.loginUser[0] objectForKey:@"profilePic"]];
                
                SDImageCache *cache = [[SDImageCache alloc]init];
                [cache queryDiskCacheForKey:[url absoluteString] done:^(UIImage *image, SDImageCacheType cacheType) {
                    if (image)
                    {
                        self.UserProfileImage.image = image;
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    }
                    else
                    {
                        NSURLRequest *request = [NSURLRequest requestWithURL:url];
                        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                            if (data) {
                                self.UserProfileImage.alpha = 0.0;
                                [UIView animateWithDuration:0.5 animations:^{
                                    self.UserProfileImage.image = [[UIImage alloc] initWithData:data];  // note the retain count here.
                                    self.UserProfileImage.alpha = 1.0;
                                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                    [[SDImageCache sharedImageCache]storeImage:self.UserProfileImage.image forKey:[url absoluteString]];
                                }];
                            } else {
                                // handle error
                            }
                        }];
                    }
                }];
                
            }
            
        }];
    }
    else
    {
        // This is OTHERS
        [self.LogOff setHidden:YES];
        [self.EditProfile setHidden:YES];
        [self.getUserService loadProfileForID:fromWhichUser completion:^{
            self.UserName.text = [self.getUserService.FriendProfile objectForKey:@"name"];
            self.UserDescription.text = [self.getUserService.FriendProfile objectForKey:@"description"];
            if (self.UserDescription.text.length == 0)
            {
                [self.UserDescription setText:@"TA目前没有个人说明"];
            }
            
            [self.seeAllDiaries setTitle:@"查看TA的胶片" forState:UIControlStateNormal];
            NSInteger currScore = [[self.getUserService.FriendProfile objectForKey:@"score"] integerValue];
            NSInteger nextLevelScore;
            for (int i = 0; ; i++)
            {
                if (currScore < titleScore[i])
                {
                    nextLevelScore = titleScore[i];
                    [self.UserTitle setText:titleArray[i-1]];
                    break;
                }
            }
            self.UserScore.text = [[NSString alloc]initWithFormat:@"%d/%d", currScore, nextLevelScore];
            UIImageView *scoreBar;
            scoreBar = [[UIImageView alloc]initWithFrame:CGRectMake(22, 402, 240 * currScore / nextLevelScore, 10)];
            [scoreBar setBackgroundColor:[UIColor colorWithRed:41/255.f green:171/255.f blue:226/255.f alpha:1.0]];
            [self.uiScrollView addSubview:scoreBar];
            
            
            NSInteger location = [[self.getUserService.FriendProfile objectForKey:@"location"] integerValue];
            if (location != -1)
            {
                self.UserProvinceString.text = [self.LocationList objectAtIndex:location];
            }
            else
            {
                self.UserProvinceString.text = @"暂未设定";
            }
            NSURL *url = [NSURL URLWithString:[self.getUserService.FriendProfile objectForKey:@"profilePic"]];
            SDImageCache *cache = [[SDImageCache alloc]init];
            [cache queryDiskCacheForKey:[url absoluteString] done:^(UIImage *image, SDImageCacheType cacheType) {
                if (image)
                {
                    self.UserProfileImage.image = image;
                }
                else
                {
                    NSURLRequest *request = [NSURLRequest requestWithURL:url];
                    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                        if (data) {
                            self.UserProfileImage.alpha = 0.0;
                            [UIView animateWithDuration:0.5 animations:^{
                                self.UserProfileImage.image = [[UIImage alloc] initWithData:data];  // note the retain count here.
                                self.UserProfileImage.alpha = 1.0;
                                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                [[SDImageCache sharedImageCache]storeImage:self.UserProfileImage.image forKey:[url absoluteString]];
                            }];
                        } else {
                            // handle error
                        }
                    }];
                }
            }];
            
        }];
    }
}

- (void)viewDidLoad
{
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] cleanDisk];
//    [[SDImageCache sharedImageCache] clearDisk];
}
- (void)viewWillAppear
{
    
}

- (void)viewDidLayoutSubviews
{
    // Need to set the scroll view content size here
    self.uiScrollView.contentSize = CGSizeMake(280, 700);
}

- (IBAction)pushBackButton_0:(id)sender {
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_pressed.png"] forState:UIControlStateNormal];
}

- (IBAction)pushBackButton:(id)sender {
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_rest.png"] forState:UIControlStateNormal];
    self.suu.userProfileImage = nil;
    [self.navigationController popViewControllerAnimated:YES];

}
- (IBAction)pushSeeAllDiaries_0:(id)sender {
    [self.seeAllDiaries setTitleColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.seeAllDiaries setBackgroundColor:[UIColor colorWithRed:251/255.0f green:175/255.0f blue:29/255.0f alpha:1.0]];
    [self.seeAllDiaries.layer setBorderWidth:0.0f];

}

- (IBAction)pushSeeAllDiaries:(id)sender {
    [self.seeAllDiaries setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.seeAllDiaries.layer setCornerRadius:0.0f];
    [self.seeAllDiaries.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.seeAllDiaries setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0]];
    [self.seeAllDiaries.layer setBorderWidth:1.0f];
    
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
    viewController.fromWhichUser = fromWhichUser;

    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)pushLogOff_0:(id)sender {
    [self.LogOff setTitleColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.LogOff setBackgroundColor:[UIColor colorWithRed:251/255.0f green:175/255.0f blue:29/255.0f alpha:1.0]];
    [self.LogOff.layer setBorderWidth:0.0f];
//    self.suu.userProfileImage = nil;
}

- (IBAction)pushLogOff:(id)sender {
    [self.LogOff setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.LogOff.layer setCornerRadius:0.0f];
    [self.LogOff.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.LogOff setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0]];
    [self.LogOff.layer setBorderWidth:1.0f];
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
    [self.LogOff setHidden:YES];
    
    NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
    [stdDefaults setObject:nil forKey:@"LOGIN_UNAME"];
    [stdDefaults setObject:nil forKey:@"LOGIN_UPWD"];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)pushEditProfile_0:(id)sender {
    [self.EditProfile.layer setBackgroundColor:[UIColor colorWithRed:229/255.0f green:118/255.0f blue:35/255.0f alpha:1.0].CGColor];
}

- (IBAction)pushEditProfile:(id)sender {
    [self.EditProfile.layer setBackgroundColor:[UIColor colorWithRed:251/255.0f green:176/255.0f blue:59/255.0f alpha:1.0].CGColor];
    UIStoryboard *storyboard;
    if (IS_IPHONE5)
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone5" bundle:nil];
    }
    else
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    }
    UserProfileEditViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"UserProfileEditViewController"];
    
    [self.navigationController pushViewController:viewController animated:YES];
}
- (IBAction)pushEditProfile_1:(id)sender {
    [self.EditProfile.layer setBackgroundColor:[UIColor colorWithRed:251/255.0f green:176/255.0f blue:59/255.0f alpha:1.0].CGColor];
}

- (IBAction)pushBackButton_1:(id)sender {
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_rest.png"] forState:UIControlStateNormal];
}

- (IBAction)pushSeeAllDiaries_1:(id)sender {
    [self.seeAllDiaries setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.seeAllDiaries.layer setCornerRadius:0.0f];
    [self.seeAllDiaries.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.seeAllDiaries setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0]];
    [self.seeAllDiaries.layer setBorderWidth:1.0f];
}

- (IBAction)pushLogOff_1:(id)sender {
    [self.LogOff setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.LogOff.layer setCornerRadius:0.0f];
    [self.LogOff.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.LogOff setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0]];
    [self.LogOff.layer setBorderWidth:1.0f];
}
@end
