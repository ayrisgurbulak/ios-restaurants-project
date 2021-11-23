
import Foundation


struct RestaurantModel {
    let restaurantName: String
    let restaurantAdress: String
    let restaurantRating: Double
    
    var ratingString: String {
        return String(format: "%.1f", restaurantRating)
    }
    
}
