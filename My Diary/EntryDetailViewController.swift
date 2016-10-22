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
    @IBOutlet weak var addImageButton: UIButton!
    
    var entry: Entry?
    
    let coreDataManager = CoreDataManager.sharedManager
    var imageData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let entry = self.entry {
            self.configureWithEntry(entry: entry)
        } else {
            self.configureToCreateEntry()
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let text = entryTextView.text else { return }
        
        let entryDescription = coreDataManager.entityDescription
        let entry = Entry(entity: entryDescription, insertInto: coreDataManager.managedObjectContext)
        
        if let imageData = self.imageData {
            entry.image = imageData as NSData
        }
        
        entry.text = text
        entry.date = Date() as NSDate
        
        coreDataManager.saveContext() {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func configureWithEntry(entry: Entry) {
        self.entryTextView.text = entry.text
        self.entryDateLabel.text = "Created at \(dateFormatter.string(from: entry.date as Date))"
        
        if let image = entry.image {
            self.entryImageView.image = UIImage(data: image as Data)
            self.addImageButton.isHidden = true
        } else {
            self.addImageButton.isHidden = false
        }
    }
    
    func configureToCreateEntry() {
        self.entryTextView.text = "Tap here to enter some text"
        self.entryDateLabel.text = "Created at \(dateFormatter.string(from: Date()))"
        self.entryImageView.isHidden = true
        self.addImageButton.isHidden = false
    }
    @IBAction func cancelButtonTapped(_ sender: UIButton) {

    }
    
    @IBAction func addImageButtonTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension EntryDetailViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if let croppedImage = UIImageJPEGRepresentation(image, 0.5) {
                self.imageData = croppedImage
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
