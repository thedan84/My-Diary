//
//  EntryDetailViewController.swift
//  My Diary
//
//  Created by Dennis Parussini on 16-10-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import MapKit

class EntryDetailViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var entryTextView: SAMTextView!
    @IBOutlet weak var entryDateLabel: UILabel!
    @IBOutlet weak var entryImageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var enableLocationButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    let coreDataManager = CoreDataManager.sharedManager
    var image: UIImage? {
        didSet {
            self.entryImageView.image = image!
        }
    }
    var entry: Entry?
    var imageData: Data?
    var location: CLLocation?
    var locationManager = LocationManager()
    var userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let entry = self.entry {
            self.configureWithEntry(entry: entry)
            
            let imageRecognizer = UITapGestureRecognizer(target: self, action: #selector(addImageButtonTapped(_:)))
            self.entryImageView.addGestureRecognizer(imageRecognizer)
            imageRecognizer.delegate = self
        } else {
            self.configureToCreateEntry()
        }
        
        if userDefaults.bool(forKey: "locationEnabled") {
            enableLocationButton.setTitle("Disable Location", for: .normal)
            
        } else {
            enableLocationButton.setTitle("Enable Location", for: .normal)
        }
        
        locationManager.delegate = self
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let text = entryTextView.text else { return }
        
        if let entry = self.entry {
            entry.text = text
            if let imageData = self.imageData {
                entry.image = imageData as NSData
            }
            coreDataManager.saveContext()
        } else {
            coreDataManager.saveEntry(withText: text, andImageData: self.imageData, andLocation: self.location)
        }
        self.dismiss(animated: true, completion: nil)
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
        self.entryTextView.placeholder = "Tap here to enter text"
        self.entryDateLabel.text = "Created at \(dateFormatter.string(from: Date()))"
        self.entryImageView.isHidden = true
        self.addImageButton.isHidden = false
    }
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func enableLocationButtonTapped(_ sender: UIButton) {
        if userDefaults.bool(forKey: "locationEnabled") {
            userDefaults.set(false, forKey: "locationEnabled")
            enableLocationButton.setTitle("Enable Location", for: .normal)
        } else {
            userDefaults.set(true, forKey: "locationEnabled")
            enableLocationButton.setTitle("Disable Location", for: .normal)
        }
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
            self.image = image
            self.imageData = UIImageJPEGRepresentation(image, 1.0)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension EntryDetailViewController: LocationManagerDelegate {
    func locationManagerDidUpdateLocation(manager: LocationManager, location: CLLocation) {
        self.location = location
    }
}
