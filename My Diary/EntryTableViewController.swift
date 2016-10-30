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

class EntryTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    let coreDataManager = CoreDataManager.sharedManager
    let searchController = UISearchController(searchResultsController: nil)
    var entries = [Entry]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Search Bar Configuration
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
        self.searchController.searchBar.delegate = self
        definesPresentationContext = true
        
        coreDataManager.fetchedResultsController.delegate = self

        do {
            try coreDataManager.fetchedResultsController.performFetch()
        } catch let error as NSError {
            AlertManager.showAlert(with: "Error", andMessage: "\(error.localizedDescription)", inViewController: self)
        }
        
        self.tableView.estimatedRowHeight = 90
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return entries.count
        } else {
            if let entries = coreDataManager.fetchedResultsController.fetchedObjects?.count {
                return entries
            }
        }
        
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! EntryCell
        
        if searchController.isActive {
            let entry = entries[indexPath.row]
            cell.configureWithEntry(entry: entry)
        } else {
            let entry = coreDataManager.fetchedResultsController.object(at: indexPath)
            cell.configureWithEntry(entry: entry)
        }
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if searchController.isActive {
                let entry = entries[indexPath.row]
                coreDataManager.deleteEntry(entry: entry)
            } else {
                let entry = coreDataManager.fetchedResultsController.object(at: indexPath)
                coreDataManager.deleteEntry(entry: entry)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let nav = segue.destination as! UINavigationController
            let detailVC = nav.topViewController as! EntryDetailViewController
            if let selectedRow = self.tableView.indexPathForSelectedRow {
                if searchController.isActive {
                    let entry = entries[selectedRow.row]
                    detailVC.entry = entry
                } else {
                    let entry = coreDataManager.fetchedResultsController.object(at: selectedRow)
                    detailVC.entry = entry
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text {
            self.entries = coreDataManager.searchEntry(withText: text)
        }
        self.tableView.reloadData()
    }
}

extension EntryTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.reloadData()
    }
}
