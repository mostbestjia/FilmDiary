//
//  FavViewController.h
//  FilmDiary
//
//  Created by Yingjia Liu on 9/2/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *FavTableView;
@property (strong, nonatomic) IBOutlet UIButton *BackButton;
- (IBAction)pushBackButton_0:(id)sender;
- (IBAction)pushBackButton:(id)sender;
@property(nonatomic) NSInteger fromWhichView;
@property (strong, nonatomic) IBOutlet UIButton *FavFirstRunBtn;
@end
