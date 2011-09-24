//
//  ILActivitiesSet.h
//  Activity
//
//  Created by ∞ on 23/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ILActivity.h"

@protocol ILActivitiesQuery <NSObject>

// Can be observed via KVO
@property(readonly, nonatomic) NSSet* activities;

@end

@interface ILActivitiesSet : NSObject

+ (id) sharedSet;

- (void) addActivity:(ILActivity*) activity;
@property(readonly, nonatomic) NSSet* activities;

- (id <ILActivitiesQuery>) queryForActivitiesOfClass:(Class) c;
- (id <ILActivitiesQuery>) queryForActivitiesConformingToProtocol:(Protocol*) p;
- (id <ILActivitiesQuery>) queryForActivitiesMatchingBlock:(BOOL(^)(ILActivity*)) block;

@end
