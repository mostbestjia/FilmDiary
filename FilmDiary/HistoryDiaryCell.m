//
//  HistoryDiaryCell.m
//  FilmDiary
//
//  Created by Yingjia Liu on 8/13/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import "HistoryDiaryCell.h"

@implementation HistoryDiaryCell

@synthesize DiaryTitle = _DiaryTitle;
@synthesize DiaryImage = _DiaryImage;
@synthesize DiaryDate = _DiaryDate;
@synthesize DiaryRanked = _DiaryRanked;
@synthesize DiaryComments = _DiaryComments;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
