//
//  HelperFunctions.swift
//  DetroitHistoryApp
//
//  Created by Waleed Johnson on 8/16/18.
//  Copyright © 2018 Waleed Johnson. All rights reserved.
//

import Foundation

class HelperFunctions {
    // Using amount of seconds in a month
    // Query should only be run infrequently since
    // Historical markers are not added frequently
    static private var UPDATE_TIME_IN_SECONDS = -2629746.0
    //Debug Value
    //static private var UPDATE_TIME_IN_SECONDS = -15.0
    static public let API_URL = "https://services3.arcgis.com/Jdnp1TjADvSDxMAX/arcgis/rest/services/pub_HistoricalMarkers///FeatureServer/0/query?where=Marker_Location_City=%27Detroit%27&outFields=*&outSR=4326&f=json"
    
    static func shouldQueryAPI(data: MarkerDataWrapper) -> Bool {
        return data.updatedDate!.timeIntervalSinceNow < UPDATE_TIME_IN_SECONDS
    }
}
