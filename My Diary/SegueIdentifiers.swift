//
//  SegueIdentifiers.swift
//  My Diary
//
//  Created by Dennis Parussini on 22-10-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import Foundation

enum SegueIdentifiers: String {
    case showDetail = "showDetail"
    case showCreateEntry = "showCreateEntry"
    
    func identifier() -> String {
        return self.rawValue
    }
}
