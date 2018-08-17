//
//  HistoricalMarkerAnnotationView.swift
//  DetroitHistoryApp
//
//  Created by Waleed Johnson on 8/17/18.
//  Copyright © 2018 Waleed Johnson. All rights reserved.
//

import Foundation
import MapKit

class HistoricalMarkerAnnotationView: MKMarkerAnnotationView {
    static public let IDENTIFIER = "marker"
    
    public func setViewBackground() {
        if let annotation = self.annotation as? HistoricalMarkerAnnotation {
            self.markerTintColor = (annotation.historicalMarker!.visited) ? UIColor.green : UIColor.red
        }
    }
}
