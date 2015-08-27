//
//  LoginViewController.h
//  YouTubeDemo2
//
//  Created by Kevin Casey on 8/26/15.
//  Copyright (c) 2015 Kevin Casey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YouTubeHelper.h"

@interface LoginViewController : UIViewController<YouTubeHelperDelegate>

- (IBAction)login:(id)sender;

@end
