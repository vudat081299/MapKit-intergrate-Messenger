//
//  AnnotationDetailView.swift
//  MyMapKit
//
//  Created by Vũ Quý Đạt  on 18/12/2020.
//

import UIKit

class UserDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var annotationList = [1, 2, 3]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return annotationList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : AnnotationCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotationCell", for: indexPath) as! AnnotationCell
        if indexPath.row == 0 {
            cell.csLeadingBgImageView.constant = 15
        } else if (indexPath.row == annotationList.count - 1) {
            cell.csTrailingBgImageView.constant = 15
        } else {
            cell.csLeadingBgImageView.constant = 0
        }
        cell.backGroundImageView.border(15)
        
        return cell
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == 0 || indexPath.row == annotationList.count - 1 {
            return CGSize(width: 165, height: 150)
        } else {
            return CGSize(width: 150, height: 150)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.collectionView.register(UINib(nibName: "AnnotationCell", bundle: nil), forCellWithReuseIdentifier: "AnnotationCell")
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
    @IBAction func logOut(_ sender: UIButton) {
        // method 1
//        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()!
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated:true, completion:nil)
        
        // method 2
        Auth().logout(on: self)
    }
}
