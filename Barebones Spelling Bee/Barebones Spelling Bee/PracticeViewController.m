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

#import "PracticeViewController.h"
#import "Attempt.h"

@interface PracticeViewController ()

@end

@implementation PracticeViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    return self;
}

//Load up the word lists using WordLoader and display a random word to begin with
-(void)load
{
    self.words = [[NSMutableArray alloc] init];
    self.wordLoader = [[WordLoader alloc] init];
    [self.wordLoader load];
    self.words = self.wordLoader.words;
    self.correctLabel.hidden = YES;
    [self nextWord];
}

//Load up the UI
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self load];
    self.practiceBox.delegate = self;
    //This ensures that when someone taps away from the textbox the keyboard disappears
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
    //arc4random() seems more random than random(). Do modulo to ensure it is less than the total word count
    int rand = arc4random() % self.words.count;
    //Show
    self.currentWord = [self.words objectAtIndex:rand];
    self.randomWord.text = [self.currentWord.english capitalizedString];
    self.practiceBox.text = @"";
}

-(void)checkWord
{
    //Basically stick the attempt in the DB
    Attempt *attempt = [NSEntityDescription insertNewObjectForEntityForName:@"Attempt" inManagedObjectContext:self.context];
    attempt.attempt = self.practiceBox.text;
    attempt.correct = self.currentWord.foreign;
    attempt.language = self.currentWord.language;
    //Ensure correct label is visible with info
    self.correctLabel.hidden = NO;
    self.correctLabel.text = [attempt.attempt isEqualToString:attempt.correct] ? @"Correct!" : @"Wrong!";
    self.correctLabel.textColor = [attempt.attempt isEqualToString:attempt.correct] ? [UIColor greenColor] : [UIColor redColor];
}

//When someone hits enter
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self checkWord];
    [self nextWord];
    return YES;
}

-(void)dismissKeyboard
{
    //Hides the keyboard (I still maintain a hideKeyboard:(BOOL) function should be on UITextFields...)
    [self.practiceBox resignFirstResponder];
}
@end
