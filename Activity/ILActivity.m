//
//  ILActivity.m
//  Activity
//
//  Created by ∞ on 23/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ILActivity.h"
#import "ILActivitiesSet.h"

#import "ILActivity+Private.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

@interface ILActivity ()

@property(nonatomic, getter = isStarted) BOOL started;
@property(nonatomic, getter = isFinished) BOOL finished;

// for Mac OS X 10.7+
@property(copy, nonatomic) NSString* automaticTerminationReason;

@end

@implementation ILActivity {
    BOOL runningBackgrounded;
    
#if TARGET_OS_IPHONE
    UIBackgroundTaskIdentifier taskIdentifier;
#endif    
    
}

@synthesize started, finished, activitiesSet;
@synthesize performedWhileInBackground;
@synthesize automaticTerminationReason;

- (void)dealloc;
{
    if (self.started && !self.finished)
        [self cancel];
    
    self.automaticTerminationReason = nil;
    [super dealloc];
}

- (void)start;
{
    [[ILActivitiesSet sharedSet] addActivity:self]; // this calls -performActivity later.
}

- (void)setActivitiesSet:(ILActivitiesSet *) a;
{
    if (activitiesSet != a) {
        if (activitiesSet)
            self.started = YES;
        
        activitiesSet = a;
    }
}

- (void)cancel;
{
    [self end];
}

- (void)performActivity;
{
    if (self.performedWhileInBackground) {
        runningBackgrounded = YES;
        
#if TARGET_OS_IPHONE
        taskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self cancel];
            });
        }];
#else
        self.automaticTerminationReason = self.description;
        NSProcessInfo* info = [NSProcessInfo processInfo];
        
        if ([info respondsToSelector:@selector(disableAutomaticTermination:)])
            [info disableAutomaticTermination:self.automaticTerminationReason];
        
        [info disableSuddenTermination];
        
#endif
        
    }

    [self main];
}

- (void)main;
{
    // Does nothing by default
}

- (void)end;
{
    if (!self.finished) {
        
        if (runningBackgrounded) {
#if TARGET_OS_IPHONE
            [[UIApplication sharedApplication] endBackgroundTask:taskIdentifier];
#else
            NSProcessInfo* info = [NSProcessInfo processInfo];
            
            if (self.automaticTerminationReason && [info respondsToSelector:@selector(enableAutomaticTermination:)])
                [info enableAutomaticTermination:self.automaticTerminationReason];
            
            [info enableSuddenTermination];
            
            self.automaticTerminationReason = nil;
#endif
        }
        
        self.finished = YES;
    }
}

@end
