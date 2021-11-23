

import Foundation
import CoreLocation

struct RestaurantDataManager {
    
    //escaping internetten veri çekilirken uygulama hızını etkiler. Uygulama açıldıktan sonra içeriklerin indirildiklerinde ortaya çıkmasını sağlar.
    func fetchPlaces(coordinate: CLLocationCoordinate2D, radius: Double, completion: @escaping (Response) ->Void ) {
        
        let lat = String(format: "%.6f", coordinate.latitude)
        let lng = String(format: "%.6f", coordinate.longitude)
        
//        print("lat:",lat)
//        print("lng:",lng)
        
        var restaurantUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat) \(lng)&radius=\(radius)&rankby=prominence&sensor=true&key=\(googleAPIKey)&types=restaurant"
        
        restaurantUrl = restaurantUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? restaurantUrl
        
        if let url = URL(string: restaurantUrl) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    
                    if let places = parseJSON(safeData) {
                        completion(places)
                    }
                }
            }
            
            task.resume()
        }
        
    }
    
    func parseJSON(_ places: Data) -> Response? {
        let decoder = JSONDecoder()
        
        do{
            let places = try decoder.decode(Response.self, from: places)
            
//            let name = decodedData.results[0].name
//            let address = decodedData.results[0].vicinity
//            let rating = decodedData.results[0].rating
//
//            let place = RestaurantModel(restaurantName: name, restaurantAdress: address, restaurantRating: rating)
            
            return places
            
        }catch {
            print(error)
            return nil
        }
    }
    
    
}
