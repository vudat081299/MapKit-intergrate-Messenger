//
//  Annotation.swift
//  MyMapKit
//
//  Created by Vũ Quý Đạt  on 11/12/2020.
//

import Foundation
import MapKit
import Contacts

class Annotation: NSObject, MKAnnotation {
    let title: String?
    let mySubTitle: String?
    let annoDescription: String?
    let id: String
    let discipline: String?
    let coordinate: CLLocationCoordinate2D
    let type: String?
    let imageNote: String?
    let country: String?
    let city: String?
  
  init(
    title: String?,
    annoDescription: String?,
    locationName: String?,
    id: String?,
    discipline: String?,
    coordinate: CLLocationCoordinate2D,
    type: String?,
    imageNote: String?,
    country: String?,
    city: String?
  ) {
    self.title = title
    self.mySubTitle = locationName
    self.annoDescription = annoDescription
    self.id = id!
    self.discipline = discipline
    self.coordinate = coordinate
    self.type = type
    self.imageNote = imageNote
    self.country = country
    self.city = city
    
    super.init()
  }
  
  init?(feature: MKGeoJSONFeature) {
    // 1
    guard
      let point = feature.geometry.first as? MKPointAnnotation,
      // 2
      let propertiesData = feature.properties,
      let json = try? JSONSerialization.jsonObject(with: propertiesData),
      let properties = json as? [String: Any]
      else {
        return nil
    }
    
    // 3
    title = (properties["title"] as? String) ?? "Updating name..."
    mySubTitle = (properties["subTitle"] as? String) ?? "Updating..."
    annoDescription = (properties["description"] as? String) ?? "Updating description..."
    id = (properties["id"] as? String) ?? "Updating description..."
    discipline = "Mural"
    coordinate = point.coordinate
    type = (properties["type"] as? String) ?? "Mural"
    imageNote = (properties["imageNote"] as? String) ?? "Mural"
    city = (properties["city"] as? String) ?? "Earth"
    country = (properties["country"] as? String) ?? "Earth"
    
    super.init()
  }
  
  var subtitle: String? {
    return mySubTitle
  }
  
  var mapItem: MKMapItem? {
    guard let location = mySubTitle else {
      return nil
    }
    
    let addressDict = [CNPostalAddressStreetKey: location]
    let placemark = MKPlacemark(
      coordinate: coordinate,
      addressDictionary: addressDict)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = title
    return mapItem
  }
  
  var markerTintColor: UIColor  {
    switch discipline {
    case "Monument":
      return .red
    case "Mural":
      return .cyan
    case "Plaque":
      return .blue
    case "Sculpture":
      return .purple
    default:
      return .green
    }
  }
  
  var image: UIImage {
    // original
//    guard let name = type else { return #imageLiteral(resourceName: "Flag") }
//    switch name {
//    case "Monument":
//      return #imageLiteral(resourceName: "defaultAvatar")
//    case "Sculpture":
//      return #imageLiteral(resourceName: "defaultAvatar_icon")
//    case "Plaque":
//      return #imageLiteral(resourceName: "defaultAvatar")
//    case "Mural":
//      return #imageLiteral(resourceName: "defaultAvatar_icon")
//    default:
//      return #imageLiteral(resourceName: "defaultAvatar_icon")
//    }
    
    // custom
    let nameType = TypeAnnotation(rawValue: Int(type!)!)
    
    switch nameType {
    case .publibPlace: //publibPlace
        return #imageLiteral(resourceName: "Flag")
    case .restaurant:
        return #imageLiteral(resourceName: "restaurant")
    case .coffeeShop:
        return #imageLiteral(resourceName: "coffee_shop")
    case .clothesShop:
        return #imageLiteral(resourceName: "clothes_store")
    case .pharmacy:
        return #imageLiteral(resourceName: "pharmacy")
    case .superMaket:
        return #imageLiteral(resourceName: "super_market")
    case .virus:
        return #imageLiteral(resourceName: "virus")
    case .sos:
        return #imageLiteral(resourceName: "sos")
        
    default:
        return #imageLiteral(resourceName: "Flag")
    }
    
  }
}
