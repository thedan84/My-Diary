//
//  EntryCell.swift
//  My Diary
//
//  Created by Dennis Parussini on 16-10-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import UIKit

class EntryCell: UITableViewCell {
    
    @IBOutlet weak var entryTextLabel: UILabel!
    @IBOutlet weak var entryDateLabel: UILabel!
    @IBOutlet weak var entryImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        entryImageView.isHidden = true
    }
    
    func configureWithEntry(entry: Entry) {
        self.entryTextLabel.text = entry.text
        self.entryDateLabel.text = dateFormatter.string(from: entry.date as Date)
        
        if let image = entry.image {
            self.entryImageView.isHidden = false
            self.entryImageView.image = UIImage(data: image as Data)
        }
    }

}
