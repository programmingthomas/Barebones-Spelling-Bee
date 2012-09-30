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

#import "WordLoader.h"

@implementation WordLoader

-(void)load
{
    self.words = [[NSMutableArray alloc] init];
    [self.words removeAllObjects];
    self.settings = [NSUserDefaults standardUserDefaults];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *defaultWordListPath = [documentsPath stringByAppendingPathComponent:@"words.xml"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:defaultWordListPath];
    if (fileExists)
    {
        NSString *fileContents = [NSString stringWithContentsOfFile:defaultWordListPath encoding:NSUTF16StringEncoding error:nil];
        fileContents = [fileContents stringByReplacingOccurrencesOfString:@"iso-8859-1" withString:@"UTF-16"];
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[fileContents dataUsingEncoding:NSUTF16StringEncoding]];
        parser.delegate = self;
        if (![parser parse]) NSLog(@"Problem %@", parser.parserError.localizedDescription);
    }
    else NSLog(@"File doesn't exist");
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"word"])
    {
        NSString *language = [attributeDict objectForKey:@"language"];
        if ([language isEqualToString:@"gr"]) language = @"de";
        if ([language isEqualToString:[self.settings objectForKey:@"language"]])
        {
            NSString *stageString = [attributeDict objectForKey:@"stage"];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterNoStyle];
            NSNumber *stage = [formatter numberFromString:stageString];
            NSNumber *currentStage = [self.settings objectForKey:@"stage"];
            if (stage <= currentStage)
            {
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
