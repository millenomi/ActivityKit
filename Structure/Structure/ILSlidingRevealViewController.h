//
//  ILDrawerController.h
//  DrawerController
//
//  Created by ∞ on 26/09/11.
//  Copyright (c) 2011 Emanuele Vulcano (Infinite Labs). All rights reserved.
//

#import <UIKit/UIKit.h>

@class ILChoreography;

@interface ILSlidingRevealViewController : UIViewController

@property(retain, nonatomic) UIViewController* mainController;
@property(retain, nonatomic) UIViewController* drawerController;

- (void)setDrawerController:(UIViewController *)dc animated:(BOOL) ani;
- (ILChoreography*) choreographyForChangingDrawerController:(UIViewController*) vc;

@end

// If the .mainController of a ILDrawerController conforms to this protocol, it will receive its messages.
@protocol ILDrawerControllerPart <NSObject>

// Indicates that the view may be moved in a way that partially obscures its content. The given bounds rectangle is visible onscreen. (It's in this view controller's view's coordinate system.)
// May be called within an animation block.
// Please note: if never called, assume the entirety of the bounds of the view are visible.
- (void) drawerController:(ILSlidingRevealViewController*) ctl willChangeVisibleBounds:(CGRect) newBounds;

@end
