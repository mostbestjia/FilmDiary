//
//  HistoryDiaryViewController.m
//  FilmDiary
//
//  Created by Yingjia Liu on 8/13/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import "HistoryDiaryViewController.h"
#import "HistoryDiaryCell.h"
#import "AzureUserInterface.h"
#import "DiaryViewController.h"
#import "HubViewController.h"
#import "UserProfileDisplayViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "util.h"

@interface HistoryDiaryViewController ()
@property (strong, nonatomic)   AzureUserInterface   *getDiaryService;
@property (strong, nonatomic) NSMutableArray *DiaryComments;
@end

//BOOL CellsAnimated = NO;

@implementation HistoryDiaryViewController
@synthesize fromWhichView;
@synthesize fromWhichUser;
/*
 0 - HubView
 1 - UserProfileView
 2 - DiaryView
 3 - Other User ProfileView
 */


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.getDiaryService.filmDiaries.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = ([indexPath row]%2)?[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0]:[UIColor whiteColor];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"HistoryCell";
    
    HistoryDiaryCell *cell = [tableView
                              dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HistoryDiaryCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    cell.DiaryImage.image = [UIImage imageNamed:@"rating_placeholder.png"];
    [cell.DiaryComments setHidden:YES];
    [cell.DiaryRanked setHidden:YES];
    // Configure the cell...
    cell.DiaryTitle.text = [self.getDiaryService.filmDiaries[indexPath.row] objectForKey:@"diaryTitle"];
    cell.DiaryDate.text = [self.getDiaryService.filmDiaries[indexPath.row] objectForKey:@"diaryDate"];
    NSURL *url = [NSURL URLWithString:[self.getDiaryService.filmDiaries[indexPath.row] objectForKey:@"diaryPicUrl"]];
    
    if ([[self.DiaryComments objectAtIndex:indexPath.row] integerValue] == -1)
    {
        [self.getDiaryService loadCommentsForDiary:[[self.getDiaryService.filmDiaries[indexPath.row] objectForKey:@"id"] integerValue] completion:^{
            
            [self.DiaryComments replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInteger:self.getDiaryService.diaryComments.count]];
            
            if (self.getDiaryService.diaryComments.count > 0)
            {
                [cell.DiaryComments setHidden:NO];
            }
        }];
    }    
    else
    {
        if ([[self.DiaryComments objectAtIndex:indexPath.row] integerValue])
        {
            [cell.DiaryComments setHidden:NO];
        }
        else
        {
            [cell.DiaryComments setHidden:YES];
        }
    }
    
    if([[self.getDiaryService.filmDiaries[indexPath.row] objectForKey:@"diaryRedeemed"] integerValue])
    {
        [cell.DiaryRanked setHidden:NO];
    }
    else
    {
        [cell.DiaryRanked setHidden:YES];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    SDImageCache *cache = [[SDImageCache alloc]init];
    [cache queryDiskCacheForKey:[url absoluteString] done:^(UIImage *image, SDImageCacheType cacheType) {
        if (image)
        {
            [cell.DiaryImage setImage:image];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        else
        {    NSURLRequest *request = [NSURLRequest requestWithURL:url];

            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                if (data) {
                    cell.DiaryImage.alpha = 0.0;
                    [UIView animateWithDuration:0.5 animations:^{
                        cell.DiaryImage.image = [[UIImage alloc] initWithData:data];  // note the retain count here.
                        cell.DiaryImage.alpha = 1.0;
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];                        
                        [[SDImageCache sharedImageCache]storeImage:cell.DiaryImage.image forKey:[url absoluteString]];
                    }];
                } else {
                    // handle error
                }
            }];
        }
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 113;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    if (fromWhichUser == self.getDiaryService.userid || fromWhichUser == 0)
        return YES;
    else
        return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.view setUserInteractionEnabled:NO];
        [self.getDiaryService removeFilmDiary:self.getDiaryService.filmDiaries[indexPath.row] completion:^{
            [self loadDiaries];
            [self.view setUserInteractionEnabled:YES];
        }];
    }
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    self.getDiaryService.diaryid = [[self.getDiaryService.filmDiaries[indexPath.row] objectForKey:@"id"] integerValue];
    UIStoryboard *storyboard;
    if (IS_IPHONE5)
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone5" bundle:nil];
    }
    else
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    }
    DiaryViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"DiaryViewController"];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)loadDiaries
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.getDiaryService loadFilmDiaryForUser: fromWhichUser completion:^{
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"diarySecondsInterval" ascending:NO];
        
        self.getDiaryService.filmDiaries = [self.getDiaryService.filmDiaries sortedArrayUsingDescriptors:@[sortDescriptor]];
        
        self.DiaryComments = [[NSMutableArray alloc]init];
        for (int i = 0; i < self.getDiaryService.filmDiaries.count; i++)
        {
            [self.DiaryComments addObject:[NSNumber numberWithInteger:-1]];
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (self.getDiaryService.filmDiaries.count == 0)
        {
            if (fromWhichView <= 1)
            {
                if (IS_IPHONE5)
                {
                    [self.NoHistoryImg setImage:[UIImage imageNamed:@"diary_void_self_5.png"]];
                }
                else
                {
                    [self.NoHistoryImg setImage:[UIImage imageNamed:@"diary_void_self.png"]];
                }
                [self.WriteDiaryBtn.layer setCornerRadius:0.0f];
                [self.WriteDiaryBtn.layer setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor];
                [self.WriteDiaryBtn.layer setBorderWidth:1.0f];
                [self.WriteDiaryBtn setHidden:NO];
            }
            else if (fromWhichView == 3)
            {
                if (IS_IPHONE5)
                {
                    [self.NoHistoryImg setImage:[UIImage imageNamed:@"diary_void_others_5.png"]];
                }
                else
                {
                    [self.NoHistoryImg setImage:[UIImage imageNamed:@"diary_void_others.png"]];
                }
                
            }
        }
        else
        {
            
            [self.HistoryTableView setHidden:NO];
            [self.HistoryTableView reloadData];
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    // Do any additional setup after loading the view.
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_rest.png"] forState:UIControlStateNormal];
    self.HistoryTableView.delegate = (id)self;
    self.HistoryTableView.dataSource = (id)self;
    [self.HistoryTableView setHidden:YES];
    self.getDiaryService = [AzureUserInterface defaultService];
    [self.WriteDiaryBtn setHidden:YES];
    if (fromWhichView != 2){
        if (fromWhichUser == 0)
        {
            fromWhichUser = self.getDiaryService.userid;
        }
        [self loadDiaries];
    }
    else
    {
        [self.HistoryTableView setHidden:NO];
        [self.HistoryTableView reloadData];
        self.DiaryComments = [[NSMutableArray alloc]init];
        for (int i = 0; i < self.getDiaryService.filmDiaries.count; i++)
        {
            [self.DiaryComments addObject:[NSNumber numberWithInteger:-1]];
        }
        fromWhichView = 0;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] cleanDisk];
//    [[SDImageCache sharedImageCache] clearDisk];
}

- (IBAction)pushBackButton_0:(id)sender {
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_pressed.png"] forState:UIControlStateNormal];
}

- (IBAction)pushBackButton:(id)sender {
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_rest.png"] forState:UIControlStateNormal];
    self.getDiaryService.filmDiary=nil;
    [self.HistoryTableView reloadData];
        [self.navigationController popViewControllerAnimated:YES];

}
- (IBAction)pushWriteDiary_0:(id)sender {
    [self.WriteDiaryBtn setTitleColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.WriteDiaryBtn setBackgroundColor:[UIColor colorWithRed:251/255.0f green:175/255.0f blue:29/255.0f alpha:1.0]];
    [self.WriteDiaryBtn.layer setBorderWidth:0.0f];
}
- (IBAction)pushBackButton_1:(id)sender {
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_rest.png"] forState:UIControlStateNormal];
}
@end
