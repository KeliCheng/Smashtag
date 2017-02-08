//
//  HistoryTableViewCell.swift
//  Smashtag
//
//  Created by ❤ on 12/31/16.
//  Copyright © 2016 Keli Cheng. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    
    var history: String? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        historyLabel.text? = history!
        
    }
    
    //    TODO: add swipe to delete
    
}
