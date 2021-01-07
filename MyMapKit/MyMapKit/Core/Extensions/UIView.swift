//
//  UIView.swift
//  MyMapKit
//
//  Created by Vũ Quý Đạt  on 18/12/2020.
//

import UIKit

extension UIView {
    func roundedBorder() {
        clipsToBounds = true
        layer.cornerRadius = self.frame.size.height / 2
    }
    func border(_ radius: CGFloat = 10) {
        clipsToBounds = true
        layer.cornerRadius = radius
    }
    func minEdgeBorder() {
        clipsToBounds = true
        layer.cornerRadius = frame.size.height > frame.size.width ? frame.size.width / 2 : frame.size.height / 2
    }
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        layer.shadowRadius = 3.0
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
