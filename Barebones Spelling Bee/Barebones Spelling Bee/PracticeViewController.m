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

#import "PracticeViewController.h"
#import "Attempt.h"

@interface PracticeViewController ()

@end

@implementation PracticeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)load
{
    self.wordLoader = [[WordLoader alloc] init];
    [self.wordLoader load];
    self.words = self.wordLoader.words;
    self.correctLabel.hidden = YES;
    [self nextWord];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self load];
    self.practiceBox.delegate = self;
    //[self.practiceBox addTarget:self action:@selector(finishedTyping:) forControlEvents:UIControlEventEditingDidEnd];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)nextWord
{
    int rand = arc4random() % self.words.count;
    self.currentWord = [self.words objectAtIndex:rand];
    self.randomWord.text = [self.currentWord.english capitalizedString];
    self.practiceBox.text = @"";
}

-(void)checkWord
{
    Attempt *attempt = [NSEntityDescription insertNewObjectForEntityForName:@"Attempt" inManagedObjectContext:self.context];
    attempt.attempt = self.practiceBox.text;
    attempt.correct = self.currentWord.foreign;
    attempt.language = self.currentWord.language;
    self.correctLabel.hidden = NO;
    self.correctLabel.text = [attempt.attempt isEqualToString:attempt.correct] ? @"Correct!" : @"Wrong!";
    self.correctLabel.textColor = [attempt.attempt isEqualToString:attempt.correct] ? [UIColor greenColor] : [UIColor redColor];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self checkWord];
    [self nextWord];
    return YES;
}


-(void)dismissKeyboard
{
    [self.practiceBox resignFirstResponder];
}
@end
