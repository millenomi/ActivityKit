//
//  ILActivity+Private.h
//  Activity
//
//  Created by ∞ on 23/09/11.
//  Copyright (c) 2011 Emanuele Vulcano (Infinite Labs). All rights reserved.
//

#import "ILActivity.h"
@class ILActivitiesSet;

@interface ILActivity ()

@property(assign, nonatomic) ILActivitiesSet* activitiesSet;
- (void) performActivity;

@end