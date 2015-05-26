//
//  FBLProspectsStore.h
//  FeedbackLoop
//
//  Created by Shane Rogers on 5/25/15.
//  Copyright (c) 2015 FBL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBLProspectsStore : NSObject

+ (FBLProspectsStore *)sharedStore;

- (void)createProspectForEmail:(NSString *)email withCompletionBlock:(void (^)(NSError *err))block;

@end
