//
//  ILActionSheetController.h
//  Activity
//
//  Created by ∞ on 24/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>

@interface ILActionSheetController : NSObject <UIActionSheetDelegate>

@property(retain, nonatomic) UIActionSheet* actionSheet;

- (void) setHandlerForButtonAtIndex:(NSInteger) i withBlock:(void(^)()) block;

- (NSInteger) addButtonWithTitle:(NSString*) title block:(void(^)()) block;

@end

#endif