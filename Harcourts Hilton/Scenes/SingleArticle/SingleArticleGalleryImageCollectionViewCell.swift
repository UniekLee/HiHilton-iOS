//
//  SingleArticleGalleryImageCollectionViewCell.swift
//  Harcourts Hilton
//
//  Created by Lee Watkins on 2018/05/01.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import UIKit

class SingleArticleGalleryImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    static var nib: UINib {
        return UINib(nibName: String(describing: SingleArticleGalleryImageCollectionViewCell.self),
                     bundle: HarcourtsHilton)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
