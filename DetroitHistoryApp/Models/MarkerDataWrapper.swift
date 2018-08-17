//
//  MarkerDataWrapper.swift
//  DetroitHistoryApp
//
//  Created by Waleed Johnson on 8/16/18.
//  Copyright © 2018 Waleed Johnson. All rights reserved.
//

import Foundation
import RealmSwift

class MarkerDataWrapper: Object {
    @objc dynamic var updatedDate: Date? = Date()
    var markers: List<HistoricalMarker>? = List<HistoricalMarker>()
    
    convenience init(markers: List<HistoricalMarker>, date: Date) {
        self.init()
        self.updatedDate = date
        self.markers = markers
    }
}
