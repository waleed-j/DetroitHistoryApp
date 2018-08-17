//
//  HistoricalMarker.swift
//  DetroitHistoryApp
//
//  Created by Waleed Johnson on 8/13/18.
//  Copyright © 2018 Waleed Johnson. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class HistoricalMarker: Object {
    @objc dynamic var id = ""
    @objc dynamic var markerName = ""
    @objc dynamic var markerNameBack: String?
    @objc dynamic var markerFrontDescription = ""
    @objc dynamic var markerBackDescription: String?
    @objc dynamic var erectedYear = 0
    @objc dynamic var nationalRegistryDate = 0.0
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    @objc dynamic var markerAddress = ""
    @objc dynamic var keyword = ""
    @objc dynamic var markerLocationMiscInfo = ""
    @objc dynamic var visited = true
    
    convenience init(markerJson: JSON) {
        self.init()
        copyData(markerJSON: markerJson, isUpdateRequest: false)
    }
    
    private func copyData(markerJSON: JSON, isUpdateRequest: Bool){
        let attributes = markerJSON["attributes"]
        if (!isUpdateRequest) { id = attributes["HM_ID"].stringValue }
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
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func fetchById(id: String, realm: Realm) -> HistoricalMarker? {
        let predicate = NSPredicate(format: "id = %@", id)
        if let marker = realm.objects(HistoricalMarker.self).filter(predicate).first {
            return marker
        } else {
            return nil
        }
    }
    
    static func fetchAll() -> [HistoricalMarker] {
        return Array(try! Realm().objects(HistoricalMarker.self))
    }
    
    static func fetchAllAsList() -> List<HistoricalMarker> {
        let list = List<HistoricalMarker>()
        list.append(objectsIn: fetchAll())
        return list
    }
    
    public func updateNewDataFromWebsite(markerJSON: JSON) {
        let realm = try! Realm()
        realm.beginWrite()
        copyData(markerJSON: markerJSON, isUpdateRequest: true)
        try! realm.commitWrite()
    }
    
    static func handleUpdateRequest(markerJSON: JSON) {
        let attributes = markerJSON["attributes"]
        let id = attributes["HM_ID"].stringValue
        let realm = try! Realm()
        //If element is already stored, update properties
        if let elementAlreadyStored = HistoricalMarker.fetchById(id: id, realm: realm) {
            elementAlreadyStored.updateNewDataFromWebsite(markerJSON: markerJSON)
        } else {
            //If a new marker is added to the master data set, add it to our copy
            let dataWrapper = realm.objects(MarkerDataWrapper.self).first
            if dataWrapper != nil {
                realm.beginWrite()
                dataWrapper!.markers?.append(HistoricalMarker(markerJson: markerJSON))
                try! realm.commitWrite()
            }
        }
    }
}
