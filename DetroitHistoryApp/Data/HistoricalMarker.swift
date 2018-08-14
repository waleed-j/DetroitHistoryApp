//
//  HistoricalMarker.swift
//  DetroitHistoryApp
//
//  Created by Waleed Johnson on 8/13/18.
//  Copyright © 2018 Waleed Johnson. All rights reserved.
//

import Foundation
import SwiftyJSON

class HistoricalMarker {
    var markerName = ""
    var markerNameBack: String?
    var markerFrontDescription = ""
    var markerBackDescription: String?
    var erectedYear = 0
    var nationalRegistryDate = 0.0
    var latitude = 0.0
    var longitude = 0.0
    var markerAddress = ""
    var keyword = ""
    var markerLocationMiscInfo = ""
    var visited = false
    
    init(markerJson: JSON) {
        let attributes = markerJson["attributes"]
        markerFrontDescription = attributes["Marker_Desc_Front"].stringValue
        markerBackDescription = attributes["Marker_Desc_Back"].stringValue
        markerName = attributes["Marker_Name"].stringValue
        markerNameBack = attributes["Marker_Name_Back"].stringValue
        latitude = attributes["Latitude"].doubleValue
        longitude = attributes["Longitude"].doubleValue
        erectedYear = attributes["Erected_Date"].intValue
        nationalRegistryDate = attributes["National_Registry_Date"].doubleValue
        keyword = attributes["Keyword"].stringValue
        markerAddress = attributes["Marker_Location_Address"].stringValue
        markerLocationMiscInfo = attributes["Marker_Location_Misc"].stringValue
    }
}
