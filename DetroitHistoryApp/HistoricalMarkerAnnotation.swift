//
//  HistoricalMarkerAnnotation.swift
//  DetroitHistoryApp
//
//  Created by Waleed Johnson on 8/17/18.
//  Copyright © 2018 Waleed Johnson. All rights reserved.
//

import Foundation
import MapKit

class HistoricalMarkerAnnotation: MKPointAnnotation {
    var historicalMarker: HistoricalMarker?
    
    convenience init(marker: HistoricalMarker) {
        self.init()
        self.historicalMarker = marker
        self.title = marker.markerName
        self.coordinate = CLLocationCoordinate2D(latitude: marker.latitude, longitude: marker.longitude)
    }
}
