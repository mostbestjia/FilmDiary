//
//  CommentViewController.h
//  FilmDiary
//
//  Created by Yingjia Liu on 8/15/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *Comment;
@property (strong, nonatomic) IBOutlet UITextField *CommentTextBox;
- (IBAction)pushComment_0:(id)sender;
- (IBAction)pushComment:(id)sender;
- (IBAction)CommentEditBegin:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *CommentImageView;
@property (strong, nonatomic) IBOutlet UITableView *CommentTableView;
@property (strong, nonatomic) IBOutlet UIButton *BackButton;
- (IBAction)pushBackButton_0:(id)sender;
- (IBAction)pushBackButton:(id)sender;
@property(nonatomic) NSInteger fromWhichView;
- (IBAction)pushBackButton_1:(id)sender;
@end
