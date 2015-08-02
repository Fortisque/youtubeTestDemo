//
//  ViewController.m
//  YouTubeDemo2
//
//  Created by Kevin Casey on 8/2/15.
//  Copyright (c) 2015 Kevin Casey. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    YouTubeHelper *_youtubeHelper;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _youtubeHelper = [[YouTubeHelper alloc] initWithDelegate:self];
    [_youtubeHelper authenticate];
}

#pragma mark - YoutubeHelperDelegate

- (NSString *)youtubeAPIClientID
{
    return @"77275823048-68jfj962526akiuge7v3upamf6rbcpvk.apps.googleusercontent.com";
}

- (NSString *)youtubeAPIClientSecret
{
    return @"F2odtmGeXD2GllZzBwyn-m02";
}

- (void)showAuthenticationViewController:(UIViewController *)authView
{
    [self.navigationController pushViewController:authView animated:YES];
}

- (void)authenticationEndedWithError:(NSError *)error
{
    if (!error) {
        NSLog(@"auth success");
        [_youtubeHelper getUploadedPlaylist];
    } else {
        NSLog(@"%@", error);
    }
}

- (void)uploadedVideosPlaylist:(NSArray *)array;
{
    NSLog(@"uploaded list:");
    for (int ii = 0; ii < array.count; ii++) {
        GTLYouTubePlaylistItem* item = array[ii];
        NSLog(@" %@", item.snippet.title);
    }
}

- (void)uploadProgressPercentage:(int)percentage
{
    NSLog(@"PROGRESS: %d", percentage);
}

#pragma mark - Internal

- (IBAction)upload:(id)sender
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"wave.mov" ofType:nil];
    NSString *testString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@",testString);
    [_youtubeHelper uploadPrivateVideoWithTitle:@"wave" description:@"test" commaSeperatedTags:nil andPath:path];
}

- (IBAction)logout:(id)sender {
}
@end
