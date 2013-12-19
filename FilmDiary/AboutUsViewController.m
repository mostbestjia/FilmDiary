//
//  AboutUsViewController.m
//  FilmDiary
//
//  Created by Yingjia Liu on 8/13/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

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
        [self setAutomaticallyAdjustsScrollViewInsets:YES];
    }
    
    // Do any additional setup after loading the view.
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_red_rest.png"] forState:UIControlStateNormal];
    
    [self.SendFriend.layer setCornerRadius:0.0f];
    [self.SendFriend.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.SendFriend.layer setBorderWidth:1.0f];
    
    [self.WriteUsMail.layer setCornerRadius:0.0f];
    [self.WriteUsMail.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.WriteUsMail.layer setBorderWidth:1.0f];    
    
    [self.RateUsOnStore.layer setCornerRadius:0.0f];
    [self.RateUsOnStore.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.RateUsOnStore.layer setBorderWidth:1.0f];
    
    UIImageView *Cloud = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about_us.png"]];
    [Cloud setFrame:CGRectMake(0, 0, 320, 749)];
    [self.AboutUsScrollView addSubview:Cloud];
    [Cloud.layer setZPosition:-15];
}

- (void)viewDidLayoutSubviews
{
    // Need to set the scroll view content size here
    self.AboutUsScrollView.contentSize = CGSizeMake(320, 749);
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pushSendFriend_0:(id)sender {
    [self.SendFriend setTitleColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.SendFriend setBackgroundColor:[UIColor colorWithRed:251/255.0f green:175/255.0f blue:29/255.0f alpha:1.0]];
    [self.SendFriend.layer setBorderWidth:0.0f];
}

- (IBAction)pushSendFriend:(id)sender {
    [self.SendFriend setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.SendFriend.layer setCornerRadius:0.0f];
    [self.SendFriend.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.SendFriend setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0]];
    [self.SendFriend.layer setBorderWidth:1.0f];


    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = (id)self;
        [mailer setSubject:@"小伙伴们，快来玩胶片日记吧！"];
        NSArray *toRecipients = [NSArray arrayWithObjects:nil, nil];
        [mailer setToRecipients:toRecipients];
        NSString *emailBody = @"只要你有好故事，就能成为万众瞩目的明星！快来和我一起玩胶片日记吧！";
        [mailer setMessageBody:emailBody isHTML:NO];
        [self presentViewController:mailer animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"你的账户不支持发送邮件"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)pushBackButton_1:(id)sender {
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_red_rest.png"] forState:UIControlStateNormal];
}

- (IBAction)pushWriteUsMail:(id)sender {
    [self.WriteUsMail setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.WriteUsMail.layer setCornerRadius:0.0f];
    [self.WriteUsMail.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.WriteUsMail setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0]];
    [self.WriteUsMail.layer setBorderWidth:1.0f];
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = (id)self;
        [mailer setSubject:@"胶片日记应用反馈"];
        NSArray *toRecipients = [NSArray arrayWithObjects:@"jiaopianriji@outlook.com", nil];
        [mailer setToRecipients:toRecipients];
        NSString *emailBody = @"Hi, 胶片日记团队你好：";
        [mailer setMessageBody:emailBody isHTML:NO];
        [self presentViewController:mailer animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"你的账户不支持发送邮件"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }

}
- (IBAction)pushWriteUsMail_0:(id)sender {
    [self.WriteUsMail setTitleColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.WriteUsMail setBackgroundColor:[UIColor colorWithRed:251/255.0f green:175/255.0f blue:29/255.0f alpha:1.0]];
    [self.WriteUsMail.layer setBorderWidth:0.0f];
}

- (IBAction)pushRateUsOnStore_0:(id)sender {
    [self.RateUsOnStore setTitleColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.RateUsOnStore setBackgroundColor:[UIColor colorWithRed:251/255.0f green:175/255.0f blue:29/255.0f alpha:1.0]];
    [self.RateUsOnStore.layer setBorderWidth:0.0f];
}

- (IBAction)pushRateUsOnStore:(id)sender {
    [self.RateUsOnStore setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.RateUsOnStore.layer setCornerRadius:0.0f];
    [self.RateUsOnStore.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.RateUsOnStore setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0]];
    [self.RateUsOnStore.layer setBorderWidth:1.0f];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=719359430&mt=8"]];
}

- (IBAction)pushWriteUsMail_1:(id)sender {
    [self.WriteUsMail setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.WriteUsMail.layer setCornerRadius:0.0f];
    [self.WriteUsMail.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.WriteUsMail setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0]];
    [self.WriteUsMail.layer setBorderWidth:1.0f];
}

- (IBAction)pushSendFriend_1:(id)sender {
    [self.SendFriend setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.SendFriend.layer setCornerRadius:0.0f];
    [self.SendFriend.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.SendFriend setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0]];
    [self.SendFriend.layer setBorderWidth:1.0f];
}

- (IBAction)pushRateUsOnStore_1:(id)sender {
    [self.RateUsOnStore setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.RateUsOnStore.layer setCornerRadius:0.0f];
    [self.RateUsOnStore.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
    [self.RateUsOnStore setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0]];
    [self.RateUsOnStore.layer setBorderWidth:1.0f];
}
@end
