//
//  WeatherTableViewCell.swift
//  WeatherForecast
//
//  Created by Juhi Gautam on 16/11/18.
//  Copyright © 2018 Juhi Gautam. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var myDateLabel: UILabel!
    @IBOutlet weak var myStatusLabel: UILabel!
    @IBOutlet weak var myMaxLabel: UILabel!
    @IBOutlet weak var myMinLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
