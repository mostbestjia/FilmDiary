//
//  HistoryDiaryViewController.h
//  FilmDiary
//
//  Created by Yingjia Liu on 8/13/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryDiaryViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *BackButton;
- (IBAction)pushBackButton_0:(id)sender;
- (IBAction)pushBackButton:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *HistoryTableView;
@property(nonatomic) NSInteger fromWhichView;
@property (strong, nonatomic) IBOutlet UIButton *WriteDiaryBtn;
- (IBAction)pushWriteDiary_0:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *NoHistoryImg;
@property (nonatomic) NSInteger fromWhichUser;
- (IBAction)pushBackButton_1:(id)sender;
@end
