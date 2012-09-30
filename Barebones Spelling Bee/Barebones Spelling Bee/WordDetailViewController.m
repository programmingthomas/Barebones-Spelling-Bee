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

#import "WordDetailViewController.h"

@interface WordDetailViewController ()

@end

@implementation WordDetailViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.attempts.count > 0 ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return 3;
    else return self.attempts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        InfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"infoCell" forIndexPath:indexPath];
        if (indexPath.row == 0)
        {
            infoCell.titleLabel.text = @"English";
            infoCell.infoLabel.text = [self.word.english capitalizedString];
        }
        else if (indexPath.row == 1)
        {
            NSDictionary *languages = @{@"es" : @"Spanish", @"fr":@"French", @"de":@"German"};
            infoCell.titleLabel.text = [languages objectForKey:self.word.language];
            infoCell.infoLabel.text = [self.word.foreign capitalizedString];
        }
        else if (indexPath.row == 2)
        {
            infoCell.titleLabel.text = @"Attempts";
            infoCell.infoLabel.text = [NSString stringWithFormat:@"%d", self.attempts.count];
        }
        return infoCell;
    }
    else
    {
        UITableViewCell *genericCell = [tableView dequeueReusableCellWithIdentifier:@"genericCell" forIndexPath:indexPath];
        Attempt *attempt = [self.attempts objectAtIndex:indexPath.row];
        genericCell.textLabel.text = [attempt.attempt capitalizedString];
        genericCell.textLabel.textColor = [attempt.attempt isEqualToString:attempt.correct] ? [UIColor greenColor] : [UIColor redColor];
        return genericCell;
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section == 0 ? @"Information" : @"Attempts";
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return false;
}


@end
