//
//  LocationSelectionViewController.h
//  FilmDiary
//
//  Created by Yingjia Liu on 12/18/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUpUser.h"

@interface LocationSelectionViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSArray *LocationList;
@property (strong, nonatomic) IBOutlet UITableView *LocationTabelView;
@end
