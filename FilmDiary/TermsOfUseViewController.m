//
//  TermsOfUseViewController.m
//  FilmDiary
//
//  Created by Yingjia Liu on 10/1/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import "TermsOfUseViewController.h"

@interface TermsOfUseViewController ()

@end

@implementation TermsOfUseViewController

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
	// Do any additional setup after loading the view.
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_red_rest.png"] forState:UIControlStateNormal];
    UIImageView *Pic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"terms_s.jpg"]];
    [Pic setFrame:CGRectMake(0, 0, 320, 7418)];
    [self.TOUScrollView addSubview:Pic];
    [Pic.layer setZPosition:-15];
}

- (void)viewDidLayoutSubviews
{
    self.TOUScrollView.contentSize = CGSizeMake(320, 7418);

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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pushBackButton_1:(id)sender {
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_red_rest.png"] forState:UIControlStateNormal];
}

@end
