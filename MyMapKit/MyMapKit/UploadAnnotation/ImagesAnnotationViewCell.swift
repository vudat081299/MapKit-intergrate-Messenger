//
//  ImagesAnnotationViewCell.swift
//  MyMapKit
//
//  Created by Vũ Quý Đạt  on 20/12/2020.
//

import UIKit

class ImagesAnnotationViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var imageAnnoCollectionView: UICollectionView!
    
    var imageArray: [UIImage]? {
        didSet {
            imageAnnoCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        imageAnnoCollectionView.delegate = self
        imageAnnoCollectionView.dataSource = self
        self.imageAnnoCollectionView.register(UINib(nibName: "ImagesAnnotationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImagesAnnotationCollectionViewCell")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: ImagesAnnotationCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesAnnotationCollectionViewCell", for: indexPath) as! ImagesAnnotationCollectionViewCell
        
        let a = imageArray
        cell.imageAnnotationView.image = imageArray![indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 80, height: 80)
    }
    
}
