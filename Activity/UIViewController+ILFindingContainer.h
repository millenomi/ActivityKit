//
//  UIViewController+ILFindingContainer.h
//  Activity
//
//  Created by ∞ on 02/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>

@interface UIViewController (ILFindingContainer)

- (id) containingViewControllerOfClass:(Class) c;

@end

#endif
