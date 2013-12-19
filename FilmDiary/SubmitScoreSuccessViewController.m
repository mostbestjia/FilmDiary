//
//  SubmitScoreSuccessViewController.m
//  FilmDiary
//
//  Created by Yingjia Liu on 9/8/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import "SubmitScoreSuccessViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SubmitScoreSuccessViewController ()

@end

@implementation SubmitScoreSuccessViewController

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
    [self.GoodButton.layer setCornerRadius:0.0f];
    [self.GoodButton.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.GoodButton.layer setBorderWidth:1.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushGoodButton:(id)sender {
    [self.GoodButton setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.GoodButton.layer setCornerRadius:0.0f];
    [self.GoodButton.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.GoodButton setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0]];
    [self.GoodButton.layer setBorderWidth:1.0f];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pushGoodButton_0:(id)sender {
    [self.GoodButton setTitleColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.GoodButton setBackgroundColor:[UIColor colorWithRed:251/255.0f green:175/255.0f blue:29/255.0f alpha:1.0]];
    [self.GoodButton.layer setBorderWidth:0.0f];

}

- (IBAction)pushGoodButton_1:(id)sender {
    [self.GoodButton.layer setCornerRadius:0.0f];
    [self.GoodButton.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.GoodButton.layer setBorderWidth:1.0f];

}
@end
