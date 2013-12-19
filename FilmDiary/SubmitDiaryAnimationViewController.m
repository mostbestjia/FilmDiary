//
//  SubmitDiaryAnimationViewController.m
//  FilmDiary
//
//  Created by Yingjia Liu on 9/8/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import "SubmitDiaryAnimationViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SubmitDiaryAnimationViewController ()
@end

@implementation SubmitDiaryAnimationViewController

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
    [self.Clip setHidden:YES];
    [self.TextMask setHidden:NO];
    [self.GotoHub.layer setCornerRadius:0.0f];
    [self.GotoHub.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.GotoHub.layer setBorderWidth:1.0f];
    [self.GotoHub setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [UIView animateWithDuration:0.2
                          delay:0 //delay by the duration of the first animation
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         self.Diary.transform = CGAffineTransformMakeTranslation(0, -65);
                     }
                     completion:^(BOOL completed){
                         [self.Clip setHidden:NO];
                         [self.TextMask setHidden:YES];
                         [self.GotoHub setHidden:NO];
                     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushGotoHub:(id)sender {
    [self.GotoHub setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.GotoHub.layer setCornerRadius:0.0f];
    [self.GotoHub.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.GotoHub setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0]];
    [self.GotoHub.layer setBorderWidth:1.0f];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pushGotoHub_0:(id)sender {
    [self.GotoHub setTitleColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.GotoHub setBackgroundColor:[UIColor colorWithRed:251/255.0f green:175/255.0f blue:29/255.0f alpha:1.0]];
    [self.GotoHub.layer setBorderWidth:0.0f];
}

- (IBAction)pushGotoHub_1:(id)sender {
    [self.GotoHub setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.GotoHub.layer setCornerRadius:0.0f];
    [self.GotoHub.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.GotoHub setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0]];
    [self.GotoHub.layer setBorderWidth:1.0f];
}

@end
