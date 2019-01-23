//
//  MealTableViewCell.swift
//  Lab2
//
//  Created by Volodymyr Klymenko on 2019-01-23.
//  Copyright © 2019 Volodymyr Klymenko. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {
	//MARK: Properties
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var photoImageView: UIImageView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
