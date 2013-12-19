//
//  util.h
//  FilmDiary
//
//  Created by Yingjia Liu on 9/25/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#ifndef FilmDiary_util_h
#define FilmDiary_util_h

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#endif
