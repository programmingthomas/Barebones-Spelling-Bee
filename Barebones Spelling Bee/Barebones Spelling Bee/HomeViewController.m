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

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    //Check the defaults and remind the user what language and stage they're doing on the ultra stylish Home View Controller
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSNumber *stage = [settings objectForKey:@"stage"];
    NSString *language = [settings objectForKey:@"language"];
    //Create a dictionary the lazy way. You can do this for NSArrays as well with @[,] and obviously NSStrings with @""
    NSDictionary *languageReal = @{@"es" : @"Spanish", @"fr" : @"French", @"de":@"German"};
    language = [languageReal objectForKey:language];
    self.langaugeAndStageInformation.text = [NSString stringWithFormat:@"Language: %@\nStage: %@\nYou can change language and stage on the settings tab.", language, stage];
}

- (void)didReceiveMemoryWarning
{
    //I didn't put anything here because it is hardly an exhaustive app
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
