//
//  ILChoreography.h
//  Activity
//
//  Created by ∞ on 02/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#if TARGET_OS_IPHONE

#import "ILActivity.h"
#import <UIKit/UIKit.h>

/* Choreographies are activities that handle a single- or multi-step UIKit animation. When started, they execute all animation and completion blocks in a UIView animation block.
 
   Since animation is complex, subclasses can override the -main method to set up the animation themselves. Subclasses can then use the -invokePreparationBlocks, -invokeAnimationBlocks and -invokeCompletionBlocksWithResult: methods to invoke any added animation or completion blocks. You can also perform multiple, chained or parallel animations. No matter what you do, it's this method's responsibility to call -end after all blocks have been invoked.
 
   The default implementation runs animation blocks with the following settings: a duration of 0.25; ease-in-out easing; default options otherwise. The default implementation invokes completion blocks and calls -end when this animation ends.
 
   Choreographies may be cancelled like any other activity. However, the default implementation does NOT stop animations right away, as it overrides -cancel to do nothing. To implement cancelling in a subclass, override -cancel entirely without calling super.
 */
@interface ILChoreography : ILActivity

// All preparation blocks are invoked as the choreography begins, outside of an animation block.
// All animation blocks are invoked within the UIView animation context.
// All completion blocks are invoked as part of the UIView animation completion block, just before the activity ends.
// Any of the three arguments can be nil.
- (void) addAnimationWithBlocksForPreparing:(void(^)()) preparation animating:(void(^)()) animations completing:(void(^)(BOOL finished)) completion;

// Of interest to subclasses.
- (void) cancel; // overridden to do nothing. overridable.
- (void) invokeAnimationBlocks; // in addition order
- (void) invokePreparationBlocks; // in addition order
- (void) invokeCompletionBlocksWithResult:(BOOL) finished; // in addition order

@end

#endif
