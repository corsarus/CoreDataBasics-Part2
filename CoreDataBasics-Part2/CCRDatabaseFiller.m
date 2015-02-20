//
//  CCRDataFiller.m
//  CoreDataBasics-Part2
//
//  Created by Catalin (iMac) on 20/02/2015.
//  Copyright (c) 2015 corsarus. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "CCRDatabaseFiller.h"

@implementation CCRDatabaseFiller

+ (AppDelegate *)appDelegate
{
    return [UIApplication sharedApplication].delegate;
}

+ (NSManagedObject *)authorForName:(NSString *)fullName
{
    NSString *authorFirstName =  [fullName componentsSeparatedByString:@" "][0];
    NSString *authorLastName =  [fullName componentsSeparatedByString:@" "][1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstName = %@ AND lastName = %@", authorFirstName, authorLastName];
    NSEntityDescription *authorEntityDescription = [NSEntityDescription entityForName:@"Author" inManagedObjectContext:[self appDelegate].managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = authorEntityDescription;
    fetchRequest.predicate = predicate;
    
    NSManagedObject *authorManagedObject = nil;
    NSError *error = nil;
    NSArray *fetchedObjects = [[self appDelegate].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        authorManagedObject = [[NSManagedObject alloc] initWithEntity:authorEntityDescription insertIntoManagedObjectContext:[self appDelegate].managedObjectContext];
        [authorManagedObject setValue:authorFirstName forKey:@"firstName"];
        [authorManagedObject setValue:authorLastName  forKey:@"lastName"];
    } else {
        authorManagedObject = fetchedObjects[0];
    }
    
    return authorManagedObject;
}

+ (NSManagedObject *)publisherForName:(NSString *)name
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSEntityDescription *publisherEntityDescription = [NSEntityDescription entityForName:@"Publisher" inManagedObjectContext:[self appDelegate].managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = publisherEntityDescription;
    fetchRequest.predicate = predicate;
    
    NSManagedObject *publisherManagedObject = nil;
    NSError *error = nil;
    NSArray *fetchedObjects = [[self appDelegate].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        publisherManagedObject = [[NSManagedObject alloc] initWithEntity:publisherEntityDescription insertIntoManagedObjectContext:[self appDelegate].managedObjectContext];
        [publisherManagedObject setValue:name forKey:@"name"];
    } else {
        publisherManagedObject = fetchedObjects[0];
    }
    
    return publisherManagedObject;
}

+ (void)populateDataStorage
{
    NSArray *books = @[@{@"author" : @"Paula Hawkins", @"publisher": @"Riverhead", @"title": @"The Girl on the Train", @"pageCount": @(336), @"datePublished": @"01/13/2015"},
                       @{@"author" : @"Anthony Doerr", @"publisher": @"Scribner", @"title": @"All the Light We Cannot See", @"pageCount": @(531), @"datePublished": @"05/06/2014"},
                       @{@"author" : @"Kristin Hannah", @"publisher": @"St. Martin's Press", @"title": @"The Nightingale", @"pageCount": @(448), @"datePublished": @"02/03/2015"},
                       @{@"author" : @"Neil Gaiman", @"publisher": @"William Morrow", @"title": @"Trigger Warning: Short Fictions and Disturbances", @"pageCount": @(448), @"datePublished": @"02/03/2015"},
                       @{@"author" : @"John Grisham", @"publisher": @"Doubleday", @"title": @"Gray Mountain", @"pageCount": @(384), @"datePublished": @"10/21/2014"},
                       @{@"author" : @"Liane Moriarty", @"publisher": @"G. P. Putnam's Sons", @"title": @"Big Little Lies", @"pageCount": @(460), @"datePublished": @"07/29/2014"},
                       @{@"author" : @"Lisa Gardner", @"publisher": @"Dutton", @"title": @"Crash & Burn", @"pageCount": @(400), @"datePublished": @"02/03/2015"},
                       @{@"author" : @"John Grosser", @"publisher": @"Riverhead", @"title": @"Pilgrim", @"pageCount": @(458), @"datePublished": @"03/10/2013"},
                       @{@"author" : @"Junot Diaz", @"publisher": @"Riverhead", @"title": @"Drown", @"pageCount": @(240), @"datePublished": @"07/01/1997"},
                       @{@"author" : @"Carmine Gallo", @"publisher": @"St. Martin's Press", @"title": @"Talk Like TED", @"pageCount": @(288), @"datePublished": @"03/04/2014"},
                       @{@"author" : @"Erica Spindler", @"publisher": @"St. Martin's Press", @"title": @"The First Wife", @"pageCount": @(352), @"datePublished": @"02/10/2015"}
                       ];
    
    
    for (NSDictionary *book in books) {
        
        NSEntityDescription *bookEntityDescription = [NSEntityDescription entityForName:@"Book" inManagedObjectContext:self.appDelegate.managedObjectContext];
        
        NSManagedObject *bookManagedObject = [[NSManagedObject alloc] initWithEntity:bookEntityDescription insertIntoManagedObjectContext:[self appDelegate].managedObjectContext];
        [bookManagedObject setValue:[book valueForKey:@"title"]  forKey:@"title"];
        [bookManagedObject setValue:[book valueForKey:@"pageCount"]  forKey:@"pageCount"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *publishDate = [formatter dateFromString:[book valueForKey:@"datePublished"]];
        [bookManagedObject setValue:publishDate forKey:@"datePublished"];
        
        NSManagedObject *author = [self authorForName:[book valueForKey:@"author"]];
        [bookManagedObject setValue:author  forKey:@"author"];
        
        NSManagedObject *publisher = [self publisherForName:[book valueForKey:@"publisher"]];
        [bookManagedObject setValue:publisher forKey:@"publisher"];
    }
    
    [[self appDelegate] saveContext];
}

@end
