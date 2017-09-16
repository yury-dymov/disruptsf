//
//  ViewController.swift
//  escape
//
//  Created by Yury Dymov on 9/16/17.
//  Copyright © 2017 Yury Dymov. All rights reserved.
//

import UIKit
import ArcGIS
import Cartography

class MapViewController: UIViewController {
    private lazy var origin: AGSPoint = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2DMake(37.7758293, -122.3863622))
    private lazy var center: AGSPoint = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2DMake(37.7769039, -122.3904595)) // SF Pier 48
    private lazy var mapView: AGSMapView = {
        let ret = AGSMapView()
        
        ret.map = AGSMap(basemapType: .darkGrayCanvasVector, latitude: self.center.x, longitude: self.center.y, levelOfDetail: 10)
        
        return ret
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(mapView)
        self.mapView.setViewpoint(AGSViewpoint(center: self.center, scale: 12000.0), duration: 4.0)
        
        constrain(mapView) { mapView in
            mapView.edges == mapView.superview!.edges
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

