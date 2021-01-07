//
//  AnnotatitionViewController.swift
//  MyMapKit
//
//  Created by Vũ Quý Đạt  on 19/12/2020.
//

import UIKit

let leadingEdgeCollectionView: CGFloat = 30.0

class AnnotatitionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    @IBOutlet weak var nameLocation: UILabel! // title
    @IBOutlet weak var note: UILabel! // address ...
    @IBOutlet weak var user: UILabel! //
    @IBOutlet weak var annoDescriptionLabel: UILabel!
    
    
    var annotationList = [1, 2, 3]
    var CellWidth = 0.0
    
    var annoTitle: String!
    var mySubTitle: String!
    var annoDescription: String!
    var id: String!
    var discipline: String!
    var type: String!
    var imageNote: String!
    var country: String!
    var city: String!
    var subListImage: [UIImage] = []
    var listImage: [UIImage] {
        get {
            return subListImage
        }
        set {
            subListImage = newValue
            myCollectionView.reloadData()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: AnnotationImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotationImageCell", for: indexPath) as! AnnotationImageCell
        if indexPath.row == 0 {
            cell.csLeadingBgImageView.constant = leadingEdgeCollectionView
            cell.csTrailingBgImageView.constant = 0
        } else if (indexPath.row == listImage.count - 1) {
            cell.csLeadingBgImageView.constant = 0
            cell.csTrailingBgImageView.constant = leadingEdgeCollectionView
        } else {
            cell.csLeadingBgImageView.constant = 0
            cell.csTrailingBgImageView.constant = 0
        }
        cell.backGroundImageView.border(10)
        cell.backGroundImageView.image = listImage[indexPath.row]
        
        return cell
    }
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == 0 || indexPath.row == listImage.count - 1 {
            return CGSize(width: view.frame.size.width - leadingEdgeCollectionView, height: view.frame.size.width * 3/5)
        } else {
            return CGSize(width: view.frame.size.width - 2 * leadingEdgeCollectionView, height: view.frame.size.width * 3/5)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.myCollectionView.register(UINib(nibName: "AnnotationImageCell", bundle: nil), forCellWithReuseIdentifier: "AnnotationImageCell")
        CellWidth = Double(view.frame.size.width - 1.5 * leadingEdgeCollectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getImageData()
        
        nameLocation.text = annoTitle
        note.text = mySubTitle
        annoDescriptionLabel.text = annoDescription
        
    }
    
    func getImageData() {
        let idAnno = String(id)
        let annotationsRequestInfo = ResourceRequest<AnnotatioImageData, AnnotatioImageData>(resourcePath: "annotations/\(idAnno)/data")
        annotationsRequestInfo.getAll { [weak self] result in
            
            switch result {
            case .failure:
//                ErrorPresenter.showError(message: "There was an error getting the annotations", on: self)
                print("fail get image!")
            case .success(let annotationDatas):
                DispatchQueue.main.async { [weak self] in
                    guard self != nil else { return }
                    do {
                        for annotationData in annotationDatas {
                            let imageData = try Data(base64Encoded: annotationData.image)
                            self!.listImage.append(UIImage(data: imageData!)!)
                            let test = UIImage(data: Data(base64Encoded: annotationData.image)!)
                        }
                        self!.myCollectionView.reloadData()
                    } catch {
                        // 5
                        print("Unexpected error: \(error).")
                    }
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension AnnotatitionViewController: UIScrollViewDelegate {
    
    // do not enabled paging
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.myCollectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        var cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        cellWidthIncludingSpacing = view.frame.size.width - 45
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
//        print("\(layout.itemSize.width) - \(layout.minimumLineSpacing)")
//        print("\(cellWidthIncludingSpacing) - \(offset) - \(index) - \(roundedIndex) - \(roundedIndex)")
        targetContentOffset.pointee = offset
    }
}
