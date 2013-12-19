//
//  HubViewController.h
//  FilmDiary
//
//  Created by Yingjia Liu on 7/14/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface HubViewController : UIViewController<UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *ShaiTuBang;
@property (strong, nonatomic) IBOutlet UIButton *WoLaiDianPing;
@property (strong, nonatomic) IBOutlet UIButton *JingDianShouCang;
@property (strong, nonatomic) IBOutlet UIButton *ChuangZuoJinTian;
@property (strong, nonatomic) IBOutlet UIButton *ChaKanYiWang;


- (IBAction)pushShaiTuBang_0:(id)sender;
- (IBAction)pushShaiTuBang:(id)sender;
- (IBAction)pushWoLaiDianPing_0:(id)sender;
- (IBAction)pushWoLaiDianPing:(id)sender;
- (IBAction)pushJingDianShouCang_0:(id)sender;
- (IBAction)pushJingDianShouCang:(id)sender;
- (IBAction)pushChuangZuoJinTian_0:(id)sender;
- (IBAction)pushChuangZuoJinTian:(id)sender;
- (IBAction)pushChaKanYiWang_0:(id)sender;
- (IBAction)pushChaKanYiWang:(id)sender;
- (IBAction)pushWodeMingPian:(id)sender;
- (IBAction)pushHelp:(id)sender;
- (IBAction)pushAboutUs:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *TeamLogo;
@end
