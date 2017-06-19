//
//  RestauraceTableViewCell.swift
//  FoodPlaces
//
//  Created by Jaromír Hnik on 19.06.17.
//  Copyright © 2017 Jaromír Hnik. All rights reserved.
//

import UIKit

class RestauraceTableViewCell: UITableViewCell {


   
    @IBOutlet weak var labelNazev: UILabel!
    @IBOutlet weak var labelLokace: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
