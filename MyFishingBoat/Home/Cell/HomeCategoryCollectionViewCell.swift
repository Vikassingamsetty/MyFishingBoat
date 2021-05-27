//
//  HomeCategoryCollectionViewCell.swift
//  MyFishingBoat
//
//  Created by Appcare on 18/06/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class HomeCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleToFill
    }

}
