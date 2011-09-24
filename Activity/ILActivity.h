//
//  ILActivity.h
//  Activity
//
//  Created by ∞ on 23/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ILActivity : NSObject

// --- Methods clients call -----------------------
- (void) start; // Can be called multiple times, will work only once.
- (void) cancel; // You MUST override this to perform cancelling word. Default calls -end.

// --- KVO-able state information. ----------------

// YES if this activity was ever started.
@property(readonly, nonatomic, getter = isStarted) BOOL started;

// YES if this activity finished (-end was called).
@property(readonly, nonatomic, getter = isFinished) BOOL finished;

// --- Methods to override in subclasses ----------
- (void) performActivity; // must start doing the activity, then call -end sometime in the future (not necessarily as it's called) to end it.

@property(readonly, nonatomic, getter = isPerformedWhileInBackground) BOOL performedWhileInBackground;
// if YES, marks the application as busy to the OS while the activity is performed.
// On iOS, this makes the app run in the background for completion. If the activity runs too long, it's cancelled via -cancel.
// On Mac OS X, prevents sudden termination (10.6) and autoquit (10.7) as long as the activity is performed.
// Value is read when the activity starts.

// --- Methods subclasses call --------------------
- (void) end;

@end
