//
//  ImageAnnotation.swift
//  MyMapKit
//
//  Created by Vũ Quý Đạt  on 20/12/2020.
//

import UIKit

class ImageAnnotation: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionViewImageAnnotation: UICollectionView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var imageArray: [UIImage]? {
        didSet {
//            collectionViewImageAnnotation.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionViewImageAnnotation.register(UINib(nibName: "ImagesAnnotationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImagesAnnotationCollectionViewCell")
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
