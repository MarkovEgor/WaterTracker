//
//  TableViewCellDrink.swift
//  WaterAppDemo
//
//  Created by Egor Markov on 20.12.2020.
//  Copyright © 2020 Egor Markov. All rights reserved.
//

import UIKit

class TableViewCellDrink: UITableViewCell {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var imageDrink: UIImageView!
    @IBOutlet weak var labelDrink: UILabel!
    @IBOutlet weak var volumeDrink: UILabel!
    
    //MARK: - Propirties
    var drink: Drink! {
        didSet {
            imageDrink.image = UIImage(named: drink.title ?? " ")
            labelDrink.text = drink.title
            volumeDrink.text = "\(drink.volume)ml"
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        labelDrink.text = nil
        volumeDrink.text = nil
        imageDrink.image = nil
    }
}
