//
//  NewUser3ViewController.h
//  FilmDiary
//
//  Created by Yingjia Liu on 8/16/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AzureUserInterface.h"
#import "SignUpUser.h"

@interface NewUser3ViewController : UIViewController<NSURLConnectionDelegate>{
    NSMutableData* _receivedData;
}

@property (strong, nonatomic) IBOutlet UIButton *SignupCompleteButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *SignupCompleteSpinning;

@end
