//
//  DetailViewController.h
//  Barebones Spelling Bee
//
//  Created by Thomas Denney on 30/09/2012.
//  Copyright (c) 2012 Programming Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
