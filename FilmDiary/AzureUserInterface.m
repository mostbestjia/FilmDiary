//
//  AzureInterface.m
//  FilmDiary
//
//  Created by Yingjia Liu on 7/27/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import "AzureUserInterface.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "errorViewController.h"

#pragma mark * Private interace


@interface AzureUserInterface() <MSFilter>

@property (nonatomic, strong)   MSTable *userTable;
@property (nonatomic, strong)   MSTable *diaryTable;
@property (nonatomic, strong)   MSTable *commentTable;
@property (nonatomic, strong)   MSTable *favTable;
@property (nonatomic, strong)   MSTable *scoreTable;
@property (nonatomic, strong)   MSTable *blobsTable;
@property (nonatomic, strong)   MSTable *spamsTable;
@end


#pragma mark * Implementation


@implementation AzureUserInterface

@synthesize loginUser;
@synthesize filmDiaries;
@synthesize favDiaries;
@synthesize diaryComments;
@synthesize filmDiary;
@synthesize rankingFilmDiaries;
@synthesize ratingFilmDiaries;
@synthesize favDiary;
@synthesize username;
@synthesize userid;
@synthesize provinceid;
@synthesize diaryid;
@synthesize diaryScoreFromUser;
@synthesize client = _client;
@synthesize FriendProfile;

+ (AzureUserInterface *)defaultService
{
    // Create a singleton instance of AzureInterface
    static AzureUserInterface* service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[AzureUserInterface alloc] init];
    });
    return service;
}

