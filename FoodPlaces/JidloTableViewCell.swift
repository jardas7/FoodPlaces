//
//  JidloTableViewCell.swift
//  FoodPlaces
//
//  Copyright © 2017 Jaromír Hnik. All rights reserved.
//

import UIKit

class JidloTableViewCell: UITableViewCell {
 
    @IBOutlet weak var labelCena: UILabel!
    @IBOutlet weak var labelNazev: UILabel!
    @IBOutlet weak var imageViewFood: UIImageView!
    
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var shadowView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageViewFood.clipsToBounds = true
        imageViewFood.layer.cornerRadius = 8
        
        shadowView.layer.shadowColor = UIColor.gray.cgColor
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowOffset = CGSize.zero
        shadowView.layer.shadowRadius = 4
        shadowView.layer.cornerRadius = 8
        shadowView.layer.shouldRasterize = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
