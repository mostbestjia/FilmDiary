//
//  CommentViewController.m
//  FilmDiary
//
//  Created by Yingjia Liu on 8/15/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import "CommentViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AzureUserInterface.h"
#import "CommentDiaryCell.h"
#import "DiaryViewController.h"
#import "util.h"


@interface CommentViewController ()
@property (strong, nonatomic)   AzureUserInterface   *getCommentService;
@end

bool isKeyboardShowing = NO;
bool startTyping = NO;

@implementation CommentViewController

@synthesize fromWhichView;
/*
 0 - history
 1 - fav
 2 - ranking
 3 - rating
 */

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
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_rest.png"] forState:UIControlStateNormal];
    self.getCommentService = [AzureUserInterface defaultService];
    [self.Comment.layer setCornerRadius:0.0f];
    [self.Comment.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.Comment.layer setBorderWidth:1.0f];
//    [self.CommentTextBox.layer setCornerRadius:0.0f];
//    [self.CommentTextBox.layer setBorderColor:[UIColor colorWithRed:251/255.0f green:175/255.0f blue:29/255.0f alpha:1.0].CGColor];
//    [self.CommentTextBox.layer setBorderWidth:1.0f];
    
    self.CommentTextBox.delegate = (id)self;
    self.CommentTableView.delegate = (id)self;
    self.CommentTableView.dataSource = (id)self;
    [self.CommentTableView setHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputModeDidChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer: tap];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    [self.getCommentService loadCommentsForDiary:self.getCommentService.diaryid completion:^{
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"commentSecondsInterval" ascending:NO];        
        self.getCommentService.diaryComments = [self.getCommentService.diaryComments sortedArrayUsingDescriptors:@[sortDescriptor]];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

        [self.CommentTableView setHidden:NO];
        [self.CommentTableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard
{
    startTyping = NO;
    [self.CommentTextBox resignFirstResponder];
    int CommentTextY = 422;
    if (IS_IPHONE5)
    {
        CommentTextY = 509;
    }
    
    if (IS_OS_7_OR_LATER)
    {
        CommentTextY += 20;
    }
    [self.CommentTextBox setFrame:CGRectMake(15, CommentTextY, 290, 33)];
    [self.CommentImageView setFrame:CGRectMake(5, CommentTextY, 310, 33)];
}


- (void)keyboardDidHide:(NSNotification*)notification
{
    isKeyboardShowing = NO;
}

- (void)keyboardDidShow:(NSNotification*)notification
{
    isKeyboardShowing = YES;
}

- (void)inputModeDidChange:(NSNotification*)notification
{
    if (isKeyboardShowing)
    {
        int CommentTextY = 205;
        if (IS_IPHONE5)
        {
            CommentTextY = 292;
        }
        
        if (IS_OS_7_OR_LATER)
        {
            CommentTextY += 20;
        }
        
        if (startTyping && [[UITextInputMode currentInputMode].primaryLanguage rangeOfString:@"zh-"].location != NSNotFound)
        {
            CommentTextY -= 33;
        }
        
        if (startTyping && [[UITextInputMode currentInputMode].primaryLanguage rangeOfString:@"en-"].location != NSNotFound)
        {
            CommentTextY += 33;
        }
        [self.CommentTextBox setFrame:CGRectMake(15, CommentTextY, 290, 33)];
        [self.CommentImageView setFrame:CGRectMake(5, CommentTextY, 310, 33)];

    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = ([indexPath row]%2)?[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0]:[UIColor whiteColor];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.getCommentService.diaryComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CommentCell";
    
    CommentDiaryCell *cell = [tableView
                              dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CommentDiaryCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    
    // Configure the cell...
    cell.CommentUser.text = [self.getCommentService.diaryComments[indexPath.row] objectForKey:@"commentUser"];
    cell.CommentDate.text = [self.getCommentService.diaryComments[indexPath.row] objectForKey:@"commentDate"];
    cell.CommentContent.text = [self.getCommentService.diaryComments[indexPath.row] objectForKey:@"commentContent"];    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 113;
}



- (IBAction)pushComment_0:(id)sender {
    [self.Comment setTitleColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.Comment setBackgroundColor:[UIColor colorWithRed:251/255.0f green:175/255.0f blue:29/255.0f alpha:1.0]];
    [self.Comment.layer setBorderWidth:0.0f];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.CommentTextBox) {
        [self.CommentTextBox endEditing:YES];
        
        int CommentTextY = 422;
        if (IS_IPHONE5)
        {
            CommentTextY = 509;
        }
        
        if (IS_OS_7_OR_LATER)
        {
            CommentTextY += 20;
        }
        [self.CommentTextBox setFrame:CGRectMake(15, CommentTextY, 290, 33)];
        [self.CommentImageView setFrame:CGRectMake(5, CommentTextY, 310, 33)];
        if (self.CommentTextBox.text.length != 0)
        {
            //Upload table entity
            NSDate *currentDate = [NSDate date];
            NSCalendar* calendar = [NSCalendar currentCalendar];
            NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate]; // Get necessary date components
            int year = [components year];
            int month = [components month];
            int day = [components day];
            NSString *submitDateString = [[NSString alloc] initWithFormat:@"%d年%d月%d日",year,month,day ];
            //To convert back, use initWithTimeIntervalSinceReferenceDate
            double secondsInterval = [[NSDate date] timeIntervalSince1970];
            
            NSDictionary *item = @{
                                   @"userID": [NSNumber numberWithInteger: self.getCommentService.userid],
                                   @"diaryID": [NSNumber numberWithInteger: self.getCommentService.diaryid],
                                   @"commentUser": self.getCommentService.username,
                                   @"commentContent" : self.CommentTextBox.text,
                                   @"commentDate" : submitDateString,
                                   @"commentSecondsInterval": [NSNumber numberWithDouble:secondsInterval]
                                   };
            __weak typeof(self) weakSelf = self;
            [self.getCommentService addComment:item completion:^{
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                
                [weakSelf.getCommentService loadCommentsForDiary:weakSelf.getCommentService.diaryid completion:^{
                    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"commentSecondsInterval" ascending:NO];
                    weakSelf.getCommentService.diaryComments = [weakSelf.getCommentService.diaryComments sortedArrayUsingDescriptors:@[sortDescriptor]];
                    [weakSelf.CommentTextBox setText:@""];
                    [weakSelf.CommentTableView setHidden:NO];
                    [weakSelf.CommentTableView reloadData];
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    
                }];
            }];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"评论不能为空"
                                                           delegate:self
                                                  cancelButtonTitle:@"返回编辑"
                                                  otherButtonTitles:nil,nil];
            alert.tag = 1;
            [alert show];
        }

    }
    return NO;
}

