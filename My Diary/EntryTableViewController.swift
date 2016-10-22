//
//  EntryTableViewController.swift
//  My Diary
//
//  Created by Dennis Parussini on 16-10-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import UIKit
import CoreData

fileprivate let cellIdentifier = "entryCell"

class EntryTableViewController: UITableViewController {
    
    let coreDataManager = CoreDataManager.sharedManager

    override func viewDidLoad() {
        super.viewDidLoad()
        
        coreDataManager.fetchedResultsController.delegate = self

        do {
            try coreDataManager.fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let entries = coreDataManager.fetchedResultsController.fetchedObjects?.count {
            return entries
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! EntryCell
        
        let entry = coreDataManager.fetchedResultsController.object(at: indexPath)
        cell.configureWithEntry(entry: entry)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = coreDataManager.fetchedResultsController.object(at: indexPath)
            coreDataManager.managedObjectContext.delete(entry)
            coreDataManager.saveContext()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case SegueIdentifiers.showDetail.identifier():
            let nav = segue.destination as! UINavigationController
            let detailVC = nav.topViewController as! EntryDetailViewController
            if let selectedRow = self.tableView.indexPathForSelectedRow {
                let entry = coreDataManager.fetchedResultsController.object(at: selectedRow)
                detailVC.entry = entry
            }
        case SegueIdentifiers.showCreateEntry.identifier(): break
        default: break
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension EntryTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.reloadData()
    }
}
