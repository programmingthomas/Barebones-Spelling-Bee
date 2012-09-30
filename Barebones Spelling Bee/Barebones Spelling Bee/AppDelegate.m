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

#import "AppDelegate.h"
#import "WordListViewController.h"
#import "PracticeViewController.h"
#import "SettingsViewController.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    if ([settings objectForKey:@"language"] == nil) [settings setObject:@"es" forKey:@"language"];
    if ([settings objectForKey:@"stage"] == nil) [settings setObject:[NSNumber numberWithInt:1] forKey:@"stage"];
    [settings synchronize];
    [self copyWordListToDefaultLocation];
    UITabBarController *tbc = (UITabBarController*)self.window.rootViewController;
    UINavigationController *nc = [tbc.childViewControllers objectAtIndex:1];
    WordListViewController *wlvc = [nc.childViewControllers objectAtIndex:0];
    PracticeViewController *pvc = [tbc.childViewControllers objectAtIndex:2];
    SettingsViewController *svc = [tbc.childViewControllers objectAtIndex:3];
    svc.pvc = pvc;
    svc.wlvc = wlvc;
    pvc.context = wlvc.context = self.managedObjectContext;
    return YES;
}

-(void)copyWordListToDefaultLocation
{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *defaultWordListPath = [documentsPath stringByAppendingPathComponent:@"words.xml"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:defaultWordListPath];
    NSURL *urlForWebResource = [NSURL URLWithString:@"http://www.flspellingbee.co.uk/xml.xml"];
    NSError *error;
    NSString *fromWeb = [NSString stringWithContentsOfURL:urlForWebResource encoding:NSASCIIStringEncoding error:&error];
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
