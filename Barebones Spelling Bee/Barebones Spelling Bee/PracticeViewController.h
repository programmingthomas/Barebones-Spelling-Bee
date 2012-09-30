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

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Word.h"
#import "WordLoader.h"

@interface PracticeViewController : UIViewController<UITextFieldDelegate>

@property WordLoader *wordLoader;
@property NSMutableArray *words;
@property Word *currentWord;
@property NSManagedObjectContext *context;

@property (weak, nonatomic) IBOutlet UILabel *randomWord;
@property (weak, nonatomic) IBOutlet UITextField *practiceBox;
@property (weak, nonatomic) IBOutlet UILabel *correctLabel;
- (IBAction)finishedTyping:(id)sender;

-(void)load;

@end
