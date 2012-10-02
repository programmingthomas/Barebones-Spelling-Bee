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
    //Return 2 sections if there are attempts, otherwise 1
    return self.attempts.count > 0 ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Return either details or attempt count
    if (section == 0) return 3;
    else return self.attempts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //This is a messy way of presenting the basic details
    if (indexPath.section == 0)
    {
        //This is for the topmost language section
        InfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
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
        //This is the bit for showing the different attempts
        UITableViewCell *genericCell = [tableView dequeueReusableCellWithIdentifier:@"genericCell"];
        Attempt *attempt = [self.attempts objectAtIndex:indexPath.row];
        genericCell.textLabel.text = [attempt.attempt capitalizedString];
        //Give it a color (these could be prettier)
        genericCell.textLabel.textColor = [attempt.attempt isEqualToString:attempt.correct] ? [UIColor greenColor] : [UIColor redColor];
        return genericCell;
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //Section titles - this function is usually optional but it is really useful
    return section == 0 ? @"Information" : @"Attempts";
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Another optional function ensures that the rows don't get highlighted because it looks messy
    return false;
}


@end
