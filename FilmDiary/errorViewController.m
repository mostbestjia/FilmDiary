//
//  errorViewController.m
//  FilmDiary
//
//  Created by Yingjia Liu on 7/14/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import "errorViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface errorViewController ()

@end

@implementation errorViewController

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
    [self.BackButton.layer setCornerRadius:0.0f];
    [self.BackButton.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.BackButton.layer setBorderWidth:1.0f];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushBackButton_0:(id)sender {
    [self.BackButton setTitleColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.BackButton setBackgroundColor:[UIColor colorWithRed:251/255.0f green:175/255.0f blue:29/255.0f alpha:1.0]];
    [self.BackButton.layer setBorderWidth:0.0f];
}

- (IBAction)pushBackButton:(id)sender {
    [self.BackButton setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.BackButton.layer setCornerRadius:0.0f];
    [self.BackButton.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.BackButton setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0]];
    [self.BackButton.layer setBorderWidth:1.0f];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pushBackButton_1:(id)sender {
    [self.BackButton setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.BackButton.layer setCornerRadius:0.0f];
    [self.BackButton.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.BackButton setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0]];
    [self.BackButton.layer setBorderWidth:1.0f];
}
@end
