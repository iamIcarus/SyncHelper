//
//  ViewController.m
//  SyncHelper
//
//  Created by AYLON-4 on 03/02/15.
//  Copyright (c) 2015 AYLON-4. All rights reserved.
//

#import "ViewController.h"
#import "SyncHelper.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *lblLoading;
@end

@implementation ViewController

//Our RSS links
NSString* kRSS1  = @"http://www.sigmalive.com/rss";
NSString* kRSS2 = @"http://www.pbs.org/wgbh/nova/rss/nova.xml";
NSString* kRSS3 = @"http://www.ant1iwo.com/rss/news/";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Register Fail and Success notifications for the SyncHelper
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:kNotificationSyncCompleteFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:kNotificationSyncCompleteSuccess object:nil];
    
    self.lblLoading.text = @"App Loaded!";

    NSArray *RSSLINKS = @[kRSS1, kRSS2, kRSS3];
    
    
    //Initialize SyncHelper with all RSS Links the app uses
    [[SyncHelper sharedInstance]initLinks:RSSLINKS];
    [self updateData];

}

-(void)updateData
{
    self.lblLoading.text = @"Loading...";
    
    // Request updated from the SyncHelper from only the current RSS
    [[SyncHelper sharedInstance]requestDataUpdateforRSS:kRSS1];
}

- (IBAction)actionUpdate:(id)sender
{
    [self updateData];
}

- (void)handleNotification:(NSNotification*)note {
    
    NSArray* data = note.object;

    if([note.name isEqualToString:kNotificationSyncCompleteSuccess])
    {
        
        if(data.count != 0)
            self.lblLoading.text = @"Succcess";   //Do something with Data
       else
            self.lblLoading.text = @"Fetch ok but data empty"; // Unknown Error?
    }
    else
    {
        if(data.count == 0)
           self.lblLoading.text = @"Failed and db is empty"; //Failed Fetch and we have an empty DB
        else
           self.lblLoading.text = @"Failed loaded from db";  // Failed fetch data loaded from db successfully
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