-(AzureUserInterface *)init
{
    self = [super init];
    
    if (self)
    {
        // Initialize the Mobile Service client with your URL and key
        MSClient *client = [MSClient clientWithApplicationURLString:@"https://filmdiary.azure-mobile.net/"
                                                     applicationKey:@"jwUIgtgpgrgBGaMyJFkwqiszYRJypc12"];
        
        // Add a Mobile Service filter to enable the busy indicator
        self.client = [client clientWithFilter:self];
        
        // Create an MSTable instance to allow us to work with the TodoItem table
        self.userTable = [_client tableWithName:@"FilmDiaryUser"];
        self.diaryTable = [_client tableWithName:@"FilmDiary"];
        self.commentTable = [_client tableWithName:@"FilmDiaryComments"];
        self.favTable = [_client tableWithName:@"FilmDiaryFav"];
        self.scoreTable = [_client tableWithName:@"FilmDiaryScore"];
        self.blobsTable = [_client tableWithName:@"FilmDiaryUserProfilePicBlobs"];
        self.spamsTable = [_client tableWithName:@"FilmDiarySpamReport"];
        
        // TODO: all init happens here
        // self.loginUser = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) addUser:(NSDictionary *)item
    completion:(CompletionBlock)completion
{
    // Insert the item into the TodoItem table and add to the items array on completion
    [self.userTable insert:item completion:^(NSDictionary *result, NSError *error)
     {
         [self logErrorIfNotNil:error];
         // Let the caller know that we finished
         completion();
     }];
}

- (void)logErrorIfNotNil:(NSError *) error
{
    if (error)
    {
        NSLog(@"ERROR %@", error);
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
//        errorViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"errorViewController"];
//        [self presentViewController:viewController animated:YES completion:nil];
    }
}

- (void)loadProfileForID:(NSInteger)userID
              completion:(CompletionBlock)completion
{
    NSString *queryString = [[NSString alloc] initWithFormat:@"id == %d", userID];
    
    // Create a predicate that finds items where complete is false
    NSPredicate * predicate = [NSPredicate predicateWithFormat:queryString];
    // Query the TodoItem table and update the items property with the results from the service
    [self.userTable readWithPredicate:predicate completion:^(NSArray *results, NSInteger totalCount, NSError *error)
     {
         [self logErrorIfNotNil:error];
         if (results.count > 0)
         {
             FriendProfile = [results mutableCopy][0];
         }
         // Let the caller know that we finished
         completion();
     }];
}

- (void)refreshUser:(NSString *)usernamestring
         completion:(CompletionWithResultsBlock)completion
{
    NSString *queryString = [[NSString alloc] initWithFormat:@"name == \"%@\"", usernamestring];
    
    // Create a predicate that finds items where complete is false
    NSPredicate * predicate = [NSPredicate predicateWithFormat:queryString];
    
    
    // Query the TodoItem table and update the items property with the results from the service
    [self.userTable readWithPredicate:predicate completion:^(NSArray *results, NSInteger totalCount, NSError *error)
     {
         [self logErrorIfNotNil:error];         
         loginUser = [results mutableCopy];
         if (loginUser.count > 0)
         {
             username = [loginUser[0] objectForKey:@"name"];
             userid = [[loginUser[0] objectForKey:@"id"] integerValue];
             provinceid = [[loginUser[0] objectForKey:@"location"] integerValue];
         }
         // Let the caller know that we finished
         completion(results);
     }];
}

- (void)loginUser:(NSDictionary *)item
       completion:(CompletionBlock)completion
{
    NSString *queryString = [[NSString alloc] initWithFormat:@"name == \"%@\" AND password == \"%@\"", [item objectForKey:@"name"], [item objectForKey:@"password"]];
    
    // Create a predicate that finds items where complete is false
    NSPredicate * predicate = [NSPredicate predicateWithFormat:queryString];
    
    
    // Query the TodoItem table and update the items property with the results from the service
    [self.userTable readWithPredicate:predicate completion:^(NSArray *results, NSInteger totalCount, NSError *error)
     {
         [self logErrorIfNotNil:error];
         
         loginUser = [results mutableCopy];
         if (loginUser.count > 0)
         {
             username = [loginUser[0] objectForKey:@"name"];
             userid = [[loginUser[0] objectForKey:@"id"] integerValue];
             provinceid = [[loginUser[0] objectForKey:@"location"]integerValue];
         }
         // Let the caller know that we finished
         completion();
     }];
}


#pragma mark * MSFilter methods


- (void)handleRequest:(NSURLRequest *)request
                 next:(MSFilterNextBlock)next
             response:(MSFilterResponseBlock)response
{
    // A wrapped response block that decrements the busy counter
    MSFilterResponseBlock wrappedResponse = ^(NSHTTPURLResponse *innerResponse, NSData *data, NSError *error)
    {
        response(innerResponse, data, error);
    };
    
    // Increment the busy counter before sending the request
    next(request, wrappedResponse);
}

- (void)updateUserLocation:(NSInteger)loc completion:(CompletionBlock)completion
{
    // Cast the public items property to the mutable type (it was created as mutable)
    NSMutableArray *mutableItems = (NSMutableArray *) loginUser;
    
    // Set the item to be complete (we need a mutable copy)
    [loginUser[0] setObject:[NSNumber numberWithInteger:loc] forKey:@"location"];
    NSMutableDictionary *mutable = [loginUser[0] mutableCopy];
    
    // Update the item in the TodoItem table and remove from the items array on completion
    [self.userTable update:mutable completion:^(NSDictionary *item, NSError *error) {
        
        [self logErrorIfNotNil:error];
        
        NSUInteger index = [loginUser indexOfObjectIdenticalTo:mutable];
        if (index != NSNotFound)
        {
            [mutableItems removeObjectAtIndex:index];
        }
        
        // Let the caller know that we have finished
        completion();
    }];
}

- (void)updateUserProfilePic:(NSString *)profilePic
                 completion:(CompletionBlock)completion
{
    
    // Cast the public items property to the mutable type (it was created as mutable)
    NSMutableArray *mutableItems = (NSMutableArray *) loginUser;
    
    // Set the item to be complete (we need a mutable copy)
    [loginUser[0] setObject:profilePic forKey:@"profilePic"];
    NSMutableDictionary *mutable = [loginUser[0] mutableCopy];
    
    // Update the item in the TodoItem table and remove from the items array on completion
    [self.userTable update:mutable completion:^(NSDictionary *item, NSError *error) {
        
        [self logErrorIfNotNil:error];
        
        NSUInteger index = [loginUser indexOfObjectIdenticalTo:mutable];
        if (index != NSNotFound)
        {
            [mutableItems removeObjectAtIndex:index];
        }
        
        // Let the caller know that we have finished
        completion();
    }];
}

- (void)updateUserEmail:(NSString *)description
            completion:(CompletionBlock)completion
{
    // Cast the public items property to the mutable type (it was created as mutable)
    NSMutableArray *mutableItems = (NSMutableArray *) loginUser;
    
    // Set the item to be complete (we need a mutable copy)
    [loginUser[0] setObject:description forKey:@"email"];
    NSMutableDictionary *mutable = [loginUser[0] mutableCopy];
    
    // Update the item in the TodoItem table and remove from the items array on completion
    [self.userTable update:mutable completion:^(NSDictionary *item, NSError *error) {
        
        [self logErrorIfNotNil:error];
        
        NSUInteger index = [loginUser indexOfObjectIdenticalTo:mutable];
        if (index != NSNotFound)
        {
            [mutableItems removeObjectAtIndex:index];
        }
        
        // Let the caller know that we have finished
        completion();
    }];
}


- (void)updateUserDescription:(NSString *)description
                   completion:(CompletionBlock)completion
{
    
    // Cast the public items property to the mutable type (it was created as mutable)
    NSMutableArray *mutableItems = (NSMutableArray *) loginUser;
    
    // Set the item to be complete (we need a mutable copy)
    [loginUser[0] setObject:description forKey:@"description"];
    NSMutableDictionary *mutable = [loginUser[0] mutableCopy];
    
    // Update the item in the TodoItem table and remove from the items array on completion
    [self.userTable update:mutable completion:^(NSDictionary *item, NSError *error) {
        
        [self logErrorIfNotNil:error];
        
        NSUInteger index = [loginUser indexOfObjectIdenticalTo:mutable];
        if (index != NSNotFound)
        {
            [mutableItems removeObjectAtIndex:index];
        }
        
        // Let the caller know that we have finished
        completion();
    }];
}

- (void)updateFriendUserRedeem:(NSDictionary *)friendDiary
                    completion:(CompletionBlock)completion
{
    NSMutableDictionary *mutable = [friendDiary mutableCopy];
    [mutable setObject:@YES forKey:@"Redeemed"];
    
    // Update the item in the TodoItem table and remove from the items array on completion
    [self.scoreTable update:mutable completion:^(NSDictionary *item, NSError *error) {
        [self logErrorIfNotNil:error];
        completion();
    }];
}

- (void)updateUserRedeem:(NSDictionary *)userDiary
              completion:(CompletionBlock)completion
{
    NSMutableDictionary *mutable = [userDiary mutableCopy];
    [mutable setObject:@YES forKey:@"diaryRedeemed"];
    
    // Update the item in the TodoItem table and remove from the items array on completion
    [self.diaryTable update:mutable completion:^(NSDictionary *item, NSError *error) {
        [self logErrorIfNotNil:error];
        completion();
    }];
}


- (void)updateUserScore:(NSInteger)score
            completion:(CompletionBlock)completion
{
    // Cast the public items property to the mutable type (it was created as mutable)
    NSMutableArray *mutableItems = (NSMutableArray *) loginUser;
    
    [loginUser[0] setObject:[NSNumber numberWithInteger:score + [[loginUser[0] objectForKey:@"score"] integerValue]]forKey:@"score"];
    // Set the item to be complete (we need a mutable copy)
    NSMutableDictionary *mutable = [loginUser[0] mutableCopy];
    
    // Update the item in the TodoItem table and remove from the items array on completion
    [self.userTable update:mutable completion:^(NSDictionary *item, NSError *error) {
        [self logErrorIfNotNil:error];
        
        NSUInteger index = [loginUser indexOfObjectIdenticalTo:mutable];
        if (index != NSNotFound)
        {
            [mutableItems removeObjectAtIndex:index];
        }
        
        // Let the caller know that we have finished
        completion();
    }];
}

- (void) getSasUrlForNewBlob:(NSString *)blobName
                forContainer:(NSString *)containerName
              withCompletion:(CompletionWithSasBlock) completion
{
    NSDictionary *item = @{  };
    NSDictionary *params = @{ @"containerName" : containerName, @"blobName" : blobName };
    
    [self.blobsTable insert:item parameters:params completion:^(NSDictionary *item, NSError *error) {
        completion([item objectForKey:@"sasUrl"]);
    }];
}

- (void)addFilmDiary:(NSDictionary *)item
          completion:(CompletionBlock)completion
{
    // Insert the item into the TodoItem table and add to the items array on completion
    [self.diaryTable insert:item completion:^(NSDictionary *result, NSError *error)
     {
         [self logErrorIfNotNil:error];
         // Let the caller know that we finished
         completion();
     }];
}

- (void)removeFilmDiary:(NSDictionary *)item
          completion:(CompletionBlock)completion
{
    // Insert the item into the TodoItem table and add to the items array on completion
    [self.diaryTable delete:item completion:^(NSNumber *itemId, NSError *error)
     {
         [self logErrorIfNotNil:error];
         // Let the caller know that we finished
         completion();
     }];
}

- (void)refreshFilmDiaryForID:(NSInteger)filmDiaryID
                   completion:(CompletionBlock)completion
{
    NSString *queryString = [[NSString alloc] initWithFormat:@"id == %d", filmDiaryID];
    
    // Create a predicate that finds items where complete is false
    NSPredicate * predicate = [NSPredicate predicateWithFormat:queryString];
    
    
    // Query the TodoItem table and update the items property with the results from the service
    [self.diaryTable readWithPredicate:predicate completion:^(NSArray *results, NSInteger totalCount, NSError *error)
     {
         [self logErrorIfNotNil:error];
         if (results.count > 0)
         {
             filmDiary = [results mutableCopy][0];
             diaryid = [[filmDiary objectForKey:@"id"] integerValue];         // Let the caller know that we finished
         }
         else
         {
             filmDiary = nil;
             diaryid = -1;
         }
         completion();
     }];

}

- (void)submitFilmDiaryScore:(NSInteger)score
                       completion:(CompletionBlock)completion
{
    NSMutableDictionary *mutable = [filmDiary mutableCopy];
    NSInteger currentViewCount = [[filmDiary objectForKey:@"diaryViewCount"] integerValue];
    [mutable setObject:[NSNumber numberWithInteger:1 + currentViewCount]forKey:@"diaryViewCount"];
    if (currentViewCount == 8)
    {
        [mutable setObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:@"diaryFirstWatchListedTime"];
    }
    
    if (score != 0)
    {
        [mutable setObject:[NSNumber numberWithInteger:score + [[filmDiary objectForKey:@"diaryScore"] integerValue]] forKey:@"diaryScore"];
    }
    [self.diaryTable update:mutable completion:^(NSDictionary *item, NSError *error) {
        filmDiary = [item mutableCopy];
    }];
    
    completion();

}

- (void)submitFilmDiaryUserScore:(NSDictionary *)item
                      completion:(CompletionBlock)completion
{
    // Insert the item into the TodoItem table and add to the items array on completion
    [self.scoreTable insert:item completion:^(NSDictionary *result, NSError *error)
     {
         [self logErrorIfNotNil:error];
         // Let the caller know that we finished
         completion();
     }];
}

- (void)addComment:(NSDictionary *)item
          completion:(CompletionBlock)completion
{
    // Insert the item into the TodoItem table and add to the items array on completion
    [self.commentTable insert:item completion:^(NSDictionary *result, NSError *error)
     {
         [self logErrorIfNotNil:error];
         // Let the caller know that we finished
         completion();
     }];
}


- (void)loadCommentsForUser:(NSInteger)userID
                 completion:(CompletionBlock)completion
{
    NSString *queryString = [[NSString alloc] initWithFormat:@"userID == %d", userID];
    
    // Create a predicate that finds items where complete is false
    NSPredicate * predicate = [NSPredicate predicateWithFormat:queryString];
    
    
    // Query the TodoItem table and update the items property with the results from the service
    [self.commentTable readWithPredicate:predicate completion:^(NSArray *results, NSInteger totalCount, NSError *error)
     {
         [self logErrorIfNotNil:error];
         diaryComments = [results mutableCopy];
         completion();
     }];
}

- (void)loadCommentsForDiary:(NSInteger)diaryID
                  completion:(CompletionBlock)completion
{
    NSString *queryString = [[NSString alloc] initWithFormat:@"diaryID == %d", diaryID];
    
    // Create a predicate that finds items where complete is false
    NSPredicate * predicate = [NSPredicate predicateWithFormat:queryString];
    
    
    // Query the TodoItem table and update the items property with the results from the service
    [self.commentTable readWithPredicate:predicate completion:^(NSArray *results, NSInteger totalCount, NSError *error)
     {
         [self logErrorIfNotNil:error];
         diaryComments = [results mutableCopy];
         completion();
     }];
}

- (void)loadFilmDiaryForUser:(NSInteger)userID
                  completion:(CompletionBlock)completion
{
    NSString *queryString = [[NSString alloc] initWithFormat:@"userID == %d", userID];
    
    // Create a predicate that finds items where complete is false
    NSPredicate * predicate = [NSPredicate predicateWithFormat:queryString];
    
    
    // Query the TodoItem table and update the items property with the results from the service
    [self.diaryTable readWithPredicate:predicate completion:^(NSArray *results, NSInteger totalCount, NSError *error)
     {
         [self logErrorIfNotNil:error];
         filmDiaries = [results mutableCopy];
         // Let the caller know that we finished
         completion();
     }];
}

- (void)loadRandom9PicsForRate:(NSInteger)userID
                  completion:(CompletionBlock)completion
{
    NSString *queryString = [[NSString alloc] initWithFormat:@"userID != %d AND diaryViewCount < 9", userID];
    
    // Create a predicate that finds items where complete is false
    NSPredicate * predicate = [NSPredicate predicateWithFormat:queryString];
    
    
    // Query the TodoItem table and update the items property with the results from the service
    [self.diaryTable readWithPredicate:predicate completion:^(NSArray *results, NSInteger totalCount, NSError *error)
     {
         [self logErrorIfNotNil:error];
         ratingFilmDiaries = [results mutableCopy];
         // Let the caller know that we finished
         completion();
     }];
}


- (void)loadRankingForProvince:(NSInteger)provinceID
                    completion:(CompletionBlock)completion
{
    NSDate *currentDate = [NSDate date];
    double timeSinceToday = [[NSDate date] timeIntervalSinceDate:currentDate];
    
    NSString *queryString;
    if (timeSinceToday >= SECONDS_SINCE_A_DAY_TO_9PM)
    {
        queryString = [[NSString alloc] initWithFormat:@"provinceID == %d AND diaryViewCount > 0 AND diaryScore > 0 AND (diaryFirstWatchListedTime < %f AND diaryFirstWatchListedTime > %f)", provinceID, [currentDate timeIntervalSince1970] - timeSinceToday + SECONDS_SINCE_A_DAY_TO_9PM - SECONDS_IN_A_DAY, [currentDate timeIntervalSince1970] - timeSinceToday + SECONDS_SINCE_A_DAY_TO_9PM - SECONDS_IN_A_DAY * (RANKING_VALID_DURATION + 1)];
    }
    else
    {
        queryString = [[NSString alloc] initWithFormat:@"provinceID == %d AND diaryViewCount > 0 AND diaryScore > 0 AND (diaryFirstWatchListedTime < %f AND diaryFirstWatchListedTime > %f)", provinceID, [currentDate timeIntervalSince1970] - timeSinceToday + SECONDS_SINCE_A_DAY_TO_9PM - SECONDS_IN_A_DAY * 2, [currentDate timeIntervalSince1970] - timeSinceToday + SECONDS_SINCE_A_DAY_TO_9PM - SECONDS_IN_A_DAY * (RANKING_VALID_DURATION + 2)];
    }
    
    
    // Create a predicate that finds items where complete is false
    NSPredicate * predicate = [NSPredicate predicateWithFormat:queryString];
    
    
    // Query the TodoItem table and update the items property with the results from the service
    [self.diaryTable readWithPredicate:predicate completion:^(NSArray *results, NSInteger totalCount, NSError *error)
     {
         [self logErrorIfNotNil:error];
         rankingFilmDiaries = [results mutableCopy];
         // Let the caller know that we finished
         completion();
     }];
}

- (void)loadRankingForGlobal:(CompletionBlock)completion
{
    NSDate *currentDate = [NSDate date];
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date]];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    

    double timeSinceToday = hour * 3600 + minute * 60 + second;
    
    NSString *queryString;
    if (timeSinceToday >= SECONDS_SINCE_A_DAY_TO_9PM)
    {
        queryString = [[NSString alloc] initWithFormat:@"diaryViewCount == 9 AND diaryScore > 0 AND (diaryFirstWatchListedTime < %f AND diaryFirstWatchListedTime > %f)", [currentDate timeIntervalSince1970] - timeSinceToday + SECONDS_SINCE_A_DAY_TO_9PM, [currentDate timeIntervalSince1970] - timeSinceToday + SECONDS_SINCE_A_DAY_TO_9PM - SECONDS_IN_A_DAY * 5];
    }
    else
    {
        queryString = [[NSString alloc] initWithFormat:@"diaryViewCount == 9 AND diaryScore > 0 AND (diaryFirstWatchListedTime < %f AND diaryFirstWatchListedTime > %f)", [currentDate timeIntervalSince1970] - timeSinceToday + SECONDS_SINCE_A_DAY_TO_9PM - SECONDS_IN_A_DAY, [currentDate timeIntervalSince1970] - timeSinceToday + SECONDS_SINCE_A_DAY_TO_9PM - SECONDS_IN_A_DAY * 6];
    }    
    
    // Create a predicate that finds items where complete is false
    NSPredicate * predicate = [NSPredicate predicateWithFormat:queryString];    
    
    // Query the TodoItem table and update the items property with the results from the service
    [self.diaryTable readWithPredicate:predicate completion:^(NSArray *results, NSInteger totalCount, NSError *error)
     {
         [self logErrorIfNotNil:error];
         rankingFilmDiaries = [results mutableCopy];
         // Let the caller know that we finished
         completion();
     }];
}

