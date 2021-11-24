import UIKit
import GoogleMaps

class RestaurantMarker: GMSMarker {
  let place: RestaurantData
  
  init(place: RestaurantData) {
    self.place = place
    super.init()

    position = place.coordinate
    groundAnchor = CGPoint(x: 0.5, y: 1)
    appearAnimation = .pop
    icon = UIImage(named: "restaurant_pin")
  }
}
