//
//  ILAlertViewController.m
//  Activity
//
//  Created by ∞ on 24/09/11.
//  Copyright (c) 2011 Emanuele Vulcano (Infinite Labs). All rights reserved.
//

#if TARGET_OS_IPHONE

#import "ILAlertViewController.h"

@implementation ILAlertViewController {
    NSMutableDictionary* handlerBlocks;
}

@synthesize alertView;

- (id)init;
{
    self = [super init];
    if (self) {
        handlerBlocks = [NSMutableDictionary new];
        self.alertView = [[UIAlertView new] autorelease];
    }
    return self;
}

- (void)dealloc;
{
    self.alertView = nil;
    [handlerBlocks release];
    [super dealloc];
}

- (void)setAlertView:(UIAlertView *) av;
{
    if (av != alertView) {
        if (alertView.delegate == self)
            alertView.delegate = nil;
        
        [alertView release];
        alertView = [av retain];
        
        alertView.delegate = self;
    }
}

- (void) setHandlerForButtonAtIndex:(NSInteger) i withBlock:(void(^)()) block;
{
    NSNumber* key = [NSNumber numberWithInteger:i];
    [handlerBlocks setObject:[[block copy] autorelease] forKey:key];
}

- (NSInteger) addButtonWithTitle:(NSString*) title block:(void(^)()) block;
{
    NSInteger buttonIndex = [self.alertView addButtonWithTitle:title];
    [self setHandlerForButtonAtIndex:buttonIndex withBlock:block];
    return buttonIndex;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    NSNumber* key = [NSNumber numberWithInteger:buttonIndex];
    void (^block)() = [handlerBlocks objectForKey:key];
    
    if (block)
        block();
    
    [self autorelease];
}

- (void) show;
{
    [self retain];
    [self.alertView show];
}

@end

#endif
