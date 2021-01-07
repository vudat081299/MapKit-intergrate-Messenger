//
//  PickTypePlaceTableViewCell.swift
//  MyMapKit
//
//  Created by Vũ Quý Đạt  on 20/12/2020.
//

import UIKit

class PickTypePlaceTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var pickerTypePlace: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typeAnnotationText[row]
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
