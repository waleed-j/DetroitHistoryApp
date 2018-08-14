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

class ViewController: UIViewController, MKMapViewDelegate {

    var historicalMarkers : [HistoricalMarker] = []
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 3000
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Campus Martius Origin Point Location
        let initialLocation = CLLocation(latitude: 42.331600, longitude: -83.046714)
        centerMapOnLocation(location: initialLocation)
        // Do any additional setup after loading the view, typically from a nib.
        let url = "https://services3.arcgis.com/Jdnp1TjADvSDxMAX/arcgis/rest/services/pub_HistoricalMarkers///FeatureServer/0/query?where=Marker_Location_City=%27Detroit%27&outFields=*&outSR=4326&f=json"
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.data != nil {
                    let json = try? JSON(data: response.data!)
                    let features = json!["features"]
                    for element in features {
                        self.historicalMarkers.append(HistoricalMarker(markerJson: element.1))
                    }
                    self.setUpMapMarkers()
                }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

