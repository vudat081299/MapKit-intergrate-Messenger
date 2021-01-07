//
//  AnnotationView.swift
//  MyMapKit
//
//  Created by Vũ Quý Đạt  on 11/12/2020.
//

import Foundation
import MapKit

// MARK: - Global consts.
struct AnnotationConfig {
    static let length_edge = 40
    static let border_width = CGFloat(3)
    static let border_color = UIColor.white.cgColor
}

//class ArtworkMarkerView: MKMarkerAnnotationView {
//  override var annotation: MKAnnotation? {
//    willSet {
//      // 1
//      guard let artwork = newValue as? Artwork else {
//        return
//      }
//      canShowCallout = true
//      calloutOffset = CGPoint(x: -5, y: 5)
//      rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//
//      // 2
//      markerTintColor = artwork.markerTintColor
//      glyphImage = artwork.image
//    }
//  }
//}

class AnnotationView: MKAnnotationView {
    
    var imageView: UIImageView!
    
    var currentAnnotation: Annotation! // current interacting Annotation
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
        }
    }
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let artwork = newValue as? Annotation else {
                return
            }
            currentAnnotation = artwork
            
            if imageView != nil {
                imageView.removeFromSuperview()
            }
            if currentAnnotation.type == "6" || currentAnnotation.type == "7" {
                let edge = 2 * AnnotationConfig.length_edge
                frame = CGRect(x: 0, y: 0, width: edge, height: edge)
                imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: edge, height: edge))
                imageView.backgroundColor = UIColor.white
                imageView.roundedBorder()
                imageView.layer.borderWidth = AnnotationConfig.border_width
                imageView.layer.borderColor = UIColor.clear.cgColor
                zPriority = .max 
            } else {
                frame = CGRect(x: 0, y: 0, width: AnnotationConfig.length_edge, height: AnnotationConfig.length_edge)
                imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: AnnotationConfig.length_edge, height: AnnotationConfig.length_edge))
                imageView.backgroundColor = UIColor.white
                imageView.roundedBorder()
                imageView.layer.borderWidth = AnnotationConfig.border_width
                imageView.layer.borderColor = AnnotationConfig.border_color
                zPriority = .min
            }
            addSubview(imageView)
            
            canShowCallout = true
            calloutOffset = CGPoint(x: 0, y: 0)
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 40, height: 40)))
            mapsButton.setBackgroundImage(currentAnnotation.image, for: .normal)
            leftCalloutAccessoryView = mapsButton
            
            // image on map
            image = currentAnnotation.image
            
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = currentAnnotation.subtitle
            detailCalloutAccessoryView = detailLabel
            
            // custom
            let rightButton1 = UIButton(type: .detailDisclosure)
            let rightButton2 = UIButton()
            let myRightView = UIView()
            
            rightButton1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            rightButton2.setBackgroundImage(#imageLiteral(resourceName: "Map"), for: .normal)
            rightButton2.frame = CGRect(x: 30, y: 0, width: 48, height: 48)
            rightButton1.center.y = rightButton2.center.y
            
            myRightView.frame = CGRect(x: 0, y: 0, width: 78, height: 48)
            myRightView.addSubview(rightButton1)
            myRightView.addSubview(rightButton2)
            rightCalloutAccessoryView = myRightView
            
            rightButton1.addTarget(self, action: #selector(button1DidClick), for: .touchUpInside)
            rightButton2.addTarget(self, action: #selector(button2DidClick), for: .touchUpInside)
        }
    }
    
    @objc func button1DidClick() {
        
    }
    
    @objc func button2DidClick() {
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        currentAnnotation.mapItem?.openInMaps(launchOptions: launchOptions)
    }
}
