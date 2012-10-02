/*
 Barebones Spelling Bee is a simple iOS app based on flspellingbee.co.uk
 Copyright 2012 Programming Thomas
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

//Load the UI
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.settings = [NSUserDefaults standardUserDefaults];
    //Bit ambiguous but this ensures that the correct rows (depending on settings) are ticked
    [self setCorrectTicks];
}

-(void)viewDidAppear:(BOOL)animated
{
    //Also set correct selections here
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
        //Is in the language section
        if (indexPath.row == 0) [self.settings setObject:@"fr" forKey:@"language"];
        else if (indexPath.row == 1) [self.settings setObject:@"de" forKey:@"language"];
        else if (indexPath.row == 2) [self.settings setObject:@"es" forKey:@"language"];
        //Untick all cells in section
        for (int i = 0; i < 3; i++)
        {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        //Tick correct cell
        UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
        [currentCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else if (indexPath.section == 1)
    {
        //Is in stage section (add one because index starts at 0, stage starts at 1
        [self.settings setObject:[NSNumber numberWithInteger:indexPath.row + 1] forKey:@"stage"];
        for (int i = 0; i < 4; i++)
        {
            //Set all cells to unticked
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        //Tick correct cell
        UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
        [currentCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    //Save settings
    [self.settings synchronize];
    //Notify logger of change
    NSLog(@"Language now %@ and stage now %@", [self.settings stringForKey:@"language"], [self.settings objectForKey:@"stage"]);
    //Ensures the other views are not left behind
    [self updateOtherViewControllers];
}

-(void)updateOtherViewControllers
{
    //Reload the other view controller's data and reload the table view
    [self.pvc load];
    [self.wlvc load];
    [self.wlvc.tableView reloadData];
}

//Tick the correct cells/rows based on the settings (full explanation above)
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
