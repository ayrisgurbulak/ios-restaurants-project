import Foundation
import CoreLocation

struct RestaurantDataManager {
    
    //escaping internetten veri çekilirken uygulama hızını etkiler. Uygulama açıldıktan sonra içeriklerin indirildiklerinde ortaya çıkmasını sağlar.
    func fetchPlaces(coordinate: CLLocationCoordinate2D, radius: Double, completion: @escaping (Response) ->Void ) {
        
        let lat = String(format: "%.6f", coordinate.latitude)
        let lng = String(format: "%.6f", coordinate.longitude)
        
        var restaurantUrl = "\(C.Urls.restaurantsUrl)&location=\(lat) \(lng)&radius=\(radius)"
        
        //print(restaurantUrl)
        
        restaurantUrl = restaurantUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? restaurantUrl
        
        //print(restaurantUrl)
        
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
    
    func fetchRoute(url: String, completion: @escaping (Directions) ->Void){
        
        if let url = URL(string: url) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
               
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    
                    let decoder = JSONDecoder()
                    do {
                        
                        let points = try decoder.decode(Directions.self, from: safeData)
                        completion(points)
                        
                    } catch {
                        
                        print(error)
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
            
            return places
            
        }catch {
            print(error)
            return nil
        }
    }
    
    
}
