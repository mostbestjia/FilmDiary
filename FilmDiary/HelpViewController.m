//
//  HelpViewController.m
//  FilmDiary
//
//  Created by Yingjia Liu on 8/15/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import "HelpViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface HelpViewController ()

@end

@implementation HelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
	// Do any additional setup after loading the view.
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_red_rest.png"] forState:UIControlStateNormal];
    
    UIImageView *Cloud = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"help.png"]];
    [Cloud setFrame:CGRectMake(0, 0, 320, 1393)];
    [self.HelpScrollView addSubview:Cloud];
    [Cloud.layer setZPosition:-15];
}

- (void)viewDidLayoutSubviews
{
    // Need to set the scroll view content size here
    self.HelpScrollView.contentSize = CGSizeMake(320, 1393);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushBackButton_0:(id)sender {
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_red_pressed.png"] forState:UIControlStateNormal];
}

- (IBAction)pushBackButton:(id)sender {
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_red_rest.png"] forState:UIControlStateNormal];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)pushBackButton_1:(id)sender {
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_red_rest.png"] forState:UIControlStateNormal];
}
@end
