//
//  DesktopTableCell.h
//  HealthCare
//
//  Created by Eugine Korobovsky on 16.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModuleTableCell : UITableViewCell{
    
}

@property (nonatomic, retain) IBOutlet UILabel *moduleName;
@property (nonatomic, retain) IBOutlet UILabel *moduleDescription;
@property (nonatomic, retain) IBOutlet UIImageView *moduleIcon;
@property (nonatomic, retain) IBOutlet UILabel *moduleMessage;

@end
