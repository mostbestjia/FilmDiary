//
//  CommentDiaryCell.m
//  FilmDiary
//
//  Created by Yingjia Liu on 9/1/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import "CommentDiaryCell.h"

@implementation CommentDiaryCell

@synthesize CommentContent = _CommentContent;
@synthesize CommentDate = _CommentDate;
@synthesize CommentUser = _CommentUser;

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
