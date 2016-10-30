//
//  My_DiaryTests.swift
//  My DiaryTests
//
//  Created by Dennis Parussini on 16-10-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import XCTest
import CoreData
import CoreLocation
@testable import My_Diary

class My_DiaryTests: XCTestCase {
    
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
    
    lazy var entryEntityDescription: NSEntityDescription = {
        let description = NSEntityDescription.entity(forEntityName: "Entry", in: self.managedObjectContext)!
        return description
    }()
    
    lazy var locationEntityDescription: NSEntityDescription = {
        let description = NSEntityDescription.entity(forEntityName: "Location", in: self.managedObjectContext)!
        return description
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: Entry.fetchRequest(), managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }()
    
    let coreDataManager = CoreDataManager.sharedManager
    
    //Fake data
    let text = "Hello there"
    let image = UIImageJPEGRepresentation(UIImage(named: "1371")!, 1.0)
    var location: Location {
        let fakeLocation = Location(entity: locationEntityDescription, insertInto: self.managedObjectContext)
        fakeLocation.latitude = 50.936389
        fakeLocation.longitude = 6.952778
        
        return fakeLocation
    }
    let date = NSDate()
    
    override func setUp() {
        super.setUp()
        
        createEntry()
    }
    
    override func tearDown() {
        
        coreDataManager.deleteAllEntries()
        super.tearDown()
    }
    
    //Delete entry
    func testDeleteEntry() {
        XCTAssert(coreDataManager.fetchedResultsController.fetchedObjects?.count != 0, "No objects could be fetched")
        
        coreDataManager.deleteAllEntries()
        
        XCTAssert(coreDataManager.fetchedResultsController.fetchedObjects?.count == 0, "Entries haven't been deleted from the store")
    }
    
    //Create Entry
    func testCreateEntry() {
        coreDataManager.deleteAllEntries()
        
        XCTAssert(self.coreDataManager.fetchedResultsController.fetchedObjects?.count == 0, "There are more or less objects already in the store")
        
        let location = CLLocation(latitude: self.location.latitude, longitude: self.location.longitude)
        
        coreDataManager.saveEntry(withText: text, andImageData: image, andLocation: location)
        
        XCTAssert(self.coreDataManager.fetchedResultsController.fetchedObjects?.count == 1, "Error while creating entry")
    }
    
    //MARK: - Helper function
    func createEntry() {
        let fakeEntry = Entry(entity: self.entryEntityDescription, insertInto: self.managedObjectContext)
        fakeEntry.text = "Hello there"
        fakeEntry.image = UIImageJPEGRepresentation(UIImage(named: "1371")!, 1.0) as NSData?
        fakeEntry.location = location
        fakeEntry.date = NSDate()
        
        coreDataManager.saveContext()
    }
}
