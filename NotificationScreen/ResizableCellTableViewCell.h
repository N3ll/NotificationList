//
//  ResizableCellTableViewCell.h
//  NotificationScreen
//
//  Created by Nelly Chakarova on 14/07/15.
//  Copyright (c) 2015 Nelly Chakarova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResizableCellTableViewCell : UITableViewCell
@property (strong,nonatomic) UIImageView* avatar;
@property (strong,nonatomic) UIImageView* clock;
@property (strong,nonatomic) UIImageView* notificationTypeImage;

@property (strong,nonatomic) UILabel* name;
@property (strong,nonatomic) UILabel* notificationTypeText;
@property (strong,nonatomic) UILabel* message;
@property (strong,nonatomic) UILabel* time;

-(void)setMessageProperties:(NSString*)text;
-(void)setTimeProperties:(NSString*)text;
-(void)setNameProperties:(NSString*)text;
-(void)setNotificationTypeTextProperties:(NSString*)text;



@end
