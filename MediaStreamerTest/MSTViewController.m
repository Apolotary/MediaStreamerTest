//
//  MSTViewController.m
//  MediaStreamerTest
//
//  Created by Bektur Ryskeldiev on 2/22/14.
//  Copyright (c) 2014 Bektur Ryskeldiev. All rights reserved.
//

#import "MSTViewController.h"
#import "MSTConnectionManager.h"
#import "MSTConnectionManager+ServerAPI.h"
#import "MSTConstants.h"

@interface MSTViewController ()
{
    MSTConnectionManager *_connectionManager;
}

- (void) addNotificationObservers;
- (void) removeNotificationObservers;

- (void) updateServiceInfo;
- (void) startedStreaming;
- (void) startStreamingFile;

@end

@implementation MSTViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	_connectionManager = [MSTConnectionManager sharedInstance];
    [_connectionManager searchForAvailableServers];
}

- (void) viewDidAppear:(BOOL)animated
{
    [self addNotificationObservers];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [self removeNotificationObservers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification methods

- (void) addNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateServiceInfo) name:kServiceReadyForStreamingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startedStreaming) name:kServiceStartedStreamingNotification object:nil];
}

- (void) removeNotificationObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kServiceReadyForStreamingNotification object:nil];
}

#pragma mark - Connection manager callbacks

- (void) updateServiceInfo
{
    
}

- (void) startedStreaming
{
    
}

- (void) startStreamingFile
{
    [_connectionManager startStreamingFile:@"bass" withExtension:@"mp3"];
}

#pragma mark - TableView callbacks

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Service name / Is streaming mode on?"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Button methods

- (IBAction)startStreamingButtonPressed:(id)sender;
- (IBAction)stopStreamingButtonPressed:(id)sender;

- (IBAction)startPlaybackButtonPressed:(id)sender;
- (IBAction)stopPlaybackButtonPressed:(id)sender;

@end
