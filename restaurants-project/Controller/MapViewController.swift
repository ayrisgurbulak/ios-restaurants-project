import UIKit
import GoogleMaps
import FirebaseAuth

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    let locationManager = CLLocationManager()
    private let dataProvider = RestaurantDataManager()
    private let searchRadius: Double = 1500
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self

        if CLLocationManager.locationServicesEnabled() {
            
          locationManager.requestLocation()
            
          mapView.isMyLocationEnabled = true
          mapView.settings.myLocationButton = true
            
        } else {
          locationManager.requestWhenInUseAuthorization()
        }
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func fetchPlaces(with coordinate: CLLocationCoordinate2D) {
      mapView.clear()
      
        dataProvider.fetchPlaces(coordinate: coordinate, radius: searchRadius) { places in
            places.results.forEach { place in
                DispatchQueue.main.async {
                    let marker = RestaurantMarker(place: place)
                    print("marker:",marker)
                    marker.map = self.mapView
                    
                }
            }
        }
    }
    

}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    
  func locationManager(_ manager: CLLocationManager,didChangeAuthorization status: CLAuthorizationStatus) {
      
    /*guard status == .authorizedWhenInUse else {
      return
    }*/
      
    locationManager.requestLocation()

    mapView.isMyLocationEnabled = true
    mapView.settings.myLocationButton = true
      
  }

  func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [CLLocation]) {
    
    guard let location = locations.first else {
      return
    }

    mapView.camera = GMSCameraPosition(
      target: location.coordinate,
      zoom: 15,
      bearing: 0,
      viewingAngle: 0)
      
      fetchPlaces(with: location.coordinate)
  }

  func locationManager(_ manager: CLLocationManager,didFailWithError error: Error) {
    print(error)
  }
}


// MARK: - GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        
        guard let placeMarker = marker as? RestaurantMarker else {
          return nil
        }
        
        print(placeMarker.place.name)
        
        return nil
    }
    
}


