//
//  ImagesAnnotationCollectionViewCell.swift
//  MyMapKit
//
//  Created by Vũ Quý Đạt  on 20/12/2020.
//

import UIKit

class ImagesAnnotationCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageAnnotationView: UIImageView!
    @IBOutlet weak var removeImageButton: UIButton!
    var indexPathRow: Int?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.border()
        imageAnnotationView.border()
    }
    @IBAction func removeImage(_ sender: UIButton) {
        
    }
    
}
