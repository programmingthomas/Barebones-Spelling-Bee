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

#import "WordLoader.h"

@implementation WordLoader


//Call this function BEFORE you get the word list
-(void)load
{
    //Reinitialize
    self.words = [[NSMutableArray alloc] init];
    //Get settings
    self.settings = [NSUserDefaults standardUserDefaults];
    //Figure out word list path (same code as in AppDelegate.m)
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *defaultWordListPath = [documentsPath stringByAppendingPathComponent:@"words.xml"];
    //Can only run this if the file exists, which it should if we got this far
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:defaultWordListPath];
    if (fileExists)
    {
        //Get the file contents as a string
        //I like how easy this is
        NSString *fileContents = [NSString stringWithContentsOfFile:defaultWordListPath encoding:NSUTF16StringEncoding error:nil];
        //The original file on the server was ASCII encoded but the encoding parameter on the XML namespace thingymebob indicated it was ISO-8859-1
        //I'm saving the file as UTF-16 because I don't think all the characters are ASCII/UTF-8 (accents) so I'm changing the file
        fileContents = [fileContents stringByReplacingOccurrencesOfString:@"iso-8859-1" withString:@"UTF-16"];
        
        //NSXMLParser is really easy once you get the hang of it
        //Basically just give it an NSData from the NSString and set the delegate to self
        //Start the parsing operation and every time it comes across an element it will fire the parser:parser didStartElement function
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[fileContents dataUsingEncoding:NSUTF16StringEncoding]];
        parser.delegate = self;
        if (![parser parse]) NSLog(@"Problem %@", parser.parserError.localizedDescription);
    }
    else NSLog(@"File doesn't exist");
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    //Check if the element is a word
    if ([elementName isEqualToString:@"word"])
    {
        //Get the language used by the element
        NSString *language = [attributeDict objectForKey:@"language"];
        //For some peculiar reason in the XML file it uses gr instead of de to represent Germany
        //When I first wrote the code I assumed it would be de because the others were standard international codes (fr and es)
        //I guess this could change in the future and if it changes to DE in the future I'll get rid of this line of code
        if ([language isEqualToString:@"gr"]) language = @"de";
        //Only bother doing extra work if it is actually the current language, as stored in NSUserDefaults
        if ([language isEqualToString:[self.settings objectForKey:@"language"]])
        {
            //Check that it is the right stage by converting it to a number
            //This is a lot easier in C#
            NSString *stageString = [attributeDict objectForKey:@"stage"];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterNoStyle];
            NSNumber *stage = [formatter numberFromString:stageString];
            NSNumber *currentStage = [self.settings objectForKey:@"stage"];
            //If the stage is less than/equal to the current stage actually load it
            if ([stage intValue] <= [currentStage intValue])
            {
                //A nice tidy way to store the words
                //I didn't want to make life difficult with a dictionary
                Word *word = [[Word alloc] init];
                word.language = language;
                word.stage = stage;
                word.english = [attributeDict objectForKey:@"eng"];
                word.foreign = [attributeDict objectForKey:@"lang"];
                [self.words addObject:word];
            }
        }
    }
}

@end
