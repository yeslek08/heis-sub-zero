//
//  Map.swift
//  experimentation
//
//  Created by l00p on 8/9/16.
//  Copyright © 2016 l00p. All rights reserved.
//

import Foundation
import GoogleMaps

class Map {
    
    func makeMapView(_ latitudeVal: Double, longitudeVal: Double, zoomVal: Float) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: latitudeVal, longitude: longitudeVal, zoom: zoomVal)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        return mapView
    }
    
    func makeMarker(_ latitudeVal: Double, longitudeVal: Double, titleVal: String, snippetVal: String, myMapView: GMSMapView)
        -> GMSMarker {
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitudeVal, longitude: longitudeVal)
        marker.title = titleVal
        marker.snippet = snippetVal
        marker.map = myMapView
        return marker
    }
    
}
