//
//  ILActionSheetController.m
//  Activity
//
//  Created by ∞ on 24/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//


#if TARGET_OS_IPHONE

#import "ILActionSheetController.h"

@implementation ILActionSheetController {
    NSMutableDictionary* handlerBlocks;
}

@synthesize actionSheet;

- (id)init;
{
    self = [super init];
    if (self) {
        handlerBlocks = [NSMutableDictionary new];
        self.actionSheet = [[UIActionSheet new] autorelease];
    }
    return self;
}

- (void)dealloc;
{
    self.actionSheet = nil;
    [handlerBlocks release];
    [super dealloc];
}

- (void)setActionSheet:(UIActionSheet *) av;
{
    if (av != actionSheet) {
        if (actionSheet.delegate == self)
            actionSheet.delegate = nil;
        
        [actionSheet release];
        actionSheet = [av retain];
        
        actionSheet.delegate = self;
    }
}

- (void) setHandlerForButtonAtIndex:(NSInteger) i withBlock:(void(^)()) block;
{
    NSNumber* key = [NSNumber numberWithInteger:i];
    [handlerBlocks setObject:[block copy] forKey:key];
}

- (NSInteger) addButtonWithTitle:(NSString*) title block:(void(^)()) block;
{
    NSInteger buttonIndex = [self.actionSheet addButtonWithTitle:title];
    [self setHandlerForButtonAtIndex:buttonIndex withBlock:block];
    return buttonIndex;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    NSNumber* key = [NSNumber numberWithInteger:buttonIndex];
    void (^block)() = [handlerBlocks objectForKey:key];
    
    if (block)
        block();
}

@end

#endif
