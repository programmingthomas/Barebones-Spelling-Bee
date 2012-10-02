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

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Word.h"
#import "WordDetailViewController.h"
#import "WordLoader.h"

//This shows a list of words in the current stage/language
@interface WordListViewController : UITableViewController

@property WordLoader *wordLoader;
@property NSMutableArray *words;
@property NSUserDefaults *settings;
@property NSManagedObjectContext *context;

//Fired by SettingsViewController to update on a settings change
-(void)load;

@end
