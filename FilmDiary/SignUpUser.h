//
//  SignUpUser.h
//  FilmDiary
//
//  Created by Yingjia Liu on 8/16/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignUpUser : NSObject{
    
    NSString *username;
    NSString *userpassword;
    NSString *useremail;
    NSInteger userProvinceIndex;
    UIImage *userProfileImage;
    NSString *userDescription;
}

//@property(nonatomic,retain)NSString *str;
@property(nonatomic,retain)NSString *username;
@property(nonatomic,retain)NSString *userpassword;
@property(nonatomic,retain)NSString *useremail;
@property(nonatomic,assign)NSInteger userProvinceIndex;
@property(nonatomic,retain)NSString *userProvinceString;
@property(nonatomic,retain)UIImage *userProfileImage;
@property(nonatomic,retain)NSString *userDescription;
+(SignUpUser*)getInstance;
@end
