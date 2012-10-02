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

//When you do custom table cells in Storyboards (labels in different places, images, buttons, etc) you need to create a custom class to represent it
//You then (I've done this) set the class of the prototype cell to InfoCell or whatever and control+drag from the cell (in the list on the left) to the UIView
@interface InfoCell : UITableViewCell

@property IBOutlet UILabel *titleLabel;
@property IBOutlet UILabel *infoLabel;

@end
