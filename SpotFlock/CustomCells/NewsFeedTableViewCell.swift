//
//  NewsFeedTableViewCell.swift
//  SpotFlock
//
//  Created by Nuviso Infore on 01/08/19.
//  Copyright © 2019 Spotflock. All rights reserved.
//

import UIKit

class NewsFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var titleImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
