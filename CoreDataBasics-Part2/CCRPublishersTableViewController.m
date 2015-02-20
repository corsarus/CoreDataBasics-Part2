//
//  CCRPublishersTableViewController.m
//  CoreDataBasics-Part2
//
//  Created by admin on 10/02/15.
//  Copyright (c) 2015 corsarus. All rights reserved.
//

#import "CCRPublishersTableViewController.h"
#import "CCRBooksTableViewController.h"

#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface CCRPublishersTableViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation CCRPublishersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController) {
        
        NSEntityDescription *publisherEntityDescription = [NSEntityDescription entityForName:@"Publisher" inManagedObjectContext:[self appDelegate].managedObjectContext];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.entity = publisherEntityDescription;
        fetchRequest.sortDescriptors = @[sortDescriptor];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:[self appDelegate].managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
        
        NSError *error = nil;
        [_fetchedResultsController performFetch:&error];
        
        if (error) {
            NSLog(@"Error while loading data: %@", error.localizedDescription);
        }
        
    }
    
    return _fetchedResultsController;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.fetchedResultsController.fetchedObjects.count;
}

#pragma mark - Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSManagedObject *publisher = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [publisher valueForKey:@"name"];
    
    return cell;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showBooks"]) {
        CCRBooksTableViewController *booksViewController = (CCRBooksTableViewController *)segue.destinationViewController;
        booksViewController.publisher = [self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
    }
}

#pragma mark - Core Data stack

- (AppDelegate *)appDelegate
{
    return [UIApplication sharedApplication].delegate;
}


@end
