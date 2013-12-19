//
//  CommentDiaryCell.h
//  FilmDiary
//
//  Created by Yingjia Liu on 9/1/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentDiaryCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *CommentUser;
@property (nonatomic, strong) IBOutlet UILabel *CommentDate;
@property (nonatomic, strong) IBOutlet UILabel *CommentContent;


@end
