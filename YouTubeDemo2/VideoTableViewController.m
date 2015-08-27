//
//  VideoTableViewController.m
//  YouTubeDemo2
//
//  Created by Kevin Casey on 8/26/15.
//  Copyright (c) 2015 Kevin Casey. All rights reserved.
//

#import "VideoTableViewController.h"
#import "Constants.h"
#import "VideoTableViewCell.h"
#import "VideoViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface VideoTableViewController ()

@end

@implementation VideoTableViewController
{
    YouTubeHelper *_youtubeHelper;
    NSArray *_videos;
    GTLYouTubePlaylistItem *_selectedVideo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _youtubeHelper = [[YouTubeHelper alloc] initWithDelegate:self];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Upload Test Video" style:UIBarButtonItemStylePlain target:self action:@selector(uploadTestVideo)];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:_youtubeHelper
                            action:@selector(authenticate)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    // This should not be called. If it is just go back to login screen.
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)authenticationEndedWithError:(NSError *)error
{
    if (!error) {
        NSLog(@"auth table success");
        [_youtubeHelper getUploadedPlaylist];
    } else {
        NSLog(@"%@", error);
        NSAssert(false, @"This is odd...login failed on table view screen");
    }
}

- (void)uploadedVideosPlaylist:(NSArray *)array;
{
    _videos = [array copy];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];

    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
}

- (void)uploadProgressPercentage:(int)percentage
{
    NSLog(@"PROGRESS UPLOAD: %d", percentage);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_videos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"videoCell" forIndexPath:indexPath];
    
    GTLYouTubePlaylistItem *video;
    
    if (indexPath.section == 0) {
        video = [_videos objectAtIndex:indexPath.row];
    }
    
    [cell.titleLabel setText:video.snippet.title];

    NSURL *url = [NSURL URLWithString:video.snippet.thumbnails.defaultProperty.url];
    [cell.thumbnail sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        _selectedVideo = [_videos objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"videoDetail" sender:self];
    }
}

#pragma mark - Internal

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"videoDetail"])
    {
        // Get reference to the destination view controller
        VideoViewController *vc = [segue destinationViewController];
        
        vc.video = _selectedVideo;
    }
}

- (void)uploadTestVideo
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"wave.mov" ofType:nil];
    NSString *testString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@", testString);
    [_youtubeHelper uploadPrivateVideoWithTitle:@"wave" description:@"test" commaSeperatedTags:nil andPath:path];
}

- (void)logout
{
    [_youtubeHelper signOut];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
