//
//  LocationSelectionViewController.m
//  FilmDiary
//
//  Created by Yingjia Liu on 12/18/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import "LocationSelectionViewController.h"

@interface LocationSelectionViewController ()
@property (strong, nonatomic) SignUpUser *suu;

@end

@implementation LocationSelectionViewController

@synthesize LocationList = _LocationList;

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
	// Do any additional setup after loading the view.
    self.LocationTabelView.delegate = (id)self;
    self.LocationTabelView.dataSource = (id)self;
    [self.LocationTabelView reloadData];
    self.suu = [SignUpUser getInstance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *) LocationList
{
    if(!_LocationList)
    {
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Location" ofType:@"plist"];
        _LocationList = [NSArray arrayWithContentsOfFile:plistPath];
    }
    
    return _LocationList;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.LocationList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    [cell.textLabel setFrame:CGRectMake(20, 15, 100, 36)];
    cell.textLabel.text = [self.LocationList objectAtIndex:indexPath.row];
    [cell.textLabel setTextColor:[UIColor grayColor]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14.f]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    self.suu.userProvinceIndex = indexPath.row;
    self.suu.userProvinceString = [self.LocationList objectAtIndex:indexPath.row];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
