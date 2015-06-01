//
//  LCUserFeedbackThread_Internal.h
//  Feedback
//
//  Created by Feng Junwen on 5/18/15.
//  Copyright (c) 2015 LeanCloud. All rights reserved.
//

#ifndef AVOS_AVUserFeedback_Internal_h
#define AVOS_AVUserFeedback_Internal_h
#import "LCUserFeedbackThread.h"

@interface LCUserFeedbackThread()
+(void)feedbackWithContent:(NSString *)content
                   contact:(NSString *)contact
                    create:(BOOL)create
                 withBlock:(AVIdResultBlock)block;
@end

#endif
