//
//  CollectionViewCellDrink.swift
//  WaterAppDemo
//
//  Created by Egor Markov on 20.12.2020.
//  Copyright © 2020 Egor Markov. All rights reserved.
//

import UIKit

class CollectionViewCellDrink: UICollectionViewCell {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var imageDrink: UIImageView!
    @IBOutlet weak var labelDrink: UILabel!
    @IBOutlet weak var segmentControll: UISegmentedControl!
    @IBOutlet weak var buttonDrink: UIButton!
    
    //MARK: - Propirties
    var page: Page! {
         didSet {
             imageDrink.image = UIImage(named: page.imageName)
             labelDrink.text = page.titleName
         }
     }
    
    override func awakeFromNib() {
         super.awakeFromNib()
       let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentControll.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentControll.setTitleTextAttributes(titleTextAttributes, for: .selected)
        buttonDrink.layer.cornerRadius = 5
        viewImage.layer.cornerRadius = 20
    }
    


    
   
}

