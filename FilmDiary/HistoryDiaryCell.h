//
//  HistoryDiaryCell.h
//  FilmDiary
//
//  Created by Yingjia Liu on 8/13/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryDiaryCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *DiaryImage;
@property (nonatomic, strong) IBOutlet UILabel *DiaryTitle;
@property (nonatomic, strong) IBOutlet UILabel *DiaryDate;
@property (strong, nonatomic) IBOutlet UIImageView *DiaryComments;
@property (strong, nonatomic) IBOutlet UIImageView *DiaryRanked;

@end
