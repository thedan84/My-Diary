//
//  DateFormatter.swift
//  My Diary
//
//  Created by Dennis Parussini on 22-10-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import Foundation

let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    return dateFormatter
}()
