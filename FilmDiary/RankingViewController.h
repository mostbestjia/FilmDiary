//
//  RankingViewController.h
//  FilmDiary
//
//  Created by Yingjia Liu on 8/5/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankingViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *RankingFirstRunBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *RankingScrollView;
@property (strong, nonatomic) IBOutlet UIButton *BackButton;
- (IBAction)pushBackButton_0:(id)sender;
- (IBAction)pushBackButton:(id)sender;
@property(nonatomic) NSInteger fromWhichView;
- (IBAction)pushFirstRunBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *CloudParallex;
- (IBAction)pushBackButton_1:(id)sender;
@end
