//
//  DataViewController.m
//  FilmDiary
//
//  Created by Yingjia Liu on 4/20/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import "DataViewController.h"
#import "AzureUserInterface.h"
#import "HubViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import "util.h"
#import "TermsOfUseViewController.h"
#import "NewUser1ViewController.h"

@interface DataViewController ()

// Private properties
@property (strong, nonatomic)   AzureUserInterface   *getUserService;
@property (nonatomic,strong) MPMoviePlayerViewController *moviePlayer;
@end

static NSString *uPwd;

@implementation DataViewController


- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
    [self.view setUserInteractionEnabled:YES];
//    [self.view setExclusiveTouch:YES];
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
    
    if ([player
         respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [player.view removeFromSuperview];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer: tap];
    self.nameTextField.delegate = (id)self;
    self.passwordTextField.delegate = (id)self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
    if([stdDefaults boolForKey:@"VIDEO_PLAYED"] == NO)
    {
        [self.view setUserInteractionEnabled:NO];
        [stdDefaults setBool:YES forKey:@"VIDEO_PLAYED"];
        [stdDefaults synchronize];
        NSString *thePath;
        if (IS_IPHONE5)
        {
            thePath = [[NSBundle mainBundle] pathForResource:@"panda5" ofType:@"mp4"];
        }
        else
        {
            thePath = [[NSBundle mainBundle] pathForResource:@"panda" ofType:@"mp4"];
        }
        NSURL*url=[NSURL fileURLWithPath:thePath];
        
        UIGraphicsBeginImageContext(CGSizeMake(1,1));
        _moviePlayer =  [[MPMoviePlayerViewController alloc] initWithContentURL: url];
        UIGraphicsEndImageContext();
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayBackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:_moviePlayer.moviePlayer];
        
        [_moviePlayer.moviePlayer prepareToPlay];
        [self.view addSubview:_moviePlayer.view];
        _moviePlayer.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        _moviePlayer.moviePlayer.controlStyle = MPMovieControlStyleNone;
        _moviePlayer.moviePlayer.shouldAutoplay = YES;
        [_moviePlayer.moviePlayer.view setFrame: self.view.bounds];
        [_moviePlayer.moviePlayer setFullscreen:YES animated:YES];
        [_moviePlayer.moviePlayer play];
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.nameTextField endEditing:YES];
    [self.passwordTextField endEditing:YES];
    [self.view setUserInteractionEnabled:YES];
    [self.uiScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.errorMsg setHidden:YES];
    [self.spinningDonut setHidden:YES];
    [self.SignUpBtn setEnabled:YES];
    [self.AuthBtn setEnabled:NO];
    [self.TOUBtn setEnabled:YES];
    
    self.getUserService = [AzureUserInterface defaultService];
    if ([stdDefaults objectForKey:@"LOGIN_UNAME"] && [stdDefaults objectForKey:@"LOGIN_UPWD"])
    {
        [self.nameTextField setText:[stdDefaults objectForKey:@"LOGIN_UNAME"]];
        [self.passwordTextField setText:@"8888888888"];
        uPwd = [stdDefaults objectForKey:@"LOGIN_UPWD"];
        [self loginUser];
    }
    else
    {
        [self.nameTextField setText:[stdDefaults objectForKey:@""]];
        [self.passwordTextField setText:@""];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.nameTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if(textField == self.passwordTextField) {
        uPwd = self.passwordTextField.text;
        [self loginUser];
    }
    return NO;
}

-(void)loginUser
{
    [self.view setUserInteractionEnabled:NO];
    [self.SignUpBtn setEnabled:NO];
    [self.AuthBtn setEnabled:NO];
    [self.TOUBtn setEnabled:NO];
    [self.errorMsg setHidden:YES];
    [self.spinningDonut setHidden:NO];
    [self dismissKeyboard];
    
    [self.spinningDonut startAnimating];
    //[self.nameTextField.text]
    NSDictionary *item = @{ @"name" : self.nameTextField.text, @"password": uPwd};
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.getUserService loginUser:item completion:^
     {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         int c = self.getUserService.loginUser.count;
         [self.spinningDonut stopAnimating];
         [self.spinningDonut setHidden:YES];
         if (c == 0)
         {
             [self.errorMsg setHidden:NO];
             [self.view setUserInteractionEnabled:YES];
             [self.SignUpBtn setEnabled:YES];
             [self.AuthBtn setEnabled:YES];
             [self.TOUBtn setEnabled:YES];
             [self.spinningDonut setHidden:YES];
             NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
             [stdDefaults setObject:nil forKey:@"LOGIN_UNAME"];
             [stdDefaults setObject:nil forKey:@"LOGIN_UPWD"];
         }
         else
         {
             NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
             [stdDefaults setObject:self.nameTextField.text forKey:@"LOGIN_UNAME"];
             [stdDefaults setObject:uPwd forKey:@"LOGIN_UPWD"];
             
             
             UIStoryboard *storyboard;
             if (IS_IPHONE5)
             {
                 storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone5" bundle:nil];
             }
             else
             {
                 storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
             }
             HubViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"HubViewController"];
             [self.navigationController pushViewController:viewController animated:YES];
         }
     }];
    [self.passwordTextField endEditing:YES];
}

-(void)dismissKeyboard
{
    [self.uiScrollView resignFirstResponder];
    [self.uiScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.nameTextField endEditing:YES];
    [self.passwordTextField endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nameEditBegin:(id)sender {
    [self.uiScrollView setContentOffset:CGPointMake(0, 125) animated:YES];
}

- (IBAction)nameEditEnd:(id)sender {
    [self.uiScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (IBAction)passwordEditEnd:(id)sender {
    [self.uiScrollView setContentOffset:CGPointMake(0, 0) animated:YES];

}

- (IBAction)passwordEditBegin:(id)sender {
    [self.uiScrollView setContentOffset:CGPointMake(0, 125) animated:YES];
}

- (IBAction)pushTermsOfUse:(id)sender {
    UIStoryboard *storyboard;
    if (IS_IPHONE5)
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone5" bundle:nil];
    }
    else
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    }
    TermsOfUseViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"TermsOfUseViewController"];
    [self presentViewController:viewController animated:YES completion:^{}];
}
- (IBAction)pushSignup:(id)sender {
    UIStoryboard *storyboard;
    if (IS_IPHONE5)
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone5" bundle:nil];
    }
    else
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    }
    NewUser1ViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"NewUserController1"];
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
