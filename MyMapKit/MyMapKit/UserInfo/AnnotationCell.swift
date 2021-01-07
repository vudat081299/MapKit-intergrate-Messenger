//
//  AnnotationCell.swift
//  MyMapKit
//
//  Created by Vũ Quý Đạt  on 19/12/2020.
//

import UIKit

class AnnotationCell: UICollectionViewCell {

    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var csLeadingBgImageView: NSLayoutConstraint!
    @IBOutlet weak var csTrailingBgImageView: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backGroundImageView.layer.borderWidth = 0.5
        backGroundImageView.layer.borderColor = UIColor.lightGray.cgColor
        backGroundImageView.clipsToBounds = true
    }

}
