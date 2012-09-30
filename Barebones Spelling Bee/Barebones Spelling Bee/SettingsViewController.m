/*
 Barebones Spelling Bee is a simple iOS app based on flspellingbee.co.uk
 Copyright (C) 2012  Programming Thomas
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.settings = [NSUserDefaults standardUserDefaults];
    [self setCorrectTicks];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self setCorrectTicks];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) [self.settings setObject:@"fr" forKey:@"language"];
        else if (indexPath.row == 1) [self.settings setObject:@"de" forKey:@"language"];
        else if (indexPath.row == 2) [self.settings setObject:@"es" forKey:@"language"];
        for (int i = 0; i < 3; i++)
        {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
        [currentCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else if (indexPath.section == 1)
    {
        [self.settings setObject:[NSNumber numberWithInteger:indexPath.row + 1] forKey:@"stage"];
        for (int i = 0; i < 4; i++)
        {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
        [currentCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    [self.settings synchronize];
    NSLog(@"Language now %@ and stage now %@", [self.settings stringForKey:@"language"], [self.settings objectForKey:@"stage"]);
    [self updateOtherViewControllers];
}

-(void)updateOtherViewControllers
{
    [self.pvc load];
    [self.wlvc load];
    [self.wlvc.tableView reloadData];
}

-(void)setCorrectTicks
{
    NSNumber *stage = [self.settings objectForKey:@"stage"];
    UITableViewCell *stageCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[stage integerValue] - 1 inSection:1]];
    [stageCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    UITableViewCell *languageCell;
    if ([[self.settings stringForKey:@"language"] isEqualToString:@"fr"]) languageCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    else if ([[self.settings stringForKey:@"language"] isEqualToString:@"de"]) languageCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    else languageCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    [languageCell setAccessoryType:UITableViewCellAccessoryCheckmark];
}

@end
