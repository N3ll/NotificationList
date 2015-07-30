//
//  TableViewController.m
//  NotificationScreen
//
//  Created by Nelly Chakarova on 05/07/15.
//  Copyright (c) 2015 Nelly Chakarova. All rights reserved.
//

#import "TableViewController.h"
#import "ResizableCellTableViewCell.h"

#define globalQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define youLocalURL [NSURL URLWithString: @"https://www.youlocalapp.com/api/notifications/load/?largeScreen&token=f2908658dc92d32a491d2e5b30aad86e"]


@interface TableViewController ()
@property (strong,nonatomic) NSArray* notifications;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_async(globalQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:youLocalURL];
        [self performSelectorOnMainThread:@selector(notificationsData:) withObject:data waitUntilDone:YES];
    });
    
    
    UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    //And here we build a gradient and set the backgount of the navigationbar
    [[UINavigationBar appearance] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin];
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title = @"Notifications";
    navbar.items = @[ navItem ];
    
    
    [self.view addSubview:navbar];
    
    self.tableView = [[UITableView alloc] initWithFrame: CGRectMake(0,navbar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-navbar.frame.size.height)
                                                  style:UITableViewStylePlain];
    
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
    
    
}



-(void)notificationsData:(NSData*)dataFromURL{
    NSError* error;
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:dataFromURL options:0 error:&error];
    
    NSArray* temp = [json objectForKey:@"notifications"];
    NSMutableArray* forAllNotifications = [[NSMutableArray alloc]init];
    NSDictionary* tempNotifictation = [[NSDictionary alloc]init];
    
    
    for (int i=0; i< temp.count; i++) {
        tempNotifictation=[temp objectAtIndex:i];
        
        if([[ tempNotifictation objectForKey:@"notificationType"] isEqualToString:@"Comment"] || [[tempNotifictation objectForKey:@"notificationType"] isEqualToString:@"Comment mention"] || [[tempNotifictation objectForKey:@"notificationType"] isEqualToString:@"Message like"]){
            [forAllNotifications addObject:tempNotifictation];
        }
    }
    
    self.notifications= [[NSArray alloc]initWithArray:forAllNotifications];
    NSLog(@"notifications: %lu", (unsigned long)self.notifications.count);
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //will be determined by the number of notifications returned from the json file
    return self.notifications.count ? self.notifications.count : 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Create a reusable cell
    ResizableCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyNotification"];
    if(!cell) {
        cell = [[ResizableCellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyNotification"];
        
    }
    
    NSDictionary* notification = self.notifications[indexPath.row];
    
    NSLog(@"Row #%d",indexPath.row);
    
    //Setting the avatar icon
    NSString* userPicture = [notification objectForKey:@"avatar"];
    if(userPicture == nil){
        cell.avatar.image = [UIImage imageNamed:@"avatar"];
    }else{
        cell.avatar.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userPicture]]];
        NSLog(@"User picture url %@",userPicture);
    }
    
    //Setting the clock icon
    cell.clock.image = [UIImage imageNamed:@"time"];
    
    //Setting the message
    NSString* userMessage = [notification objectForKey:@"message"];
    if(userMessage == nil){
        [cell setMessageProperties:@" "];
    }else{
        [cell setMessageProperties:userMessage];
        NSLog(@"Message %@",userMessage);
    }
    
    //Setting the label for the user name
    NSArray* users = [notification objectForKey:@"users"];
    NSLog(@"Number of users related: %d",users.count);
    
    NSString* userName = [notification objectForKey:@"fullname"];
    NSLog(@"Full name of the user %@",userName);
    
    if(users.count >0 && users.count<=2){
        NSString *firstName = [[userName componentsSeparatedByString:@" "] objectAtIndex:0];
        NSString *firstName2 = [[[[users objectAtIndex:0] objectForKey:@"fullname"] componentsSeparatedByString:@" "] objectAtIndex:0];
        
        [cell setNameProperties:[ NSString stringWithFormat:@"%@ and %@",firstName,firstName2]];
        NSLog(@"Name label %@",cell.name.text);
        
    }else if(users.count>2){
        NSString *firstName = [[userName componentsSeparatedByString:@" "] objectAtIndex:0];
        
        [cell setNameProperties:[ NSString stringWithFormat:@"%@ and %d others",firstName,users.count]];
        NSLog(@"Name label %@",cell.name.text);
    }else{
        [cell setNameProperties:userName];
        NSLog(@"Name label %@",cell.name.text);
    }
    
    
    //Setting the icon for the type of notification
    NSString* typeOfnotification = [notification objectForKey:@"notificationType"];
    if([typeOfnotification isEqualToString:@"Message like"]){
        cell.notificationTypeImage.image = [UIImage imageNamed:@"like"];
    } else {
        cell.notificationTypeImage.image = [UIImage imageNamed:@"comment"];
    }
    
    //Setting the notificationType text label
    NSString* notificationText = [notification objectForKey:@"notificationTypeText"];
    [cell setNotificationTypeTextProperties: notificationText];
    
    
    //Setting the time label
    //And here the "createdAt" and "notificationDate" are taken from the JSON file
    //A subtraction of the first from first is made and depending of the number, a suitable number for seconds(s), minutes(m), hours(h), weeks(w), etc. is set as a label for time
    //For time management reasons, all of the notifications will from 2w ago :)
    [cell setTimeProperties: @"2w"];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  UITableViewAutomaticDimension;
}


@end
