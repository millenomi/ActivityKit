//
//  ILActivitiesSet.m
//  Activity
//
//  Created by ∞ on 23/09/11.
//  Copyright (c) 2011 Emanuele Vulcano (Infinite Labs). All rights reserved.
//

#import "ILActivitiesSet.h"
#import "ILActivity+Private.h"

NSString* const kILActivitiesSetDidAddActivity = @"ILActivitiesSetDidAddActivity";
NSString* const kILActivitiesSetDidRemoveActivity = @"ILActivitiesSetDidRemoveActivity";

NSString* const kILActivitiesSetActivityKey = @"ILActivitiesSetActivityKey";

@interface ILActivitiesSet ()
- (void) removeActivity:(ILActivity*) activity;
@end

@interface ILActivitiesMatchingBlockQuery : NSObject <ILActivitiesQuery>
- (id) initWithMatchingBlock:(BOOL(^)(ILActivity*)) block set:(ILActivitiesSet*) activitiesSet;
@end

// ---------------------------------

@implementation ILActivitiesMatchingBlockQuery {
    BOOL (^matchingBlock)(ILActivity*);
    NSMutableSet* activities;
}

- (id)initWithMatchingBlock:(BOOL (^)(ILActivity *))block set:(ILActivitiesSet *)activitiesSet;
{
    self = [super init];
    if (self) {
        NSMutableSet* filtered = [NSMutableSet setWithCapacity:activitiesSet.activities.count];
        for (ILActivity* a in activitiesSet.activities) {
            if (block(a))
                [filtered addObject:a];
        }
        
        matchingBlock = [block copy];
        activities = [filtered retain];
        
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(didAddActivity:) name:kILActivitiesSetDidAddActivity object:activitiesSet];
        [nc addObserver:self selector:@selector(didRemoveActivity:) name:kILActivitiesSetDidRemoveActivity object:activitiesSet];
    }
    
    return self;
}

- (void)dealloc;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [matchingBlock release];
    [activities release];
    [super dealloc];
}

- (NSSet *)activities;
{
    return activities;
}

- (void) didAddActivity:(NSNotification*) n;
{
    ILActivity* a = [[n userInfo] objectForKey:kILActivitiesSetActivityKey];
    
    if (matchingBlock(a))
        [[self mutableSetValueForKey:@"activities"] addObject:a];
}

- (void) didRemoveActivity:(NSNotification*) n;
{
    ILActivity* a = [[n userInfo] objectForKey:kILActivitiesSetActivityKey];
    
    [[self mutableSetValueForKey:@"activities"] removeObject:a];
}

@end

// ---------------------------------

@implementation ILActivitiesSet {
    NSMutableSet* activities;
}

+ (id)sharedSet;
{
    static id me;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        me = [self new];
    });
    
    return me;
}

- (id)init;
{
    self = [super init];
    if (self) {
        activities = [NSMutableSet new];
    }
    return self;
}

- (void)dealloc;
{
    for (ILActivity* activity in [[activities copy] autorelease]) {
        [activity cancel];
        [self removeActivity:activity];
    }
    
    [activities release];
    [super dealloc];
}

- (NSSet *)activities;
{
    return activities;
}

- (void)addActivity:(ILActivity *)activity;
{
    NSAssert(!activity.activitiesSet, @"You can't add an activity to two different activities sets.");
    
    if (![activities containsObject:activity]) {
        [self willChangeValueForKey:@"activities" withSetMutation:NSKeyValueUnionSetMutation usingObjects:[NSSet setWithObject:activity]];
        
        [activities addObject:activity];
        activity.activitiesSet = self;
        
        [activity addObserver:self forKeyPath:@"finished" options:0 context:NULL];
        
        [self didChangeValueForKey:@"activities" withSetMutation:NSKeyValueUnionSetMutation usingObjects:[NSSet setWithObject:activity]];
        
        NSDictionary* userInfo = [NSDictionary dictionaryWithObject:activity forKey:kILActivitiesSetActivityKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:kILActivitiesSetDidAddActivity object:self userInfo:userInfo];
        
        [activity performActivity];
    }
    
}

- (void) removeActivity:(ILActivity*) activity;
{
    if ([activities containsObject:activity]) {
        [self willChangeValueForKey:@"activities" withSetMutation:NSKeyValueMinusSetMutation usingObjects:[NSSet setWithObject:activity]];
        
        [[activity retain] autorelease];
        
        if (activity.activitiesSet == self)
            activity.activitiesSet = nil;
        
        [activity removeObserver:self forKeyPath:@"finished"];
        
        [activities removeObject:activity];
        
        [self didChangeValueForKey:@"activities" withSetMutation:NSKeyValueMinusSetMutation usingObjects:[NSSet setWithObject:activity]];
        
        NSDictionary* userInfo = [NSDictionary dictionaryWithObject:activity forKey:kILActivitiesSetActivityKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:kILActivitiesSetDidRemoveActivity object:self userInfo:userInfo];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
    if ([object isFinished])
        [self removeActivity:object];
}

- (id<ILActivitiesQuery>)queryForActivitiesOfClass:(Class)c;
{
    return [self queryForActivitiesMatchingBlock:^BOOL(ILActivity* a) {
        return [a isKindOfClass:c];
    }];
}

- (id<ILActivitiesQuery>)queryForActivitiesConformingToProtocol:(Protocol *)p;
{
    return [self queryForActivitiesMatchingBlock:^BOOL(ILActivity* a) {
        return [a conformsToProtocol:p];
    }];
}

- (id <ILActivitiesQuery>) queryForActivitiesMatchingBlock:(BOOL(^)(ILActivity*)) block;
{
    return [[[ILActivitiesMatchingBlockQuery alloc] initWithMatchingBlock:block set:self] autorelease];
}

@end


@implementation ILActivity (ILSharedActivitiesSetQueries)

+ (id)startedActivity;
{
    return [[self startedActivities] anyObject];
}

+ (NSSet *)startedActivities;
{
    return [[ILActivitiesSet sharedSet] queryForActivitiesOfClass:self].activities;
}

@end
