//
//  ILChoreography.m
//  Activity
//
//  Created by ∞ on 02/10/11.
//  Copyright (c) 2011 Emanuele Vulcano (Infinite Labs). All rights reserved.
//

#import "ILChoreography.h"

#if TARGET_OS_IPHONE

@implementation ILChoreography {
    NSMutableArray* animationBlocks, * completionBlocks, * preparationBlocks;
}

- (id)init;
{
    self = [super init];
    if (self) {
        animationBlocks = [NSMutableArray new];
        completionBlocks = [NSMutableArray new];
        preparationBlocks = [NSMutableArray new];
    }
    
    return self;
}

- (void)dealloc;
{
    [animationBlocks release];
    [completionBlocks release];
    [preparationBlocks release];
    [super dealloc];
}

- (void) addAnimationWithBlocksForPreparing:(void(^)()) preparation animating:(void(^)()) animations completing:(void(^)(BOOL)) completion;
{
    if (animations)
        [animationBlocks addObject:[[animations copy] autorelease]];
    
    if (completion)
        [completionBlocks addObject:[[completion copy] autorelease]];
    
    if (preparation)
        [preparationBlocks addObject:[[preparation copy] autorelease]];
}

- (void)main;
{
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
        [self invokeAnimationBlocks];
    } completion:^(BOOL finished) {
        [self invokeCompletionBlocksWithResult:finished];
        [self end];
    }];
}

- (void)cancel;
{ /* This method intentionally left blank */ }

- (void) invokePreparationBlocks; // in an arbitrary order
{
    for (void (^block)() in preparationBlocks)
        block();
}

- (void) invokeAnimationBlocks; // in an arbitrary order
{
    for (void (^block)() in animationBlocks)
        block();
}

- (void)invokeCompletionBlocksWithResult:(BOOL)finished;
{
    for (void (^block)(BOOL) in completionBlocks)
        block(finished);
}

- (void)end;
{
    [animationBlocks removeAllObjects];
    [completionBlocks removeAllObjects];
    [preparationBlocks removeAllObjects];
}

@end

#endif

