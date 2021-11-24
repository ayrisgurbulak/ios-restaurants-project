import Foundation
import CoreLocation

struct RestaurantData: Decodable {
    let name: String
    let vicinity: String
    let types: [String]
    let rating: Double
    
    private let geometry: Geometry
    
    var coordinate: CLLocationCoordinate2D {
      return CLLocationCoordinate2D(latitude: geometry.location.lat, longitude: geometry.location.lng)
    }
    
}

enum CodingKeys: String, CodingKey {
  case name
  case vicinity
  case types
  case rating
  case geometry
}

struct Response: Decodable {
  let results: [RestaurantData]
  let errorMessage: String?
}

private struct Geometry: Decodable {
  let location: Location
}

private struct Location: Decodable {
  let lat: CLLocationDegrees
  let lng: CLLocationDegrees
}

