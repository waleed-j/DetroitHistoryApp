//
//  ViewController.swift
//  DetroitHistoryApp
//
//  Created by Waleed Johnson on 8/12/18.
//  Copyright © 2018 Waleed Johnson. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit
import RealmSwift

class ViewController: UIViewController, MKMapViewDelegate {

    var historicalMarkers : List<HistoricalMarker> = List<HistoricalMarker>()
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 3000
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Center Map on Campus Martius Origin Point Location
        let initialLocation = CLLocation(latitude: 42.331600, longitude: -83.046714)
        centerMapOnLocation(location: initialLocation)
        
        let realm = try! Realm()
        let data = realm.objects(MarkerDataWrapper.self)
        let dataWrapper = (data.count > 0) ? data[0] : nil
        if (dataWrapper != nil && !HelperFunctions.shouldQueryAPI(data: dataWrapper!)) {
            // Data has been pulled recently and no need to update
            self.historicalMarkers = dataWrapper!.markers!
            self.setUpMapMarkers()
        } else {
            queryAPI(realm: realm, updateDB: data.count > 0)
        }
        
    }
    
    func queryAPI(realm: Realm, updateDB: Bool){
        // TODO: Better formatting of request
        Alamofire.request(HelperFunctions.API_URL, method: .get)
            .responseJSON { response in
                if response.data != nil {
                    let json = try? JSON(data: response.data!)
                    var features = json!["features"]
                    
                    // Test code. Tests the case of an update to the marker
                    // also the other test tests a new marker being added
                  //  features = [features[0]]
                  //  features[0]["attributes"]["Marker_Name"] = "Waleed"
                  //  features = [features[0], features[1]]
                  //  features[1]["attributes"]["HM_ID"] = "new-marker"
                  //  features[1]["attributes"]["Marker_Name"] = "Testing Marker"
                  //  features[1]["attributes"]["Latitude"] = 42.321788
                  //  features[1]["attributes"]["Longitude"] = -83.048616
                    
                    for element in features {
                        let marker = element.1
                        if(updateDB){
                            HistoricalMarker.handleUpdateRequest(markerJSON: marker)
                        } else {
                            self.historicalMarkers.append(HistoricalMarker(markerJson: marker))
                        }
                    }
                    
                    let realm = try! Realm()
                    if (updateDB){
                        //TODO: Make More Efficient
                        //Need to get from DB cause even if you updated them
                        //need to get proper visited value
                        self.historicalMarkers = HistoricalMarker.fetchAllAsList()
                    } else {
                        // Write New Data
                        realm.beginWrite()
                        let dataWrapper = MarkerDataWrapper(markers: self.historicalMarkers, date: Date())
                        realm.add(dataWrapper)
                        try! realm.commitWrite()
                    }
                    
                    self.setUpMapMarkers()
                }
        }
        
        // TODO: Handle Alamofire error
    }

    // MARK: MapFunctions
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    func setUpMapMarkers(){
        for historicalMarker in historicalMarkers {
            let marker = MKPointAnnotation()
            marker.title = historicalMarker.markerName
            marker.coordinate = CLLocationCoordinate2D(latitude: historicalMarker.latitude, longitude: historicalMarker.longitude)
            mapView.addAnnotation(marker)
        }
    }
    
    // MARK: MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
}

// TODO: Handle the case of if something was deleted in the API
