//
//  MapViewController.swift
//  Navigation
//
//  Created by Евгений Дроздов on 02.05.2023.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    var addressOfCity: String?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    private lazy var networkManager = CLLocationManager()
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.showsCompass = true
        // ловить тему нужно будет
        map.overrideUserInterfaceStyle = .unspecified
        map.mapType = .standard
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    private func setupView(){
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
    
    private func setupNavigationBar(){
        navigationItem.title = "Маршрут"
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // создаю новый объект в верхнем баре
        let newTown = UIBarButtonItem(image: UIImage(systemName: "location.magnifyingglass"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(newTownTapped))
        
        // добавляю его в доступные к выводу справа и слева
        navigationItem.rightBarButtonItems = [newTown]
    }
    
    @objc private func newTownTapped(){
        
        TextPicker.defaultPicker.getText(in: self) { text in
            self.addressOfCity = text
            if self.addressOfCity != "" || self.addressOfCity != nil {
                self.forwardGeocoding(address: self.addressOfCity!) { data in
                    self.latitude = data.latitude
                    self.longitude = data.longitude
                    
                    print(self.addressOfCity!)
                    print(self.latitude!)
                    print(self.longitude!)
                    
                    self.setPinAndMakeRoute(lat: self.latitude!, lot: self.longitude!)
                } } else {
                    print("nil field")
                }
        }
    }
    
    private func forwardGeocoding(address: String, completion: @escaping ((CLLocationCoordinate2D) -> Void)) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print("Failed to retrieve location")
                return
            }
            
            var location: CLLocation?
            
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
                let coordinate = location.coordinate
                print("\nlat: \(coordinate.latitude), long: \(coordinate.longitude)")
                completion(coordinate)
            }
            else
            {
                print("No Matching Location Found")
            }
        })
    }
    
    
    private func requestCurrentUserLocation(){
        networkManager.requestWhenInUseAuthorization()
        networkManager.delegate = self
        networkManager.startUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestCurrentUserLocation()
        setupView()
        setupNavigationBar()
        
    }
    
    private func setPinAndMakeRoute(lat: CLLocationDegrees, lot: CLLocationDegrees){
        let coordinates: CLLocationCoordinate2D?
        let begginDote: MKPlacemark?
        let distinationDote: MKPlacemark?
        let request = MKDirections.Request()
        let direction: MKDirections?
        
        if networkManager.authorizationStatus.rawValue == 4 {
            coordinates = CLLocationCoordinate2D(latitude: lat, longitude: lot)
            begginDote = MKPlacemark(coordinate: coordinates!)
            distinationDote = MKPlacemark(coordinate: CLLocationCoordinate2D(
                latitude: lat + 0.5,
                longitude: lot + 0.5))
            request.source = MKMapItem(placemark: begginDote!)
            request.destination = MKMapItem(placemark: distinationDote!)
            request.transportType = .any
            
            direction = MKDirections(request: request)
            direction!.calculate { response, error in
                if error == nil {
                    let rout = response!.routes[0]
                    self.mapView.addOverlay(rout.polyline, level: .aboveRoads)
                    self.mapView.delegate = self
                    let rect = rout.polyline.boundingMapRect
                    self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
                } else { print(error!.localizedDescription) }
            }
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates!
            mapView.addAnnotation(annotation)
            
            let center = coordinates!
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: center, span: span)
            mapView.setRegion(region, animated: true)
            
        } else {
            print("Нет разрешения, ничего не делай")
        }
    }
}

extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {return}
        
        let region = MKCoordinateRegion(center: location.coordinate,
                                        span: MKCoordinateSpan(latitudeDelta: 40, longitudeDelta: 40))
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = .blue
        render.lineWidth = 6
        return render
    }
}