- (IBAction)pushComment:(id)sender {
    if (self.CommentTextBox.text.length != 0)
    {
        [self.Comment setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0] forState:UIControlStateNormal];
        [self.Comment.layer setCornerRadius:0.0f];
        [self.Comment.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
        [self.Comment.layer setBorderWidth:1.0f];
        [self.Comment setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0]];
        
        
        //Upload table entity
        NSDate *currentDate = [NSDate date];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate]; // Get necessary date components
        int year = [components year];
        int month = [components month];
        int day = [components day];
        NSString *submitDateString = [[NSString alloc] initWithFormat:@"%d年%d月%d日",year,month,day ];
        //To convert back, use initWithTimeIntervalSinceReferenceDate
        double secondsInterval = [[NSDate date] timeIntervalSince1970];
        
        NSDictionary *item = @{
                               @"userID": [NSNumber numberWithInteger: self.getCommentService.userid],
                               @"diaryID": [NSNumber numberWithInteger: self.getCommentService.diaryid],
                               @"commentUser": self.getCommentService.username,
                               @"commentContent" : self.CommentTextBox.text,
                               @"commentDate" : submitDateString,
                               @"commentSecondsInterval": [NSNumber numberWithDouble:secondsInterval]
                               };
        __weak typeof(self) weakSelf = self;
        [self.getCommentService addComment:item completion:^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            
            [weakSelf.getCommentService loadCommentsForDiary:weakSelf.getCommentService.diaryid completion:^{
                NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"commentSecondsInterval" ascending:NO];
                weakSelf.getCommentService.diaryComments = [weakSelf.getCommentService.diaryComments sortedArrayUsingDescriptors:@[sortDescriptor]];
                [weakSelf.CommentTableView setHidden:NO];
                [weakSelf.CommentTableView reloadData];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                
            }];
        }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"评论不能为空"
                                                       delegate:self
                                              cancelButtonTitle:@"返回编辑"
                                              otherButtonTitles:nil,nil];
        alert.tag = 1;
        [alert show];
    }
}

- (IBAction)CommentEditBegin:(id)sender {
    int CommentTextY = 205;
    if (IS_IPHONE5)
    {
        CommentTextY = 292;
    }
    
    startTyping = YES;
    if (IS_OS_7_OR_LATER)
    {
        CommentTextY += 20;
    }
    if ([[UITextInputMode currentInputMode].primaryLanguage rangeOfString:@"zh-"].location != NSNotFound)
    {
        CommentTextY -= 33;
    }
    [self.CommentTextBox setFrame:CGRectMake(15, CommentTextY, 290, 33)];
    [self.CommentImageView setFrame:CGRectMake(5, CommentTextY, 310, 33)];

}
- (IBAction)pushBackButton_0:(id)sender {
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_pressed.png"] forState:UIControlStateNormal];
}

- (IBAction)pushBackButton:(id)sender {
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_rest.png"] forState:UIControlStateNormal];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pushBackButton_1:(id)sender {
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_rest.png"] forState:UIControlStateNormal];
}
@end
