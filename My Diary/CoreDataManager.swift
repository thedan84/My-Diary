//
//  CoreDataManager.swift
//  My Diary
//
//  Created by Dennis Parussini on 22-10-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

public class CoreDataManager {
    
    static let sharedManager = CoreDataManager()
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "My_Diary")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        return managedObjectContext
    }()
    
    lazy var entityDescription: NSEntityDescription = {
        let description = NSEntityDescription.entity(forEntityName: "Entry", in: self.managedObjectContext)!
        return description
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: Entry.fetchRequest(), managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        if self.managedObjectContext.hasChanges {
            do {
                try self.managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK: - Save entry
    func saveEntry(withText text: String, andImageData imageData: Data?, andLocation location: CLLocation?) {
        let entryDescription = NSEntityDescription.entity(forEntityName: "Entry", in: self.managedObjectContext)!
        let entry = Entry(entity: entryDescription, insertInto: self.managedObjectContext)
        
        if let imageData = imageData {
            entry.image = imageData as NSData
        }
        
        if let location = location {
            entry.location = self.saveLocation(withLatitude: location.coordinate.latitude, andLongitude: location.coordinate.longitude, andEntry: entry)
        }
        
        entry.text = text
        entry.date = Date() as NSDate
                
        self.saveContext()
    }
    
    //MARK: - Save location
    fileprivate func saveLocation(withLatitude latitude: Double, andLongitude longitude: Double, andEntry entry: Entry) -> Location {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Location", in: self.managedObjectContext)!
        let location = Location(entity: entityDescription, insertInto: self.managedObjectContext)
        
        location.latitude = latitude
        location.longitude = longitude
        
        return location
    }
    
    
    //MARK: - Delete entry/entries
    func deleteEntry(entry: Entry) {
        managedObjectContext.delete(entry)
        self.saveContext()
    }
    
    func deleteAllEntries() {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let entries = try! self.managedObjectContext.fetch(fetchRequest)
        
        for entry in entries {
            self.managedObjectContext.delete(entry)
            self.saveContext()
        }
    }
    
    //MARK: - Search Helper method
    func searchEntry(withText text: String) -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.entity = entityDescription
        let predicate = NSPredicate(format: "text contains[cd] %@", text)
        fetchRequest.predicate = predicate
        let entries = try! managedObjectContext.fetch(fetchRequest)
        return entries
    }
}
