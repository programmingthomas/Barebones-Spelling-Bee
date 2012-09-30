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

#import "WordListViewController.h"

@interface WordListViewController ()

@end

@implementation WordListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self load];
    }
    return self;
}

-(void)load
{
    self.wordLoader = [[WordLoader alloc] init];
    [self.wordLoader load];
    self.words = self.wordLoader.words;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.words.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Word *word = [self.words objectAtIndex:indexPath.row];
    cell.textLabel.text = [word.foreign capitalizedString];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - Stage %d", [word.english capitalizedString], [word.stage intValue]];
    return cell;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"wordDetail"])
    {
        WordDetailViewController *wdvc = segue.destinationViewController;
        wdvc.word = [self.words objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *description = [NSEntityDescription entityForName:@"Attempt" inManagedObjectContext:self.context];
        [request setPredicate:[NSPredicate predicateWithFormat:@"(language == %@) AND (correct == %@)", wdvc.word.language, wdvc.word.foreign]];
        [request setEntity:description];
        wdvc.attempts = [self.context executeFetchRequest:request error:nil];
    }
}

@end
