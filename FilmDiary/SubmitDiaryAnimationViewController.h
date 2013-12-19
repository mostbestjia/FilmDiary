//
//  SubmitDiaryAnimationViewController.h
//  FilmDiary
//
//  Created by Yingjia Liu on 9/8/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubmitDiaryAnimationViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *Diary;
@property (strong, nonatomic) IBOutlet UIImageView *Clip;
@property (strong, nonatomic) IBOutlet UIImageView *TextMask;
@property (strong, nonatomic) IBOutlet UIButton *GotoHub;
- (IBAction)pushGotoHub:(id)sender;
- (IBAction)pushGotoHub_0:(id)sender;
- (IBAction)pushGotoHub_1:(id)sender;

@end
