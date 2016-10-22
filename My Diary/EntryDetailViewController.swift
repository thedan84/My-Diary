//
//  EntryDetailViewController.swift
//  My Diary
//
//  Created by Dennis Parussini on 16-10-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import UIKit
import CoreData

class EntryDetailViewController: UIViewController {
    
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var entryDateLabel: UILabel!
    @IBOutlet weak var entryImageView: UIImageView!
    
    var entry: Entry? {
        didSet {
            guard let entry = entry else { return }
            
            self.configureWithEntry(entry: entry)
        }
    }
    
    let coreDataManager = CoreDataManager.sharedManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        //Implement saving
    }
    
    func configureWithEntry(entry: Entry) {
        self.entryTextView.text = entry.text
        self.entryDateLabel.text = dateFormatter.string(from: entry.date as! Date)
        
        if let image = entry.image {
            self.entryImageView.image = UIImage(data: image as Data)
        }
    }
}
