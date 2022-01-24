import UIKit
import GoogleMaps
import FirebaseAuth
import CoreData

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    let locationManager = CLLocationManager()
    private let dataProvider = RestaurantDataManager()
    private let searchRadius: Double = 1500
    
    let infoView = Bundle.main.loadNibNamed("RestaurantInfo", owner: self, options: nil)![0] as! RestaurantInfo
    
    var userEmail: String?
    
    private let restaurantAnimate = RestaurantInfo()
    
    var oldPolyLines = [GMSPolyline]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        
        infoView.selectButton.addTarget(self, action: #selector(selectButtonPressed), for: .touchUpInside)
    
    }
    
    @objc func selectButtonPressed() {
        
        if let userEmail = userEmail {
            C.Db.db.collection("users").whereField("email", isEqualTo: userEmail).getDocuments() { snapshot, error in
                if let data = snapshot?.documents.first {
                    let uuid = data.data()["uuid"]!
                    C.Db.db.collection("users").document(uuid as! String).updateData(["restaurant" : self.infoView.restaurantLabel.text!])
                }
            }
        }
        
            
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
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if oldPolyLines.count > 0 {
            for polyline in oldPolyLines {
                polyline.map = nil
            }
        }
        
        guard let placeMarker = marker as? RestaurantMarker else {
          return false
        }
        
        infoView.restaurantLabel.text = placeMarker.place.name
        infoView.adressLabel.text = placeMarker.place.vicinity
        infoView.rateLabel.text = String(placeMarker.place.rating)
        
        infoView.restaurantLabel.numberOfLines = 0
        infoView.adressLabel.numberOfLines = 0 

        //create new design class for this
        infoView.frame = CGRect(x: 0.0 , y: 0.0, width: self.view.frame.width, height: self.view.frame.height * 0.25)
        infoView.layer.borderWidth = 1
        infoView.layer.borderColor = #colorLiteral(red: 0.7664160132, green: 0.7946894169, blue: 1, alpha: 1)
        
        view.addSubview(infoView)
        infoView.center.y = self.view.frame.height + 49
    
        
        infoView.animShow()
        
        guard let lat = locationManager.location?.coordinate.latitude else {
            return false
        }
        
        guard let lng = locationManager.location?.coordinate.longitude else {
            return false
        }
        
        let directionUrl = "\(C.Urls.directionUrl)&origin=\(lat),\(lng)&destination=\(placeMarker.place.coordinate.latitude),\(placeMarker.place.coordinate.longitude)"
        
        dataProvider.fetchRoute(url: directionUrl) { response in
            response.routes.forEach { r in
                
                DispatchQueue.main.async {
                    let path = GMSPath.init(fromEncodedPath: r.overview_polyline.points )
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeColor = .systemBlue
                    polyline.strokeWidth = 5
                    polyline.map = self.mapView
                    self.oldPolyLines.append(polyline)
                }
                
            }
        }
        
        return false
      }
    
    
}
