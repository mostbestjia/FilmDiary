//
//  SignUpUser.m
//  FilmDiary
//
//  Created by Yingjia Liu on 8/16/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import "SignUpUser.h"

@implementation SignUpUser

@synthesize username;
@synthesize userpassword;
@synthesize useremail;
@synthesize userProvinceIndex;
@synthesize userProvinceString;
@synthesize userProfileImage;
@synthesize userDescription;
static SignUpUser *instance =nil;

+(SignUpUser *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            
            instance= [SignUpUser new];
            instance.userProvinceIndex = -1;
        }
    }
    return instance;
}
@end
