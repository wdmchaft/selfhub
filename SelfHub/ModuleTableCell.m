//
//  DesktopTableCell.m
//  HealthCare
//
//  Created by Eugine Korobovsky on 16.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ModuleTableCell.h"

@implementation ModuleTableCell

@synthesize moduleName, moduleDescription, moduleIcon, moduleMessage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc
{
    [moduleName release];
    [moduleDescription release];
    [moduleIcon release];
    [moduleMessage release];
    
    [super dealloc];
}

@end
