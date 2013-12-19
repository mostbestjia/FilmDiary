//
//  FavViewController.m
//  FilmDiary
//
//  Created by Yingjia Liu on 9/2/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import "FavViewController.h"
#import "AzureUserInterface.h"
#import "HistoryDiaryCell.h"
#import "DiaryViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "util.h"

@interface FavViewController ()
@property (strong, nonatomic)   AzureUserInterface   *getFavService;
@end

@implementation FavViewController
@synthesize fromWhichView;
/*
 0 - HubView
 1 - DiaryView
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
    return self.getFavService.favDiaries.count;
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
    
    // Configure the cell...
    cell.DiaryTitle.text = [self.getFavService.favDiaries[indexPath.row] objectForKey:@"diaryTitle"];
    cell.DiaryDate.text = [self.getFavService.favDiaries[indexPath.row] objectForKey:@"diaryDate"];
    [cell.DiaryRanked setHidden:YES];
    [cell.DiaryComments setHidden:YES];
    NSURL *url = [NSURL URLWithString:[self.getFavService.favDiaries[indexPath.row] objectForKey:@"diaryPicUrl"]];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    SDImageCache *cache = [[SDImageCache alloc]init];
    [cache queryDiskCacheForKey:[url absoluteString] done:^(UIImage *image, SDImageCacheType cacheType) {
        if (image)
        {
            [cell.DiaryImage setImage:image];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        else
        {
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

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    self.getFavService.diaryid = [[self.getFavService.favDiaries[indexPath.row] objectForKey:@"id"] integerValue];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    [self.FavFirstRunBtn setHidden:YES];
	// Do any additional setup after loading the view.
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_rest.png"] forState:UIControlStateNormal];
    self.FavTableView.delegate = (id)self;
    self.FavTableView.dataSource = (id)self;
    [self.FavTableView setHidden:YES];
    self.getFavService = [AzureUserInterface defaultService];
    
    if (fromWhichView == 0)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [self.getFavService loadFavDiariesForUser:self.getFavService.userid completion:^{
            
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"diarySecondsInterval" ascending:NO];
            
            self.getFavService.favDiaries = [[self.getFavService.favDiaries sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
            
            [self.FavTableView setHidden:NO];
            [self.FavTableView reloadData];
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            if (self.getFavService.favDiaries.count == 0)
            {
                [self.FavFirstRunBtn setHidden:NO];
            }
        }];
    }
    else
    {
        [self.FavTableView setHidden:NO];
        [self.FavTableView reloadData];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (self.getFavService.favDiaries.count == 0)
        {
            [self.FavFirstRunBtn setHidden:NO];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.    
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] cleanDisk];
    [[SDImageCache sharedImageCache] clearDisk];
}


- (IBAction)pushBackButton_0:(id)sender {
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_pressed.png"] forState:UIControlStateNormal];
}

- (IBAction)pushBackButton:(id)sender {
    [self.BackButton setBackgroundImage:[UIImage imageNamed:@"back_button_rest.png"] forState:UIControlStateNormal];
    self.getFavService.filmDiary=nil;
    [self.FavTableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
