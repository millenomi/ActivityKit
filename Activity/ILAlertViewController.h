//
//  ILAlertViewController.h
//  Activity
//
//  Created by ∞ on 24/09/11.
//  Copyright (c) 2011 Emanuele Vulcano (Infinite Labs). All rights reserved.
//

#import <Foundation/Foundation.h>


#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>

@interface ILAlertViewController : NSObject <UIAlertViewDelegate>

@property(retain, nonatomic) UIAlertView* alertView;
- (void) show;

- (void) setHandlerForButtonAtIndex:(NSInteger) i withBlock:(void(^)()) block;

- (NSInteger) addButtonWithTitle:(NSString*) title block:(void(^)()) block;

@end

#endif