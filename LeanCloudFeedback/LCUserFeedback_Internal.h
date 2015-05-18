//
//  AVUserFeedback_Internal.h
//  AVOS
//
//  Created by Qihe Bian on 11/3/14.
//
//

#ifndef AVOS_AVUserFeedback_Internal_h
#define AVOS_AVUserFeedback_Internal_h
#import "LCUserFeedback.h"

@interface LCUserFeedback()
+(void)feedbackWithContent:(NSString *)content
                   contact:(NSString *)contact
                    create:(BOOL)create
                 withBlock:(AVIdResultBlock)block;
@end

#endif
