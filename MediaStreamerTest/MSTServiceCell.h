//
//  MSTServiceCell.h
//  MediaStreamerTest
//
//  Created by Bektur Ryskeldiev on 2/26/14.
//  Copyright (c) 2014 Bektur Ryskeldiev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSTServiceCell : UITableViewCell
{
    IBOutlet UILabel __weak *labelServiceName;
    IBOutlet UILabel __weak *labelServiceStatus;
}

@property (nonatomic, weak) UILabel *labelServiceName;
@property (nonatomic, weak) UILabel *labelServiceStatus;

@end
