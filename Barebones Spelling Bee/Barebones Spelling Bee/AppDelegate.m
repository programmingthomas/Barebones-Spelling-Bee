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

#import "AppDelegate.h"
#import "WordListViewController.h"
#import "PracticeViewController.h"
#import "SettingsViewController.h"

@implementation AppDelegate

//Synthesize stuff done because some stuff uses _managedObjectContext (Xcode 4.5 automatically inserts synthesize statements at compile though)
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //OK, I wrote this code
    //NSUserDefaults is basically just a mutable dictionary that is saved in the app's docs directory
    //You call [settings synchronize] to save any changes
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    //This is a dumb way of setting defaults. It works but I'm sure there are better methods
    if ([settings objectForKey:@"language"] == nil) [settings setObject:@"es" forKey:@"language"];
    if ([settings objectForKey:@"stage"] == nil) [settings setObject:[NSNumber numberWithInt:1] forKey:@"stage"];
    [settings synchronize]; //And we save
    //This ensures that the latest copy of the word list is saved in the documents directory
    [self copyWordListToDefaultLocation];
    
    //Messy code time
    //This is the initial view controller (indicated by the arrow on the Storyboard)
    UITabBarController *tbc = (UITabBarController*)self.window.rootViewController;
    //This is the navigation controller that is the parent of the word list
    //Its index is 1 because (currently) it is the second view controller
    UINavigationController *nc = [tbc.childViewControllers objectAtIndex:1];
    //Now get the actual classes for all the view controllers that need to access the database...
    WordListViewController *wlvc = [nc.childViewControllers objectAtIndex:0];
    PracticeViewController *pvc = [tbc.childViewControllers objectAtIndex:2];
    SettingsViewController *svc = [tbc.childViewControllers objectAtIndex:3];
    
    //The settings view controller needs pointers to the other two so that they automatically update when a setting is changed
    svc.pvc = pvc;
    svc.wlvc = wlvc;
    
    //And give them access to the Managed Object context
    pvc.context = wlvc.context = self.managedObjectContext;
    return YES;
}

-(void)copyWordListToDefaultLocation
{
    //Basically figure out where to store the word list
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *defaultWordListPath = [documentsPath stringByAppendingPathComponent:@"words.xml"];
    //Good to check if it already exists if there is no internet connection
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:defaultWordListPath];
    //These lines fetch the most recent version from the web
    NSURL *urlForWebResource = [NSURL URLWithString:@"http://www.flspellingbee.co.uk/xml.xml"];
    NSError *error;
    //Last time I checked the encoding was ASCII!
    NSString *fromWeb = [NSString stringWithContentsOfURL:urlForWebResource encoding:NSASCIIStringEncoding error:&error];
    //Log an errors
    if (error != nil) NSLog(@"%@", [error localizedDescription]);
    //Copy if has got a new version from the web
    if (fromWeb != nil)
    {
        [fromWeb writeToFile:defaultWordListPath atomically:NO encoding:NSUTF16StringEncoding error:nil];
    }
    //Copy from the bundle if the file doesn't exist and internet is unavailable
    else if (!fileExists)
    {
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"defaultwordlist" ofType:@"xml"];
        NSString *toWrite = [NSString stringWithContentsOfFile:bundlePath encoding:NSUTF16StringEncoding error:nil];
        [toWrite writeToFile:defaultWordListPath atomically:NO encoding:NSUTF16StringEncoding error:nil];
    }
}

//Everything below this line is database loading stuff generated by Xcode.

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Barebones_Spelling_Bee" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Barebones_Spelling_Bee.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
