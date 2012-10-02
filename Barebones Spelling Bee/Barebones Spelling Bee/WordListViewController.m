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

#import "WordListViewController.h"

@interface WordListViewController ()

@end

@implementation WordListViewController

//This gets fired instead of any other init functions usually
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self load];
    }
    return self;
}


//Basically get a WordLoader and get the words into this class' NSMutableArray
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
    //Could do some extra work and split into stages but this is displayed on the cell anyway
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Return the number of words
    return self.words.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get the prototype standard cell from the table view
    //I believe that the regular dequeueResuableCellWithIdentifier has been deprecated so you have to add forIndexPath
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    //Load the word object and set values
    Word *word = [self.words objectAtIndex:indexPath.row];
    cell.textLabel.text = [word.foreign capitalizedString];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - Stage %d", [word.english capitalizedString], [word.stage intValue]];
    //Return cell so it can be displayed
    return cell;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Basically just provide WordDetail with stuff to do
    if ([[segue identifier] isEqualToString:@"wordDetail"])
    {
        WordDetailViewController *wdvc = segue.destinationViewController;
        wdvc.word = [self.words objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        //Getting attempts in advance means one place to throw the NSManagedObjectContext to.
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *description = [NSEntityDescription entityForName:@"Attempt" inManagedObjectContext:self.context];
        [request setPredicate:[NSPredicate predicateWithFormat:@"(language == %@) AND (correct == %@)", wdvc.word.language, wdvc.word.foreign]];
        [request setEntity:description];
        wdvc.attempts = [self.context executeFetchRequest:request error:nil];
    }
}

@end
