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
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSNumber *stage = [settings objectForKey:@"stage"];
    NSString *language = [settings objectForKey:@"language"];
    NSDictionary *languageReal = @{@"es" : @"Spanish", @"fr" : @"French", @"de":@"German"};
    language = [languageReal objectForKey:language];
    self.langaugeAndStageInformation.text = [NSString stringWithFormat:@"Language: %@\nStage: %@\nYou can change language and stage on the settings tab.", language, stage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
