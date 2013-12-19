//
//  NewUser3ViewController.m
//  FilmDiary
//
//  Created by Yingjia Liu on 8/16/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import "NewUser3ViewController.h"
#import "HubViewController.h"
#import "util.h"

@interface NewUser3ViewController ()
@property (strong, nonatomic)   AzureUserInterface   *addUserService;
@property (strong, nonatomic) SignUpUser *suu;
@end

@implementation NewUser3ViewController

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

    self.suu = [SignUpUser getInstance];
    self.addUserService = [AzureUserInterface defaultService];
    [self.SignupCompleteSpinning startAnimating];
	// Do any additional setup after loading the view.

    
    NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    [self.addUserService getSasUrlForNewBlob:guid forContainer:@"filmdiaryuserprofilepic" withCompletion:^(NSString *sasUrl) {
        __weak typeof(self) weakSelf = self;
        NSLog(@"\r\nPUT\r\n\t%@\r\n\t----->\r\n\t%@", guid, sasUrl);
        
        CGSize newSize = CGSizeMake(260.f, 260.f);
        UIGraphicsBeginImageContext(newSize);
        [self.suu.userProfileImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        NSData *imageData = UIImageJPEGRepresentation(UIGraphicsGetImageFromCurrentImageContext(), 1);
        UIGraphicsEndImageContext();
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:sasUrl]];
        [request setHTTPMethod:@"PUT"];
//        [request addValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
        // Default is 60
        [request setTimeoutInterval:80];
        [request setValue:@"BlockBlob"  forHTTPHeaderField:@"x-ms-blob-type"];
        [request setHTTPBody:imageData];
        [request setValue:[NSString stringWithFormat:@"%d", [imageData length]] forHTTPHeaderField:@"Content-Length"];
        
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if (conn) {
            // Create the NSMutableData to hold the received data.
            // receivedData is an instance variable declared elsewhere.
            _receivedData = [[NSMutableData alloc] init];
            [_receivedData setLength:0];
        } else {
            // Inform the user that the connection failed.
        }
        
        
        [weakSelf.addUserService updateUserLocation:weakSelf.suu.userProvinceIndex completion:^{
            
            [weakSelf.addUserService updateUserProfilePic:[[NSString alloc] initWithFormat:@"http://filmdiarydata.blob.core.windows.net/filmdiaryuserprofilepic/%@", guid] completion:^{
                
                [weakSelf.addUserService updateUserEmail:weakSelf.suu.useremail completion:^{
                    
                    [weakSelf.addUserService refreshUser:weakSelf.suu.username completion:^(NSArray *results){
                        
                        [weakSelf.SignupCompleteSpinning stopAnimating];
                        [weakSelf.SignupCompleteSpinning setHidden:YES];
                        
                        NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
                        
                        if([stdDefaults boolForKey:@"NOTIF"] == NO)
                        {
                            [stdDefaults setBool:YES forKey:@"NOTIF"];
                            UILocalNotification *localNotification = [[UILocalNotification alloc]init];
                            NSCalendar *calendar = [NSCalendar currentCalendar];
                            NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date]];
                            NSInteger hour = [components hour];
                            NSInteger minute = [components minute];
                            NSInteger second = [components second];
                            
                            float next9pm = SECONDS_SINCE_A_DAY_TO_9PM - hour * 3600 - minute *60 - second;
                            if (next9pm < 0)
                            {
                                next9pm += SECONDS_IN_A_DAY;
                            }
                            
                            localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:next9pm];
                            localNotification.alertBody = @"今日的晒图榜揭晓啦！";
                            localNotification.repeatInterval = NSDayCalendarUnit;
                            localNotification.timeZone = [NSTimeZone defaultTimeZone];
                            localNotification.soundName = UILocalNotificationDefaultSoundName;
                            localNotification.alertAction = @"Show";

                            [[UIApplication sharedApplication]scheduleLocalNotification:localNotification];
                        }
                        
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                        
                        [stdDefaults setObject:weakSelf.suu.username forKey:@"LOGIN_UNAME"];
                        [stdDefaults setObject:weakSelf.suu.userpassword forKey:@"LOGIN_UPWD"];

                        [weakSelf.navigationController popToRootViewControllerAnimated:NO];
                    }];
                }];
            }];
        }];
        
    }];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
+(NSString *)getUUID
{
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    NSString * uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    CFRelease(newUniqueId);
    
    return uuidString;
}

-(void)connection:(NSConnection*)conn didReceiveResponse:
(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ([httpResponse statusCode] >= 400) {
        NSLog(@"Status Code: %i", [httpResponse statusCode]);
        NSLog(@"Remote url returned error %d %@",[httpResponse statusCode],[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
    }
    else {
        NSLog(@"Safe Response Code: %i", [httpResponse statusCode]);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:
(NSData *)data
{
    [_receivedData appendData:data];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:
(NSError *)error
{
    //We should do something more with the error handling here
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:
           NSURLErrorFailingURLStringErrorKey]);
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *txt = [[NSString alloc] initWithData:_receivedData encoding: NSASCIIStringEncoding];
    NSLog(@"%@", txt);
    //pop the current view
    [self.navigationController popViewControllerAnimated:YES];
    //Posting message to refresh containers
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshBlobs" object:nil];
}
@end
