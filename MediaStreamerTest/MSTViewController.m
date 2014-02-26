//
//  MSTViewController.m
//  MediaStreamerTest
//
//  Created by Bektur Ryskeldiev on 2/22/14.
//  Copyright (c) 2014 Bektur Ryskeldiev. All rights reserved.
//

#import "MSTViewController.h"
#import "MSTAudioManager.h"
#import "MSTConnectionManager.h"
#import "MSTConnectionManager+ServerAPI.h"
#import "MSTConstants.h"

#import "MSTRemoteServiceViewController.h"
#import "MSTServiceCell.h"

@interface MSTViewController () <MSTRemoteServiceViewControllerProtocol>
{
    MSTConnectionManager *_connectionManager;
    MSTRemoteService *_pickedRemoteService;
    MSTRemoteServiceViewController *_remoteVC;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateServiceInfo) name:kServiceSearchFinishedNotification object:nil];
}

- (void) removeNotificationObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kServiceReadyForStreamingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kServiceStartedStreamingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kServiceSearchFinishedNotification object:nil];
}

#pragma mark - Connection manager callbacks

- (void) updateServiceInfo
{
    [_labelLocalService setText:_connectionManager.localService.service.name];
    [_labelDNS setText:[NSString stringWithFormat:@"%@:%d", _connectionManager.localService.resolvedAddress, kServicePortNumber]];
    
    if (_connectionManager.isStreaming)
    {
        [_labelStatus setText:@"Currently streaming"];
    }
    else{
        [_labelStatus setText:@"Ready for streaming"];
    }
    
    [_tableRemoteService reloadData];
}

- (void) startedStreaming
{
    [self updateServiceInfo];
    
    //TODO: think of other methods
}

- (void) startStreamingFile
{
    [_connectionManager startStreamingFile:@"acoustic" withExtension:@"mp3"];
}

#pragma mark - TableView callbacks

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Service name / Is streaming mode on?"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_connectionManager.availableServices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MSTServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[MSTServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    MSTRemoteService *remoteService = [_connectionManager.availableServices objectAtIndex:indexPath.row];
    
    [cell.labelServiceName setText:remoteService.service.name];
    
    if (remoteService.isStreaming)
    {
        [cell.labelServiceStatus setText:@"On"];
    }
    else
    {
        [cell.labelServiceStatus setText:@"Off"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _pickedRemoteService = [_connectionManager.availableServices objectAtIndex:indexPath.row];
    [_remoteVC setRemoteService:_pickedRemoteService];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Segue methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ServiceDetailsSegue"])
    {
        _remoteVC = segue.destinationViewController;
        [_remoteVC setDelegate:self];
    }
}

- (void) dismissViewController
{
    
}

#pragma mark - Button methods

- (IBAction)startStreamingButtonPressed:(id)sender
{
    [self startStreamingFile];
}

- (IBAction)stopStreamingButtonPressed:(id)sender
{
    [_connectionManager stopStreaming];
}

- (IBAction)startPlaybackButtonPressed:(id)sender
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"acoustic" ofType:@"mp3"];
    [[MSTAudioManager sharedInstance] playFileAtURL:[NSURL fileURLWithPath:filePath]];
}

- (IBAction)stopPlaybackButtonPressed:(id)sender
{
    [[MSTAudioManager sharedInstance] playbackStop];
}

@end
