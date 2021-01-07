//
//  UploadAnnotationViewController.swift
//  MyMapKit
//
//  Created by Vũ Quý Đạt  on 20/12/2020.
//

import UIKit
import CoreLocation

enum TypeAnnotation: Int, CaseIterable {
    case publibPlace, restaurant, coffeeShop, clothesShop, pharmacy, superMaket, virus, sos
}

let typeAnnotationText = ["Public place", "Restaurant", "Coffee Shop", "Clothes Shop", "Pharmacy", "Super Maket", "Virus", "SoS"]

struct UploadAnnotationData {
    var title = "a"
    var subTitle = "a"
    var description = "a"
    var type: Int = 0
    var imageNote: [String]?
    var image: [File]?
    var lat: CLLocationDegrees? {
        get {
            return ViewController.userLocationVal?.coordinate.latitude
        }
    }
    var long: CLLocationDegrees? {
        get {
            return ViewController.userLocationVal?.coordinate.longitude
        }
    }
    
    func getPlaceInfo() -> [String] {
        var place = ["Earth", "Earth", "Earth"]
        let geocoder = CLGeocoder()
        guard let userLocation = ViewController.userLocationVal else {
            return place
        }
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
//                print("error in reverseGeocode - can not get location of device!")
            }
            var placemark: [CLPlacemark]!
            if placemarks != nil {
                placemark = placemarks! as [CLPlacemark]
            } else {
//                print("loading location..")
                return
            }
            if placemark.count > 0 {
                let placemark = placemarks![0]
                place[0] = placemark.locality!
                place[1] = placemark.administrativeArea!
                place[2] = placemark.country!
//                print(placemark.locality!)
//                print(placemark.administrativeArea!)
//                print(placemark.country!)
            }
        }
        return place
    }
}

var uploadAnnotationData = UploadAnnotationData()

class UploadAnnotationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var keyboardHeight: CGFloat = 0.0
    
    @IBOutlet weak var inputTableView: UITableView!
    @IBOutlet weak var csBottomTableView: NSLayoutConstraint!
    var picker: UIPickerView!
    
    var listCapturedImage: [UIImage]?
    
    var inputFieldText = ["Location name", "Note", "Description"]
    var placeholderInputFieldText = ["Ha Noi ..v", "address or something special", "your review"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else if section == 1 {
            return 1
        } else if section == 2 {
            uploadAnnotationData.imageNote = Array(repeating: "", count: listCapturedImage!.count)
            return listCapturedImage!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell: UploadAnnoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UploadAnnoTableViewCell", for: indexPath) as! UploadAnnoTableViewCell
            cell.indexPath = indexPath
            cell.title.text = inputFieldText[indexPath.row]
            cell.textInput.placeholder = placeholderInputFieldText[indexPath.row]
            return cell
        } else if indexPath.section == 1 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "picker")
            cell.contentView.addSubview(picker)
            picker.translatesAutoresizingMaskIntoConstraints = false
            picker.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor).isActive = true
            picker.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor).isActive = true
            picker.topAnchor.constraint(equalTo: cell.contentView.topAnchor).isActive = true
            picker.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true
            return cell
        } else if indexPath.section == 2 {
            let cell: ViewImageCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ViewImageCellTableViewCell", for: indexPath) as! ViewImageCellTableViewCell
            
            cell.imageAnno.image = listCapturedImage![indexPath.row]
            cell.imageAnno.border()
            cell.layerImageView.dropShadow()
            cell.textInput.placeholder = "Enter your review"
            cell.indexPathRow = indexPath.row
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Information about this place"
        } else if section == 1 {
            return "Type of location"
        } else if section == 2 {
            return "Review for every pictures you did take"
        }
        return ""
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    // picker view datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeAnnotationText.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typeAnnotationText[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        uploadAnnotationData.type = row
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadAnnotationData = UploadAnnotationData()

        // Do any additional setup after loading the view.
        self.inputTableView.register(UINib(nibName: "UploadAnnoTableViewCell", bundle: nil), forCellReuseIdentifier: "UploadAnnoTableViewCell")
        self.inputTableView.register(UINib(nibName: "ViewImageCellTableViewCell", bundle: nil), forCellReuseIdentifier: "ViewImageCellTableViewCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        picker = UIPickerView()
        self.picker.delegate = self
        self.picker.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60
        } else if indexPath.section == 1 {
            return 90
        } else if indexPath.section == 2 {
            return 150
        }
        return 60
    }

    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func uploadAnnotationToServer(_ sender: UIButton) {
        self.view.endEditing(true)
        var file = [File] ()
        for (index, value) in listCapturedImage!.enumerated() {
            file.append(File(data: value.pngData()!, filename: "\(index)"))
        }
        
        var note = ""
        for n in uploadAnnotationData.imageNote! {
            note += "-\(n)"
        }
        
        let user = AnnotationUpload(title: uploadAnnotationData.title, subTitle: uploadAnnotationData.subTitle, latitude: String(ViewController.userLocationVal?.coordinate.latitude ?? 20.00), longitude: String(ViewController.userLocationVal?.coordinate.longitude ?? 20.00), description: uploadAnnotationData.description, type: String(uploadAnnotationData.type), imageNote: note, image: file, city: uploadAnnotationData.getPlaceInfo()[0], country: uploadAnnotationData.getPlaceInfo()[0])
        ResourceRequest<AnnotationUpload, AnnotationUpload>(resourcePath: "annotations").save(user) { [weak self] result in
            switch result {
            case .failure:
                print("upload fail")
                ErrorPresenter.showError(message: "There was a problem creating annotation!", on: self)
            case .success:
                DispatchQueue.main.async { [weak self] in
                    print("successful created annotation!")
                    DidRequestServer.successful(on: self, title: "Sucessful create a annotation!")
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

}

//MARK: Keyboard.
extension UploadAnnotationViewController: UITextFieldDelegate {
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardRect.height
            UIView.animate(withDuration: 0.3,
                           delay: 0.1,
                           options: [.curveEaseIn],
                           animations: { [weak self] in
                            self?.csBottomTableView.constant = self!.keyboardHeight
                           }, completion: nil)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.1,
                       options: [.curveEaseIn],
                       animations: { [weak self] in
                        self?.csBottomTableView.constant = 0
                       }, completion: nil)
        view.layoutIfNeeded()
//            if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//                UIView.animate(withDuration: 0.3,
//                               delay: 0.1,
//                               options: [.curveEaseIn],
//                               animations: { [weak self] in
//                               }, completion: nil)
    }
}

