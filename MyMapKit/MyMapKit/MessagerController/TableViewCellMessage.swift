//
//  TableViewCellMessage.swift
//  MessageApp
//
//  Created by Vũ Quý Đạt  on 2/14/20.
//  Copyright © 2020 VU QUY DAT. All rights reserved.
//

import UIKit

class TableViewCellMessage: UITableViewCell {

    @IBOutlet weak var sentMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
