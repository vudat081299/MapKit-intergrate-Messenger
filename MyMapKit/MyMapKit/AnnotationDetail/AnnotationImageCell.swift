//
//  AnnotationImageCell.swift
//  MyMapKit
//
//  Created by Vũ Quý Đạt  on 19/12/2020.
//

import UIKit

class AnnotationImageCell: UICollectionViewCell {
    
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
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        let featuredHeight = UltravisualLayoutConstants.Cell.featuredHeight
        let standardHeight = UltravisualLayoutConstants.Cell.standardHeight
        
        let delta = 1 - ((featuredHeight - frame.height) / (featuredHeight - standardHeight))
        let minAlpha: CGFloat = 0.3
        let maxAlpha: CGFloat = 0.75
        
//        imageCoverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
        
        let scale = max(delta, 0.5)
//        titleLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
        
//        timeAndRoomLabel.alpha = delta
//        speakerLabel.alpha = delta
    }
}
