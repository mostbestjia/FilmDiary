//
//  HelpViewController.h
//  FilmDiary
//
//  Created by Yingjia Liu on 8/15/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *BackButton;
- (IBAction)pushBackButton_0:(id)sender;
- (IBAction)pushBackButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *HelpScrollView;
- (IBAction)pushBackButton_1:(id)sender;

@end
