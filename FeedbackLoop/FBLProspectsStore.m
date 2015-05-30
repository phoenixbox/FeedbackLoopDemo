//
//  FBLProspectsStore.m
//  FeedbackLoop
//
//  Created by Shane Rogers on 5/25/15.
//  Copyright (c) 2015 FBL. All rights reserved.
//

#import "FBLProspectsStore.h"

// Libs
#import "AFNetworking.h"
#import "AppConstants.h"

@implementation FBLProspectsStore

+ (FBLProspectsStore *)sharedStore {
    static FBLProspectsStore *prospectStore = nil;

    static dispatch_once_t oncePredicate;

    dispatch_once(&oncePredicate, ^{
        prospectStore = [[FBLProspectsStore alloc] init];
    });

    return prospectStore;
}

- (void)createProspectForEmail:(NSString *)email withCompletionBlock:(void (^)(NSError *err))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSString *BASE = PROD_BASE_URL;
    // Reassign for local development
#ifdef DEBUG
    BASE = DEV_BASE_URL;
#endif

    NSString *requestUrl = [BASE stringByAppendingString:PROSPECTS_ENDPOINT];
    NSDictionary *prospectParams = @{@"prospect":
                                            @{
                                             @"email": email
                                            }
                                     };

    [manager POST:requestUrl parameters:prospectParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(error);
    }];
}

@end

