//
//  ResizableCellTableViewCell.m
//  NotificationScreen
//
//  Created by Nelly Chakarova on 14/07/15.
//  Copyright (c) 2015 Nelly Chakarova. All rights reserved.
//

#import "ResizableCellTableViewCell.h"

@implementation ResizableCellTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatar = [[UIImageView alloc]init];
        
        //Rounding the picture with the cornersRadius. Maybe with masking will be better
        self.avatar.layer.cornerRadius = 25;
        self.avatar.clipsToBounds = YES;
        [self prepareImage:self.avatar];
        
        self.clock = [[UIImageView alloc]init];
        [self prepareImage:self.clock];
        
        self.notificationTypeImage = [[UIImageView alloc]init];
        [self prepareImage:self.notificationTypeImage];
        
        self.name = [[UILabel alloc]init];
        [self prepareLabel:self.name];
        NSString *labelText = @" ";
        [self setNameProperties:labelText];
        
        
        self.notificationTypeText = [[UILabel alloc]init];
        [self prepareLabel:self.notificationTypeText];
        labelText = @" ";
        [self setNotificationTypeTextProperties:labelText];
        
        
        self.message = [[UILabel alloc]init];
        [self prepareLabel:self.message];
        labelText = @" ";
        [self setMessageProperties:labelText];
        
        self.time = [[UILabel alloc]init];
        [self prepareLabel:self.time];
        labelText = @" ";
        [self setTimeProperties:labelText];
        
        [self establishConstraints];
        
        
    }
    
    return self;
}

- (void)prepareImage:(UIImageView*)image{
    [image setContentMode:UIViewContentModeScaleAspectFit];
    image.translatesAutoresizingMaskIntoConstraints=NO;
    [self.contentView addSubview:image];
}

-(void)prepareLabel:(UILabel*)label{
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:label];
}

-(void)setMessageProperties:(NSString*)text{
    NSString* temp = @" ";
    if(text!=nil){
        temp=text;
    }
    
    if ([self.message respondsToSelector:@selector(setAttributedText:)]) {
        NSDictionary *attrs = @{
                                NSFontAttributeName:[UIFont fontWithName:@"Helvetica Neue" size:14],
                                NSForegroundColorAttributeName:[UIColor colorWithRed:26.0f/255
                                                                               green:26/255
                                                                                blue:26/255.0f
                                                                               alpha:1.0f]
                                };
        
        NSMutableAttributedString *attributedText =
        [[NSMutableAttributedString alloc] initWithString:temp
                                               attributes:attrs];
        [self.message setAttributedText:attributedText];
    } else {
        [self.message setText:temp];
    }
}

-(void)setTimeProperties:(NSString*)text{
    NSString* temp = @" ";
    if(text!=nil){
        temp=text;
    }
    
    if ([self.time respondsToSelector:@selector(setAttributedText:)]) {
        NSDictionary *attrs = @{
                                NSFontAttributeName:[UIFont fontWithName:@"Lato-Regular" size:12],
                                NSForegroundColorAttributeName:[UIColor colorWithRed:124.0f/255.0f
                                                                               green:126.0f/255.0f
                                                                                blue:136.0f/255.0f
                                                                               alpha:1.0f],
                                NSBaselineOffsetAttributeName:@1.5
                                };
        
        NSMutableAttributedString *attributedText =
        [[NSMutableAttributedString alloc] initWithString:temp
                                               attributes:attrs];
        [self.time setAttributedText:attributedText];
    } else {
        [self.time setText:temp];
    }
}

-(void)setNameProperties:(NSString*)text{
    NSString* temp = @"Obelix";
    if(text!=nil){
        temp=text;
    }
    
    if ([self.name respondsToSelector:@selector(setAttributedText:)]) {
        NSDictionary *attrs = @{
                                NSFontAttributeName:[UIFont fontWithName:@"Lato-Bold" size:15],
                                NSForegroundColorAttributeName:[UIColor colorWithRed:17.0f/255.0f
                                                                               green:107.0f/255.0f
                                                                                blue:201.0f/255.0f
                                                                               alpha:1.0f]
                                };
        
        NSMutableAttributedString *attributedText =
        [[NSMutableAttributedString alloc] initWithString:temp
                                               attributes:attrs];
        [self.name setAttributedText:attributedText];
    } else {
        [self.name setText:temp];
    }
}

-(void)setNotificationTypeTextProperties:(NSString*)text{
    NSString* temp = @"liked your post";
    if(text!=nil){
        temp=text;
    }
    
    if ([self.notificationTypeText respondsToSelector:@selector(setAttributedText:)]) {
        NSDictionary *attrs = @{
                                NSFontAttributeName:[UIFont fontWithName:@"Lato-Regular" size:15],
                                NSForegroundColorAttributeName:[UIColor colorWithRed:25.0f/255.0f
                                                                               green:136.0f/255.0f
                                                                                blue:173.0f/255.0f
                                                                               alpha:1.0f]
                                
                                };
        
        NSMutableAttributedString *attributedText =
        [[NSMutableAttributedString alloc] initWithString:temp
                                               attributes:attrs];
        [self.notificationTypeText setAttributedText:attributedText];
    } else {
        [self.notificationTypeText setText:temp];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    self.name.preferredMaxLayoutWidth = CGRectGetWidth(self.name.frame);
    self.notificationTypeText.preferredMaxLayoutWidth =  CGRectGetWidth(self.name.frame);
    self.message.preferredMaxLayoutWidth = CGRectGetWidth(self.message.frame);
    self.time.preferredMaxLayoutWidth = CGRectGetWidth(self.time.frame);
}

-(void)establishConstraints{
    
    UILabel* name = self.name;
    UILabel* message = self.message;
    UILabel* time = self.time;
    UILabel* text = self.notificationTypeText;
    UIImageView* image = self.avatar;
    UIImageView* clock = self.clock;
    UIImageView* icon = self.notificationTypeImage;
    
    
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(image,name, clock,time, icon,message,text);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[image(==50)]-8-[name]-60-|" options:0 metrics:nil views:viewDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[clock(==12)]-3-[time]-20-|" options:0 metrics:nil views:viewDictionary]];
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[image]-8-[message]-60-|" options:0 metrics:nil views:viewDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[image]-[icon(==20)]-3-[text]-60-|" options:0 metrics:nil views:viewDictionary]];
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[image(==50)]" options:0 metrics:nil views:viewDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[name]-3-[icon(==20)]" options:0 metrics:nil views:viewDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[name]-3-[text]-3-[message]-20-|" options:0 metrics:nil views:viewDictionary]];
    
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[clock(==12)]" options:0 metrics:nil views:viewDictionary]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[time]" options:0 metrics:nil views:viewDictionary]];
    
}


@end