- (void)favDiary:(NSDictionary *)item
      completion:(CompletionBlock)completion
{
    // Insert the item into the TodoItem table and add to the items array on completion
    [self.favTable insert:item completion:^(NSDictionary *result, NSError *error)
     {
         [self logErrorIfNotNil:error];
         // Let the caller know that we finished
         self.favDiary = result;
         completion();
     }];
}

- (void)unFavDiary:(NSDictionary *)item
      completion:(CompletionBlock)completion
{
    // Delete the item from the TodoItem table and add to the items array on completion
    
    [self.favTable delete:item completion:^(NSNumber *itemId, NSError *error) {
        [self logErrorIfNotNil:error];
        completion();
    }];
}

- (void)reportSpam:(NSDictionary *)item
        completion:(CompletionBlock)completion
{
    
    // Insert the item into the TodoItem table and add to the items array on completion
    [self.spamsTable insert:item completion:^(NSDictionary *result, NSError *error)
     {
         [self logErrorIfNotNil:error];
         // Let the caller know that we finished
         completion();
     }];
}

- (void)loadfavStatus:(NSInteger)diaryID
              userID:(NSInteger)userID
          completion:(CompletionBlock)completion
{
    NSString *queryString = [[NSString alloc] initWithFormat:@"userID == %d AND diaryID == %d", userID, diaryID];
    
    // Create a predicate that finds items where complete is false
    NSPredicate * predicate = [NSPredicate predicateWithFormat:queryString];    
    
    // Query the TodoItem table and update the items property with the results from the service
    [self.favTable readWithPredicate:predicate completion:^(NSArray *results, NSInteger totalCount, NSError *error)
     {
         favDiary = nil;
         if (results.count > 0)
         {
             favDiary = [results mutableCopy][0];
         }
         [self logErrorIfNotNil:error];
         // Let the caller know that we finished
         completion();
     }];
}

