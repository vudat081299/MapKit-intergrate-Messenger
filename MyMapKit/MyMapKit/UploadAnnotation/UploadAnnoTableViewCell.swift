//
//  UploadAnnoTableViewCell.swift
//  MyMapKit
//
//  Created by Vũ Quý Đạt  on 20/12/2020.
//

import UIKit

class UploadAnnoTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var textInput: UITextField!
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textInput.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func didEdit(_ sender: UITextField) {
        if indexPath?.row == 0 {
            uploadAnnotationData.title = textInput.text!
        } else if indexPath?.row == 1 {
            uploadAnnotationData.subTitle = textInput.text!
        } else if indexPath?.row == 2 {
            uploadAnnotationData.description = textInput.text!
        }
        print(textInput.text)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let set = NSCharacterSet(charactersIn: "ABCDEFGHIJKLMONPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 ").inverted
        return (string.rangeOfCharacter(from: set) == nil)

//        if let x = string.rangeOfCharacter(from: NSCharacterSet.decimalDigits) {
//            return true
//         } else {
//         return false
        
        let allowedCharacters = CharacterSet.letters.union(CharacterSet(charactersIn: " "))
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        // check characters
        guard newText.rangeOfCharacter(from: allowedCharacters.inverted) == nil else { return false }
        
        
        return true
        
    }
}
