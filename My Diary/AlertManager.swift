//
//  AlertManager.swift
//  My Diary
//
//  Created by Dennis Parussini on 22-10-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import UIKit

//MARK: - Alert Manager
struct AlertManager {
    static func showAlert(with title: String, andMessage message: String, inViewController viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
