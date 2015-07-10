//
//  LCUserFeedbackThread.m
//  Feedback
//
//  Created by yang chaozhong on 4/21/14.
//  Copyright (c) 2014 LeanCloud. All rights reserved.
//

#import "LCUserFeedbackThread.h"
#import "LCHttpClient.h"
#import "LCUtils.h"
#import "LCUserFeedbackThread_Internal.h"

static NSString *const kLCUserFeedbackObjectId = @"LCUserFeedbackObjectId";

@interface LCUserFeedbackThread()

@property(nonatomic, retain) NSString *appSign;
@property(nonatomic, retain) NSString *status;
@property(nonatomic, retain) NSString *remarks;
@property(nonatomic, retain) NSString *iid;

@end

@implementation LCUserFeedbackThread

+(NSString *)myObjectPath {
    return @"https://api.leancloud.cn/1.1/feedback";
}

- (instancetype)init {
    if ((self = [super init])) {
        self.iid = [AVInstallation currentInstallation].objectId;
    }
    return self;
}

-(NSMutableDictionary *)postData {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    if (_content) {
        [data setObject:self.content forKey:@"content"];
    }
    
    if (_contact) {
        [data setObject:self.contact forKey:@"contact"];
    }
    
    if (_status) {
        [data setObject:self.status forKey:@"status"];
    }
    
    if (_remarks) {
        [data setObject:self.remarks forKey:@"remarks"];
    }
    _iid = [AVInstallation currentInstallation].objectId;
    if (_iid) {
        [data setObject:self.iid forKey:@"iid"];
    }
    
    return data;
}

-(instancetype)initWithDictionary:(NSDictionary*)dict {
    self = [super init];
    if (self && dict) {
        self.contact = [dict objectForKey:@"contact"];
        self.content = [dict objectForKey:@"content"];
        self.status = [dict objectForKey:@"status"];
        self.iid = [dict objectForKey:@"iid"];
        self.remarks = [dict objectForKey:@"remarks"];
        self.objectId = [dict objectForKey:@"objectId"];
    }
    return self;
}

+(void)fetchFeedbackWithBlock:(LCUserFeedbackBlock)block {
    NSString *feedbackObjectId = [[NSUserDefaults standardUserDefaults] objectForKey:kLCUserFeedbackObjectId];
    if (feedbackObjectId == nil) {
        // do not create empty feedback
        block(nil, nil);
    } else {
        LCHttpClient *client = [LCHttpClient sharedInstance];
        [client getObject:[LCUserFeedbackThread myObjectPath] withParameters:@{@"objectId":feedbackObjectId} block:^(id object, NSError *error) {
            if (error) {
                [LCUtils callIdResultBlock:block object:nil error:error];
            } else {
                NSArray* results = [(NSDictionary*)object objectForKey:@"results"];
                if (results.count == 0) {
                    [LCUtils callIdResultBlock:block object:nil error:nil];
                } else {
                    LCUserFeedbackThread *feedback = [[LCUserFeedbackThread alloc] initWithDictionary:results[0]];
                    [LCUtils callIdResultBlock:block object:feedback error:nil];
                }
            }
        }];
    }
}

+(void)fetchFeedbackWithContact:(NSString*)contact withBlock:(AVIdResultBlock)block {
    LCHttpClient *client = [LCHttpClient sharedInstance];
    [client getObject:[LCUserFeedbackThread myObjectPath] withParameters:[NSDictionary dictionaryWithObject:contact forKey:@"contact"] block:^(id object, NSError *error) {
        if (error) {
            [LCUtils callIdResultBlock:block object:nil error:error];
        } else {
            [LCUtils callIdResultBlock:block object:object error:nil];
        }
    }];
}

+(void)feedbackWithContent:(NSString *)content
                   contact:(NSString *)contact
                    create:(BOOL)create
                 withBlock:(AVIdResultBlock)block {
    if (create) {
        LCUserFeedbackThread *feedback = [[LCUserFeedbackThread alloc] init];
        feedback.content = content;
        feedback.contact = contact;
        
        LCHttpClient *client = [LCHttpClient sharedInstance];
        [client postObject:[LCUserFeedbackThread myObjectPath] withParameters:[feedback postData] block:^(id object, NSError *error) {
            if (!error) {
                feedback.objectId = [(NSDictionary *)object objectForKey:@"objectId"];
                [[NSUserDefaults standardUserDefaults] setObject:feedback.objectId forKey:kLCUserFeedbackObjectId];
                [LCUtils callIdResultBlock:block object:feedback error:error];
            } else {
                [LCUtils callIdResultBlock:block object:nil error:error];
            }
        }];
    } else {
        [LCUtils callIdResultBlock:block object:nil error:[NSError new]];
    }
}

+(void)feedbackWithContent:(NSString *)content
                   contact:(NSString *)contact
                 withBlock:(AVIdResultBlock)block {
    [self feedbackWithContent:content contact:contact create:YES withBlock:block];
}


+(void)updateFeedback:(LCUserFeedbackThread *)feedback withBlock:(AVIdResultBlock)block {
    [[LCHttpClient sharedInstance] putObject:[NSString stringWithFormat:@"%@/%@", [LCUserFeedbackThread myObjectPath], feedback.objectId]
                              withParameters:[feedback postData]
                                       block:^(id object, NSError *error) {
                                           [LCUtils callIdResultBlock:block object:object error:error];
                                       }];
}

+(void)deleteFeedback:(LCUserFeedbackThread *)feedback withBlock:(AVIdResultBlock)block {
    [[LCHttpClient sharedInstance] deleteObject:[NSString stringWithFormat:@"%@/%@", [LCUserFeedbackThread myObjectPath], feedback.objectId]
                                 withParameters:nil
                                          block:^(id object, NSError *error) {
                                              [LCUtils callIdResultBlock:block object:object error:error];
                                          }];
}


@end
