//
//  AzureInterface.h
//  FilmDiary
//
//  Created by Yingjia Liu on 7/27/13.
//  Copyright (c) 2013 Yingjia Liu. All rights reserved.
//

#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import <Foundation/Foundation.h>

#pragma mark * Block Definitions


#define SECONDS_SINCE_A_DAY_TO_9PM 75600.f
#define SECONDS_IN_A_DAY 86400.f
#define RANKING_VALID_DURATION 1

@interface AzureUserInterface : NSObject

typedef void (^CompletionBlock) ();
typedef void (^CompletionWithSasBlock) (NSString *sasUrl);
typedef void (^CompletionWithResultsBlock) (NSArray *results);

#pragma mark * AzureInterface public interface


@property (nonatomic, strong)   MSClient *client;
@property (nonatomic, retain)   NSArray *loginUser;
@property (nonatomic, retain)   NSArray *filmDiaries;
@property (nonatomic, retain)   NSArray *rankingFilmDiaries;
@property (nonatomic, retain)   NSArray *ratingFilmDiaries;
@property (nonatomic, retain)   NSMutableArray *favDiaries;
@property (nonatomic, retain)   NSArray *diaryComments;
@property (nonatomic, retain)   NSDictionary *filmDiary;
@property (nonatomic, retain)   NSDictionary *favDiary;
@property (nonatomic, retain)   NSString *username;
@property (nonatomic, assign)   NSInteger userid;
@property (nonatomic, assign)   NSInteger provinceid;
@property (nonatomic, assign)   NSInteger diaryid;
@property (nonatomic, retain)   NSArray *diaryScoreFromUser;
@property (nonatomic, retain)   NSDictionary *FriendProfile;

+ (AzureUserInterface *)defaultService;

-(AzureUserInterface *)init;

- (void)logErrorIfNotNil:(NSError *) error;

- (void)addUser:(NSDictionary *)item
     completion:(CompletionBlock)completion;

- (void)loginUser:(NSDictionary *)item
     completion:(CompletionBlock)completion;

- (void)loadProfileForID:(NSInteger)userID
       completion:(CompletionBlock)completion;

- (void)refreshUser:(NSString *)usernamestring
         completion:(CompletionWithResultsBlock)completion;

- (void)handleRequest:(NSURLRequest *)request
                 next:(MSFilterNextBlock)next
             response:(MSFilterResponseBlock)response;

- (void)updateUserLocation:(NSInteger)loc
               completion:(CompletionBlock)completion;

- (void)updateUserProfilePic:(NSString *)profilePic
                 completion:(CompletionBlock)completion;

- (void)updateUserEmail:(NSString *)profilePic
            completion:(CompletionBlock)completion;

- (void)updateUserDescription:(NSString *)description
                  completion:(CompletionBlock)completion;

- (void)updateUserScore:(NSInteger)score
            completion:(CompletionBlock)completion;

- (void)updateFriendUserRedeem:(NSDictionary *)friendDiary
             completion:(CompletionBlock)completion;

- (void)updateUserRedeem:(NSDictionary *)userDiary
             completion:(CompletionBlock)completion;

- (void) getSasUrlForNewBlob:(NSString *)blobName
                forContainer:(NSString *)containerName withCompletion:(CompletionWithSasBlock) completion;

- (void)addFilmDiary:(NSDictionary *)item
          completion:(CompletionBlock)completion;

- (void)removeFilmDiary:(NSDictionary *)item
          completion:(CompletionBlock)completion;

- (void)refreshFilmDiaryForID:(NSInteger)filmDiaryID
                   completion:(CompletionBlock)completion;

- (void)submitFilmDiaryScore:(NSInteger)score
                   completion:(CompletionBlock)completion;

- (void)submitFilmDiaryUserScore:(NSDictionary *)item
                  completion:(CompletionBlock)completion;

- (void)loadFilmDiaryForUser:(NSInteger)userID
                  completion:(CompletionBlock)completion;

- (void)loadRandom9PicsForRate:(NSInteger)userID
                    completion:(CompletionBlock)completion;

- (void)loadRankingForProvince:(NSInteger)provinceID
                    completion:(CompletionBlock)completion;

- (void)loadRankingForGlobal:(CompletionBlock)completion;

- (void)addComment:(NSDictionary *)item
        completion:(CompletionBlock)completion;

- (void)loadCommentsForUser:(NSInteger)userID
        completion:(CompletionBlock)completion;

- (void)loadCommentsForDiary:(NSInteger)diaryID
        completion:(CompletionBlock)completion;

- (void)favDiary:(NSDictionary *)item
        completion:(CompletionBlock)completion;

- (void)unFavDiary:(NSDictionary *)item
      completion:(CompletionBlock)completion;

- (void)reportSpam:(NSDictionary *)item
        completion:(CompletionBlock)completion;

- (void)loadfavStatus:(NSInteger)diaryID
              userID:(NSInteger)userID
          completion:(CompletionBlock)completion;

- (void)loadFavDiariesForUser:(NSInteger)userID
        completion:(CompletionBlock)completion;

- (void)loadDiaryScoreFromUser:(NSInteger)userID
                              :(NSInteger)diaryID
                   completion:(CompletionWithResultsBlock)completion;
@end
