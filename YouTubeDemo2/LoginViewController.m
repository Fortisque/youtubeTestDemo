//
//  LoginViewController.m
//  YouTubeDemo2
//
//  Created by Kevin Casey on 8/26/15.
//  Copyright (c) 2015 Kevin Casey. All rights reserved.
//

#import "LoginViewController.h"
#import "Constants.h"
#import "VideoTableViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
{
    YouTubeHelper *_youtubeHelper;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _youtubeHelper = [[YouTubeHelper alloc] initWithDelegate:self];
    [_youtubeHelper authenticate];
}

#pragma mark - YoutubeHelperDelegate

- (NSString *)youtubeAPIClientID
{
    return kYoutubeAPIClientID;
}

- (NSString *)youtubeAPIClientSecret
{
    return kYoutubeAPIClientSecret;
}

- (void)showAuthenticationViewController:(UIViewController *)authView
{
    [self.navigationController pushViewController:authView animated:YES];
}

- (void)authenticationEndedWithError:(NSError *)error
{
    if (!error) {
        NSLog(@"auth success");
        [self performSegueWithIdentifier:@"authSuccess" sender:self];
    } else {
        NSLog(@"%@", error);
    }
}

- (IBAction)login:(id)sender {
    [_youtubeHelper authenticate];
}

@end
