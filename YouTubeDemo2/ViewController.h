//
//  ViewController.h
//  YouTubeDemo2
//
//  Created by Kevin Casey on 8/2/15.
//  Copyright (c) 2015 Kevin Casey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YouTubeHelper.h"

@interface ViewController : UIViewController<YouTubeHelperDelegate>

- (IBAction)logout:(id)sender;

@end