- (void)loadFavDiariesForUser:(NSInteger)userID
                   completion:(CompletionBlock)completion
{
    NSString *queryString = [[NSString alloc] initWithFormat:@"userID == %d", userID];
    
    // Create a predicate that finds items where complete is false
    NSPredicate * predicate = [NSPredicate predicateWithFormat:queryString];
    
    // Query the TodoItem table and update the items property with the results from the service
    [self.favTable readWithPredicate:predicate completion:^(NSArray *results, NSInteger totalCount, NSError *error)
     {
         favDiaries = nil;
         favDiaries = [[NSMutableArray alloc] initWithCapacity:results.count];
         if (results.count == 0)
         {
             completion();
         }
         else
         {
             __block NSInteger index = 0;
             for (int i = 0; i < results.count; i++)
             {
                 [self refreshFilmDiaryForID:[[results[i] objectForKey:@"diaryID"] integerValue] completion:^{
                     index = index + 1;
                     if (filmDiary != nil)
                     {
                         [favDiaries addObject:filmDiary];
                     }
                     if (index == results.count)
                     {
                         [self logErrorIfNotNil:error];
                         // Let the caller know that we finished
                         completion();
                     }
                 }];
             }
         }
     }];
}

- (void)loadDiaryScoreFromUser:(NSInteger)userID
                              :(NSInteger)diaryID
                    completion:(CompletionWithResultsBlock)completion
{
    NSString *queryString = [[NSString alloc] initWithFormat:@"userID == %d AND filmID == %d", userID, diaryID];
    
    // Create a predicate that finds items where complete is false
    NSPredicate * predicate = [NSPredicate predicateWithFormat:queryString];
    
    // Query the TodoItem table and update the items property with the results from the service
    [self.scoreTable readWithPredicate:predicate completion:^(NSArray *results, NSInteger totalCount, NSError *error)
     {
         [self logErrorIfNotNil:error];
         diaryScoreFromUser = [results mutableCopy];
         // Let the caller know that we finished
         completion(results);
     }];
}

@end
