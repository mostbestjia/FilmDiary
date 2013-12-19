//
//  AboutUsViewController.h
//  FilmDiary
//
//  Created by Yingjia Liu on 8/13/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface AboutUsViewController : UIViewController <MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *BackButton;
- (IBAction)pushBackButton_0:(id)sender;
- (IBAction)pushBackButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *AboutUsScrollView;

@property (strong, nonatomic) IBOutlet UIButton *SendFriend;
- (IBAction)pushSendFriend_0:(id)sender;
- (IBAction)pushSendFriend:(id)sender;
- (IBAction)pushBackButton_1:(id)sender;
- (IBAction)pushRateUsOnStore_1:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *WriteUsMail;
- (IBAction)pushWriteUsMail_0:(id)sender;
- (IBAction)pushWriteUsMail:(id)sender;
- (IBAction)pushWriteUsMail_1:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *RateUsOnStore;
- (IBAction)pushRateUsOnStore_0:(id)sender;
- (IBAction)pushRateUsOnStore:(id)sender;
- (IBAction)pushSendFriend_1:(id)sender;

@end
