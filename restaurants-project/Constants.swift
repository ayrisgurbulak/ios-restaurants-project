import Foundation

struct C {
    static let appName = "Restaurants"
    static let signupSegue = "SignupToTabbar"
    static let loginSegue = "LoginToTabbar"
    
    struct Urls {
        static let restaurantsUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?rankby=prominence&sensor=true&key=\(googleAPIKey)&types=restaurant"
        
        static let directionUrl = "https://maps.googleapis.com/maps/api/directions/json?mode=driving&key=\(googleAPIKey)"
    }
}
