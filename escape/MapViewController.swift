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

enum MarkerType {
    case me
    case available
    case selected
}

extension AGSPoint {
    private func _markerImage(type: MarkerType) -> UIImage {
        switch type {
        case .me:
            return #imageLiteral(resourceName: "Marker")
        case .available:
            return #imageLiteral(resourceName: "MarkerAvailable")
        case .selected:
            return #imageLiteral(resourceName: "MarkerSelected")
        }
    }
    
    
    func marker(type: MarkerType) -> AGSGraphic {
        let markerImage = _markerImage(type: type).resize(newWidth: 90)
        let symbol = AGSPictureMarkerSymbol(image: markerImage)
        
        symbol.leaderOffsetY = markerImage.size.height / 4
        symbol.offsetY = markerImage.size.height / 4
        
        return AGSGraphic(geometry: self, symbol: symbol, attributes: nil)
    }
}

class MapViewController: UIViewController, AGSGeoViewTouchDelegate {
    private lazy var origin: AGSPoint = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2DMake(37.7758293, -122.3863622))
    
    private lazy var points: [AGSPoint] = [
        AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2DMake(37.7718412, -122.393519)),
        AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2DMake(37.7788752, -122.394988)),
        AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2DMake(37.7814721, -122.389245))
    ]
    
    private lazy var center: AGSPoint = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2DMake(37.7769039, -122.3904595)) // SF Pier 48
    private lazy var mapView: AGSMapView = {
        let ret = AGSMapView()
        
        ret.map = AGSMap(basemapType: .darkGrayCanvasVector, latitude: self.center.x, longitude: self.center.y, levelOfDetail: 10)
        ret.touchDelegate = self
        
        return ret
    }()
    
    private lazy var graphicsOverlay: AGSGraphicsOverlay = {
        let ret = AGSGraphicsOverlay()
        
        ret.graphics.add(self.origin.marker(type: .me))
        
        return ret
    }()
    
    private var tapTimer: TimeInterval = 0
    private var animationFinished: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.isNavigationBarHidden = false

        self.title = "Pick Location"
        self.view.addSubview(mapView)
        self.mapView.setViewpoint(AGSViewpoint(center: self.center, scale: 12000.0), duration: 4.0)
        self.mapView.graphicsOverlays.add(self.graphicsOverlay)
        
        points.forEach({ (pnt) in
            let marker = pnt.marker(type: .available)
            
            marker.isVisible = false
            
            self.graphicsOverlay.graphics.add(marker)
        })
        
        Timer.scheduledTimer(withTimeInterval: 6, repeats: false) { [weak self] (tm) in
            guard let weakSelf = self else { return tm.invalidate() }
            
            weakSelf.graphicsOverlay.graphics.forEach({ (el) in
                if let elem = el as? AGSGraphic {
                    elem.isVisible = true
                }
            })
                        
            weakSelf.animationFinished = true
        }
        
        constrain(mapView) { mapView in
            mapView.edges == mapView.superview!.edges
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func _genTime() -> String {
        let timeFormatter = DateFormatter()
        
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        
        let leaveTime: TimeInterval = Date().timeIntervalSince1970 + 15 * 60
        
        for i in 0..<900 {
            if Int(floor(leaveTime + Double(i))) % 900 == 0 {
                return timeFormatter.string(from: Date(timeIntervalSince1970: floor(leaveTime + Double(i))))
            }
        }
        
        return timeFormatter.string(from: Date(timeIntervalSince1970: leaveTime))
    }
    
    func geoView(_ geoView: AGSGeoView, didTapAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
        if !animationFinished || (tapTimer != 0 && Date().timeIntervalSince1970 - tapTimer < 2) {
            return
        }
        
        tapTimer = Date().timeIntervalSince1970
        
        if self.mapView.callout.isHidden {
            self.mapView.callout.image = #imageLiteral(resourceName: "Seva")
            self.mapView.callout.title = "Seva Brekelov"
            
            self.mapView.callout.detail = "3 spaces / " + _genTime()
            self.mapView.callout.isAccessoryButtonHidden = false
            // self.mapView.callout.accessoryButtonImage
            self.mapView.callout.show(at: mapPoint, screenOffset: .zero, rotateOffsetWithMap: false, animated: true)
        } else {
            self.mapView.callout.isHidden = true
            tapTimer = 0
        }
    }

}

